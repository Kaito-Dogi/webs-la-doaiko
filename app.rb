require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'sinatra/activerecord'
require './models'
require "google/apis/calendar_v3"
require "googleauth"
require "googleauth/stores/file_token_store"
require 'google-id-token'
require 'dotenv'

LOGIN_URL = '/'

configure do
    Dotenv.load

    Google::Apis::ClientOptions.default.application_name = 'DOAIKO'
    Google::Apis::ClientOptions.default.application_version = '0.9'
    Google::Apis::RequestOptions.default.retries = 3
    
    enable :sessions
    
    set :show_exceptions, false
    set :client_id, Google::Auth::ClientId.new(
        ENV['GOOGLE_CLIENT_ID'],
        ENV['GOOGLE_CLIENT_SECRET']
    )
    set :token_store, Google::Auth::Stores::FileTokenStore.new(file: "token.yaml")
end

helpers do
    # Returns credentials authorized for the requested scopes. If no credentials are available,
    # redirects the user to authorize access.
    def credentials_for(scope)
        authorizer = Google::Auth::WebUserAuthorizer.new(settings.client_id, scope, settings.token_store)
        user_id = session[:user_id]
        redirect LOGIN_URL if user_id.nil?
        credentials = authorizer.get_credentials(user_id, request)
        if credentials.nil?
            redirect authorizer.get_authorization_url(login_hint: user_id, request: request)
        end
        credentials
    end
    
    def resize(url, width)
        url.sub(/s220/, sprintf('s%d', width))
    end
end

get '/' do
    @client_id = settings.client_id.id
    puts "======================== #{session[:user_id]} ========================"
    puts "======================== #{session[:user_email]} ========================"
    # unless session[:user_id].nil?
    #     @user = User.find(session[:user_id]) 
    #     @user_courses = @user.user_courses
    #     @user_classrooms = @user.user_classrooms
    # end
    erb :home
end

get '/signup' do
    @areas = Area.all
    @classrooms = Classroom.all
    @courses = Course.all
    erb :signup, layout: nil
end

post '/signup' do
    user = User.create!(
        name: params[:name],
        email: params[:email],
        term: params[:term],
        image_url: "./assets/img/default_icon.png",
        area_id: params[:area_id],
        password: params[:password],
        password_confirmation: params[:password_confirmation]
    )
    if user.persisted?
        session[:user_id] = user.id
        
        course_ids = [
            params[:iphone],
            params[:android],
            params[:unity],
            params[:webd],
            params[:webs]
        ]
        course_ids.each do |course_id|
            unless course_id.nil?
                UserCourse.create!(
                    user_id: user.id,
                    course_id: course_id,
                    level: 1
                )
            end
        end
        
        classroom_ids = [
            params[:tue_weekly_shirokane],
            params[:wed_weekly_shirokane],
            params[:thu_weekly_shirokane],
            params[:fri_weekly_shirokane],
            params[:sat_weekly_shirokane],
            params[:sat_b_shirokane],
            params[:sun_a_shirokane],
            params[:sun_b_shirokane],
            params[:sun_b_akihabara],
            params[:sun_b_ikebukuro],
            params[:sat_a_yokohama],
            params[:sun_a_yokohama],
            params[:fri_weekly_osaka],
            params[:sat_a_osaka],
            params[:sun_a_osaka],
            params[:sun_b_osaka],
            params[:sat_a_nagoya],
            params[:sun_a_nagoya],
            params[:fri_weekly_online],
            params[:sat_weekly_online],
            params[:sun_b_online]
        ]
        classroom_ids.each do |classroom_id|
            unless classroom_id.nil?
                UserClassroom.create!(
                    user_id: user.id,
                    classroom_id: classroom_id
                )
            end
        end
    end
    
    redirect '/'
end

get '/signin' do
    erb :signin, layout: nil
end

post '/signin' do
    audience = settings.client_id.id
    validator = GoogleIDToken::Validator.new
    claim = validator.check(params['id_token'], audience, audience)
    if claim
        session[:user_id] = claim['sub']
        puts session[:user_id]
        session[:user_email] = claim['email']
        puts session[:user_email]
        200
    else
        logger.info('No valid identity token present')
        401
    end
    # user = User.find_by(name: params[:name])
    # if user && user.authenticate(params[:password])
    #     session[:user_id] = user.id
    #     puts "======================== #{session[:user_id]} ========================"
    # end
    # redirect '/'
end

get('/calendar') do
    calendar = Google::Apis::CalendarV3::CalendarService.new
    calendar.authorization = credentials_for(Google::Apis::CalendarV3::AUTH_CALENDAR)
    puts calendar.authorization
    calendar_id = 'primary'
    @result = calendar.list_events(
        calendar_id,
        max_results: 100,
        single_events: true,
        order_by: 'startTime',
        time_min: Time.now.iso8601,
        time_max: (Time.now + 60*60*24).iso8601
    )
    erb :calendar
end

get('/oauth2callback') do
    target_url = Google::Auth::WebUserAuthorizer.handle_auth_callback_deferred(request)
    redirect target_url
end

get '/signout' do
    session[:user_id] = nil
    redirect '/'
end

get '/mypage' do
    erb :mypage
end