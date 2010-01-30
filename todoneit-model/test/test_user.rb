require 'helper'

module ToDoneIt
  class TestUser < Test::Unit::TestCase
    context "A User instance" do
      setup do
        DataMapper.setup(:default, 'sqlite3::memory:')
        DataMapper.auto_migrate!
      end
      
      should "return a Gravatar URL which contains an MD5 of the email address" do
        user = User.new({:email_address => "test@email.com"})
        assert_equal user.avatar, "http://www.gravatar.com/avatar/#{MD5::md5('test@email.com')}"
      end

      should "encrypt the password" do
        user = User.new
        user.password = "password"
        assert_not_equal "password", user.password
      end

      should "convert email address all lower case" do
        user = User.new({:email_address => "test@EMAIL.com"})
        assert_equal "test@email.com", user.email_address
      end

      should "return the username when converting to a String" do
        user = User.new({:username => "username"})
        assert_equal "username", user.to_s
      end
    end

    context "validations" do
      should "raise an error when username not present" do
        user = User.new({:password => "password"})
        user.save
        assert_equal 1, user.errors.size
        assert_not_nil user.errors[:username]
        user.destroy!
      end
      should "raise an error when password not present" do
        user = User.new({:username => "username"})
        user.save
        assert_equal 1, user.errors.size
        assert_not_nil user.errors[:password]
        user.destroy!
      end
    end
    
    context "authentication" do
      should "throw exception when username incorrect" do
        user = User.new({:username => "username", :password => "password"})
        user.save
        assert_raise User::WrongUsername do
          User.authenticate("me", "password")
        end
        user.destroy!
      end
      should "throw exception when password incorrect" do
        user = User.new({:username => "username", :password => "password"})
        user.save
        assert_raise User::WrongPassword do
          User.authenticate("username", "boo!")
        end
        user.destroy!
      end   
      should "return the user when the password and username are correct" do
        user = User.new({:username => "username", :password => "password"})
        user.save
        assert_equal user, User.authenticate("username", "password")
        user.destroy!
      end
    end

    should "destroy all" do
      User.destroy_all
      assert_equal 0, User.all.length
    end
  end
end
