
module ToDoneIt
  class User
    class WrongUsername < ArgumentError; end
    class WrongPassword < ArgumentError; end

    include DataMapper::Resource

    property :id, Serial
    property :username, String
    property :password, String
    property :salt, String
    property :email_address, String

    # Magic properties
    property :created_at, DateTime
    property :updated_at, DateTime

    has n, :tasks

    validates_present :username
    validates_present :password
    validates_is_unique :username
    validates_is_unique :email_address

    def self.authenticate(username, password)
      raise WrongUsername unless user = first({ :username =>  username})
      raise WrongPassword unless user.password == encrypt(password, user.salt)
      user
    end

    def password=(value)
      attribute_set(:salt, encrypt(Time.now.to_s, ""))
      
      value = value.empty? ? nil : encrypt(value, salt)

      attribute_set(:password, value)
    end

    def email_address=(value)
      attribute_set(:email_address, value.downcase)
    end

    def to_s
      username.to_s
    end

    def to_param
      username
    end

    def todo
      Task.all({ :user =>  id, :completed_at => nil} )
    end
    
    def completed
      Task.all({:user => id, :completed_at.lt => Time.now})
    end

    # Return all the User's tasks for today
    def today
      Task.today({:user => self})
    end

    # Return all the User's tasks for tomorrow
    def tomorrow
      Task.tomorrow({:user => self})
    end

    # Return all the User's tasks for yesterday
    def yesterday
      Task.yesterday({:user => self})
    end

    # Return all the User's tasks before a particular date
    def before_date(date)
      Task.before_date({:user => self}, date)
    end

    # Return all the User's tasks after a particular date
    def after_date(date)
      Task.after_date({:user => self}, date)
    end

    def avatar
      "http://www.gravatar.com/avatar/#{MD5::md5(email_address)}"
    end

    def self.destroy_all
      User.all.each { |user|
        user.destroy!
      }
    end

    private

    def self.encrypt(string, salt)
      Digest::SHA1.hexdigest("--#{salt}--#{string}--")
    end

    def encrypt(*attrs)
      self.class.encrypt(*attrs)
    end
  end
end
