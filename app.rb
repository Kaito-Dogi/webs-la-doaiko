require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'sinatra/activerecord'
require './models'

enable :sessions

get '/' do
    puts "======================== #{session[:user_id]} ========================"
    erb :index
end

get '/signup' do
    @areas = Area.all
    @classrooms = Classroom.all
    @courses = Course.all
    erb :signup
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
                User_course.create!(
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
                User_classroom.create!(
                    user_id: user.id,
                    classroom_id: classroom_id
                )
            end
        end
    end
    
    redirect '/'
end