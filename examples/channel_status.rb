require 'cinch'
require 'cinch/extensions/authentication'

require_relative 'plugins'

bot = Cinch::Bot.new do
  configure do |c|
    c.server                  = 'irc.freenode.org'
    c.channels                = ['#cinch-authentication']

    # Global configuration. This means that all plugins / matchers that
    # implement authentication make use of the :channel_status strategy, with a
    # user level of voice or higher.
    c.authentication          = Cinch::Configuration::Authentication.new
    c.authentication.strategy = :channel_status
    c.authentication.level    = :v 
    
    # Plugin-specific configuration. This means that for the Admin plugin, a
    # user level of operator or higher is required. The strategy is inherited
    # from the global configuration.
    c.plugins.plugins << Admin
    c.plugins.options[Admin][:authentication_level] = :o

    c.plugins.plugins << Quote
  end
end

bot.start
