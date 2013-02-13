require 'cinch'
require 'cinch/extensions/authentication'

require_relative 'plugins'

bot = Cinch::Bot.new do
  configure do |c|
    c.server                  = 'irc.freenode.org'
    c.channels                = ['#cinch-authentication']
    c.authentication          = Cinch::Configuration::Authentication.new
    c.authentication.strategy = :list
    c.authentication.level    = :users
    c.authentication.admins   = ['waxjar']
    c.authentication.users    = c.authentication.admins + ['cinch_user']
    
    c.plugins.plugins << Admin
    c.plugins.options[Admin][:authentication_level] = :admins

    c.plugins.plugins << Quote

    c.plugins.plugins << Cinch::Plugins::UserList
    c.plugins.options[Cinch::Plugins::UserList][:authentication_level] = :admins
  end
end

bot.start
