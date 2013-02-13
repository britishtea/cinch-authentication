require 'cinch'
require 'cinch/extensions/authentication'

require_relative 'plugins'

bot = Cinch::Bot.new do
  configure do |c|
    c.server                  = 'irc.freenode.org'
    c.channels                = ['#cinch-authentication']

    c.authentication          = Cinch::Configuration::Authentication.new
    c.authentication.strategy = :channel_status
    c.authentication.level    = :v 
    
    c.plugins.plugins << Admin
    c.plugins.options[Admin][:authentication_level] = :o

    c.plugins.plugins << Quote
  end
end

bot.start
