require 'cinch'
require 'cinch/extensions/authentication'

class Admin
  include Cinch::Plugin
  include Cinch::Extensions::Authentication

  enable_authentication

  match /quit/, :method => :quit

  def quit(m)
    bot.quit
  end
end

class Quote
  include Cinch::Plugin
  include Cinch::Extensions::Authentication

  match /quote/, :method => :quote
  match /add (.+)/, :method => :add
  match /delete (.+)/, :method => :delete

  def initialize(*args)
    super
    
    @quotes = []
  end

  def quote(m)
    m.reply @quotes.sample
  end

  def add(m, quote)
    m.reply 'Added quote' if @quotes << quote
  end

  def delete(m, quote)
    # People with voice or higher may help keep the 'database' of quotes clean.
    return unless authenticated? m, :v 
    m.reply 'Deleted quote' if @quotes.delete quote
  end
end

bot = Cinch::Bot.new do
  configure do |c|
    c.server                  = 'irc.freenode.org'
    c.channels                = ['#authentication-test']
    c.authentication          = Cinch::Configuration::Authentication
    c.authentication.strategy = :channel_status
    
    c.plugins.plugins << Admin
    c.plugins.options[Admin][:authentication_level] = :o

    c.plugins.plugins << Quote
  end
end

bot.start
