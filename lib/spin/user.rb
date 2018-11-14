# frozen_string_literal: true

require_relative '../spin'

# User class
class Spin::User
  # @return [String]
  attr_reader :username

  # def password=(password)
  #   salt = ENV.fetch('BCRYPT_SALT')
  #
  #   BCrypt::Engine.hash_secret(password, salt).tap do |hashed_password|
  #     @password = hashed_password
  #     self.hashed_password = @password
  #   end
  # end

  # rubocop:disable Lint/UnusedMethodArgument

  def authenticate(password)
    false
  end

  class << self
    # @return [Spin::User|nil]
    def fetch(*args)
      nil
    end
  end

  # rubocop:enable Lint/UnusedMethodArgument
end
