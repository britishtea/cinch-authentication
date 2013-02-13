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
    return unless authenticated? m
    m.reply 'Deleted quote' if @quotes.delete quote
  end
end
