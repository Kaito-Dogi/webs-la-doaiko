require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'sinatra/activerecord'
require './models'
require "googleauth"
require 'googleauth/web_user_authorizer'
require "googleauth/stores/file_token_store"
require "google/apis/calendar_v3"
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
    def credentials_for(scope)
    # def credentials_for(scope, user_id)
        authorizer = Google::Auth::WebUserAuthorizer.new(settings.client_id, scope, settings.token_store, '/oauth2callback')
        token_key = session[:token_key]
        redirect LOGIN_URL if token_key.nil?
        credentials = authorizer.get_credentials(token_key, request)
        if credentials.nil?
            redirect authorizer.get_authorization_url(login_hint: token_key, request: request)
        end

        puts credentials.access_token
        puts credentials.refresh_token

        credentials
    end
    
    def resize(url, width)
        url.sub(/s220/, sprintf('s%d', width))
    end

    # ログインユーザーを取得．
    def current_user
        User.find(session[:user_id])
    end
end

get '/' do
    @client_id = settings.client_id.id
    @user_id = session[:token_key]
    @user_email = session[:user_email]
    puts "======================== #{@user_id} ========================"
    puts "======================== #{@user_email} ========================"
    # unless session[:token_key].nil?
    #     @user = User.find(session[:token_key]) 
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
        area_id: params[:area_id],
        password: params[:password],
        password_confirmation: params[:password_confirmation]
    )
    if user.persisted?
        session[:token_key] = user.id
        
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
    # erb :home
end

post '/signin' do
    audience = settings.client_id.id
    validator = GoogleIDToken::Validator.new
    claim = validator.check(params['id_token'], audience, audience)

    puts claim

    if claim
        # ログインユーザーをデータベースから参照．
        user = User.find_or_initialize_by(token_key: claim['sub'])
        # 新規ユーザーなら保存．
        if user.new_record?
            user.update!(
                name: claim['name'],
                email: claim['email'],
                image_url: claim['picture'],
                default_image_url: claim['picture']
            )
        end
        # ログインユーザーの情報をセッションに保存．
        session[:token_key] = user.token_key
        session[:user_id] = user.id

        puts "==================== current user ===================="
        puts user.token_key
        puts user.name
        puts user.email
        puts user.image_url
        puts user.default_image_url
        puts "==================== current user ===================="

        200
    else
        logger.info('No valid identity token present')
        401
    end
end

get('/calendar') do
    calendar = Google::Apis::CalendarV3::CalendarService.new
    calendar.authorization = credentials_for(Google::Apis::CalendarV3::AUTH_CALENDAR)
    calendar_id = 'primary'
    @result = calendar.list_events(
        calendar_id,
        max_results: 100,
        single_events: true,
        order_by: 'startTime',
        time_min: Time.now.iso8601,
        # time_max: (Time.now + 60*60*24).iso8601
    )
    erb :calendar
end

get('/oauth2callback') do
    target_url = Google::Auth::WebUserAuthorizer.handle_auth_callback_deferred(request)
    redirect target_url
end

get '/signout' do
    session[:token_key] = nil
    redirect '/'
end

get '/mypage' do
    erb :mypage
end
