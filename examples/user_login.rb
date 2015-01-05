require 'cinch'
require 'cinch/extensions/authentication'

require_relative 'plugins'

# For the sake of this example, we'll create an ORM-like model and give it an
# authenticate method, that checks if a given password matches.
class User < Struct.new :nickname, :password, :type
  def authenticate(pass)
    password == pass
  end
end

# Simulate a database.
$users = []
$users << User.new('waxjar', '0000', 'admin')
$users << User.new('shades', '1234', 'user')

bot = Cinch::Bot.new do
  configure do |c|
    c.server                  = 'irc.freenode.org'
    c.channels                = ['#cinch-authentication']

    # Global configuration. This means that all plugins / matchers that
    # implement authentication make use of the :login strategy, with a user
    # level of :users.
    c.authentication          = Cinch::Configuration::Authentication.new
    c.authentication.strategy = :login
    c.authentication.level    = :users

    # The UserLogin plugin will call this lambda when a user runs !register.
    c.authentication.registration = lambda { |nickname, password| 
      # If you were using an ORM, you'd do something like
      # `User.create(:nickname => nickname, :password => password)` here.
      return false if $users.one? { |user| user.nickname == nickname }
      $users << User.new(nickname, password, 'user')
    }

    # The UserLogin plugin will call this lambda when a user runs !login. Note:
    # the class it returns must respond to #authenticate with 1 argument (the 
    # password the user tries to login with).
    c.authentication.fetch_user = lambda { |nickname|
      # If you were using an ORM, you'd probably do something like
      # `User.first(:nickname => nickname)` here.
      $users.find { |user| user.nickname == nickname }
    }

    # The Authentication mixin will call these lambdas to check if a user is
    # allowed to run a command.
    c.authentication.users  = lambda { |user| user.type == 'user' }
    c.authentication.admins = lambda { |user| user.type == 'admin' }

    # Plugin-specific configuration. This means that for the Admin plugin, a
    # user level of :admins required. The strategy is inherited from the global
    # configuration.
    c.plugins.plugins << Admin
    c.plugins.options[Admin][:authentication_level] = :admins

    c.plugins.plugins << Quote

    # To allow users to login cinch-authentication provides a plugin.
    c.plugins.plugins << Cinch::Plugins::UserLogin
  end
end

bot.start
