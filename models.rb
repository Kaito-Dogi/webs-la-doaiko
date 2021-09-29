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