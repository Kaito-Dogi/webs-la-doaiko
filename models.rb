ActiveRecord::Base.establish_connection

class User < ActiveRecord::Base
    has_secure_password
    
    belongs_to :area
    has_many :user_courses
    has_many :courses, through: :user_courses
    has_many :user_classrooms
    has_many :classrooms, through: :user_classrooms
end

class Area < ActiveRecord::Base
    has_many :users
    has_many :places
    has_many :classrooms
end

class Place < ActiveRecord::Base
    belongs_to :area
    has_many :classrooms
end

class Schedule < ActiveRecord::Base
    has_many :classrooms
end

class Classroom < ActiveRecord::Base
    belongs_to :area
    belongs_to :place
    belongs_to :schedule
    has_many :user_classrooms
    has_many :users, through: :user_classrooms
end

class Course < ActiveRecord::Base
    has_many :user_courses
    has_many :users, through: :user_courses
end

class User_classroom < ActiveRecord::Base
    belongs_to :user
    belongs_to :classrooms
end

class User_course < ActiveRecord::Base
    belongs_to :user
    belongs_to :course
end
