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

    # 現在のログインユーザーを取得．
    def current_user
        User.find_by(token_key: session[:token_key])
    end

    # 全ての地域を取得．
    def areas
        Area.all
    end

    # 全てのコースを取得．
    def courses
        Course.all
    end
    
    # 全てのクラスを取得．
    def classrooms
        Classroom.all
    end
end

get '/' do
    # Sign inボタンの表示に必要．
    @client_id = settings.client_id.id
    puts "==================== current user ===================="
    puts session[:token_key]
    puts "==================== current user ===================="
    @user = current_user
    erb :calendar
end

get '/signout' do
    session[:token_key] = nil
    redirect '/'
end

get '/mypage' do
    @user = current_user
    erb :mypage
end

post '/search' do
    redirect '/'
end

post '/update' do
    user = current_user

    user.nickname = params[:nickname]
    user.area_id = params[:area_id]
    user.term = params[:term]

    user.courses.destroy_all
    course_ids = params[:course_ids]
    course_ids.each do |course_id|
        UserCourse.create!(
            user_id: user.id,
            course_id: course_id
        )
    end

    user.classrooms.destroy_all
    classroom_ids = params[:classroom_ids]
    classroom_ids.each do |classroom_id|
        UserClassroom.create!(
            user_id: user.id,
            classroom_id: classroom_id
        )
    end

    user.save!
    redirect '/'
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
