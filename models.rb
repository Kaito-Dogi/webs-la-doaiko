require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection

class User < ActiveRecord::Base
    # has_secure_password
    
    belongs_to :area
    has_many :user_courses
    has_many :courses, through: :user_courses
    has_many :user_classrooms
    has_many :classrooms, through: :user_classrooms
end

class Area < ActiveRecord::Base
    has_many :users
end

class Classroom < ActiveRecord::Base
    has_many :user_classrooms
    has_many :users, through: :user_classrooms
end

class Course < ActiveRecord::Base
    has_many :user_courses
    has_many :users, through: :user_courses
end

class UserClassroom < ActiveRecord::Base
    belongs_to :user
    belongs_to :classroom
end

class UserCourse < ActiveRecord::Base
    belongs_to :user
    belongs_to :course
end

# 予定の構造体
class Event
    def initialize(request_start_time, request_end_time, start_date_time, end_date_time)
        # Time型に変換
        start_time = start_date_time.to_time < request_start_time ? request_start_time : start_date_time.to_time
        end_time = end_date_time.to_time > request_end_time ? request_end_time : end_date_time.to_time

        # 予定の開始時刻
        @start_time_hour = start_time.hour
        @start_time_min = start_time.min

        # 予定の所要時間（秒）
        @duration = (end_time - start_time)
    end

    attr_reader :start_time_hour
    attr_reader :start_time_min
    attr_reader :duration
end