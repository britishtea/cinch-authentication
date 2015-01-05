require 'cinch'
require 'cinch/extensions/authentication'

require_relative 'plugins'

bot = Cinch::Bot.new do
  configure do |c|
    c.server                  = 'irc.freenode.org'
    c.channels                = ['#cinch-authentication']

    # Global configuration. This means that all plugins / matchers that
    # implement authentication make use of the :list strategy. Users must be in
    # the :users list to be authorized.
    c.authentication          = Cinch::Configuration::Authentication.new
    c.authentication.strategy = :list
    c.authentication.level    = :users
    c.authentication.admins   = ['waxjar'] # :admins list
    c.authentication.users    = c.authentication.admins + ['user'] # :users list
    
    # Plugin-specific configuration. This means that for the Admin plugin, users
    # must be in the :admins list (defined above). The strategy is inherited
    # from the global configuration.
    c.plugins.plugins << Admin
    c.plugins.options[Admin][:authentication_level] = :admins

    c.plugins.plugins << Quote

    # To add users to lists on the fly cinch-authentication provides a plugin.
    c.plugins.plugins << Cinch::Plugins::UserList
    c.plugins.options[Cinch::Plugins::UserList][:authentication_level] = :admins
  end
end

bot.start
