# frozen_string_literal: true

require_relative '../spin'

# User class
class Spin::User
  # @return [String]
  attr_reader :hashed_password

  # @return [String]
  attr_reader :username

  def initialize(username)
    @username = username
  end

  # def password=(password)
  #   salt = ENV.fetch('BCRYPT_SALT')
  #
  #   BCrypt::Engine.hash_secret(password, salt).tap do |hashed_password|
  #     @password = hashed_password
  #     self.hashed_password = @password
  #   end
  # end

  def authenticate(password)
    require 'bcrypt'
    salt = ENV.fetch('BCRYPT_SALT')

    return false unless self.hashed_password

    BCrypt::Engine.hash_secret(password, salt).tap do |hashed_attempt|
      return self.hashed_password == hashed_attempt
    end
  end

  protected

  attr_writer :hashed_password

  class << self
    # @return [Spin::User|nil]
    def fetch(*args)
      Pathname.new(__dir__).join('user/users.yml').tap do |file|
        hashed_password = YAML.safe_load(file.read).fetch(*args)
        return nil unless hashed_password

        self.new(args.fetch(0)).tap do |user|
          user.__send__('hashed_password=', hashed_password)

          return user
        end
      end
    end
  end
end
