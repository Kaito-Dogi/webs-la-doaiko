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
    set :scope, Google::Apis::CalendarV3::AUTH_CALENDAR
    set :token_store, Google::Auth::Stores::FileTokenStore.new(file: "token.yaml")
end

helpers do
    def credentials_for(token_key)
        authorizer = Google::Auth::WebUserAuthorizer.new(settings.client_id, settings.scope, settings.token_store, '/oauth2callback')
        redirect LOGIN_URL if session[:token_key].nil?
        credentials = authorizer.get_credentials(token_key, request)
        if credentials.nil?
            redirect authorizer.get_authorization_url(login_hint: token_key, request: request)
        end
        credentials
    end
    
    def resize(url, width)
        url.sub(/s220/, sprintf('s%d', width))
    end

    # 現在のログインユーザーを取得．
    def current_user
        User.find_by(token_key: session[:token_key])
    end

    # 有効なユーザーを全員取得．
    def valid_users
        User.where.not(nickname: nil, term: nil, area_id: nil)
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

    # 各ユーザーの予定を取得．
    def schedules_json(date)
        # 予定の取得の準備．
        request_date = date
        request_start_time = Time.parse("#{request_date} 09:00:00")
        request_end_time = Time.parse("#{request_date} 23:59:59")
        calendar = Google::Apis::CalendarV3::CalendarService.new

        # 全ユーザーの予定を管理する2次元配列．
        schedules = []

        # 各ユーザー毎に予定を取得．
        @users.each do |user|
            events = []
            # calendar.authorization = credentials_for(user.token_key)
            calendar.authorization = credentials_for("103974833804776463435")
            calendar_id = 'primary'

            # Google Calendar APIから予定を取得．
            result = calendar.list_events(
                calendar_id,
                single_events: true,
                order_by: 'startTime',
                time_min: request_start_time.iso8601,
                time_max: request_end_time.iso8601
            )

            # 取得した予定をもとに，Eventインスタンスを生成．
            result.items.each do |item|
                start_date_time = item.start.date_time || item.start.date
                end_date_time = item.end.date_time || item.end.date
                events.push(Event.new(request_start_time, request_end_time, start_date_time, end_date_time))
            end

            schedules.push(events)
        end

        schedules.to_json
    end
end

#初回ログイン時にマイページに遷移する．
before '/' do
    if  session[:token_key]
        user = current_user
        redirect "/mypage/#{user.id}" if !user.nil? && user.nickname.nil?
    end
end

get '/' do
    # Sign inボタンの表示に必要．
    @client_id = settings.client_id.id

    puts "==================== current user ===================="
    puts session[:token_key]
    puts "==================== current user ===================="

    if session[:token_key]
        @current_user = current_user
        @users = valid_users
        #@schedules = schedules_json(Time.now.to_s[0,10])
    end

    erb :calendar
end

get '/signout' do
    session[:token_key] = nil
    redirect '/'
end

get '/mypage/:id' do
    @current_user = current_user
    @owner = User.find(params[:id])
    @can_edit = @owner == @current_user
    erb :mypage
end

post '/signin' do
    audience = settings.client_id.id
    validator = GoogleIDToken::Validator.new
    claim = validator.check(params['id_token'], audience, audience)
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
        200
    else
        logger.info('No valid identity token present')
        401
    end
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

get '/search' do
    @current_user = current_user

    # 地域で絞り込み．
    @users = params[:area_id] == "-1" ? valid_users : valid_users.where(area_id: params[:area_id])

    # コースで絞り込み．
    course_ids = params[:course_ids]
    unless course_ids.nil?
        @users = course_ids.inject(@users.to_a) do |users, course_id|
            users.intersection(Course.find(course_id).users.to_a)
        end
    end

    @schedules = schedules_json(params[:date])

    erb :calendar
end

get '/oauth2callback' do
    target_url = Google::Auth::WebUserAuthorizer.handle_auth_callback_deferred(request)
    redirect target_url
end
