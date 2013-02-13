require 'cinch/extensions/authentication'

module Cinch
  module Plugins
    class UserLogin
      include Cinch::Plugin
      include Cinch::Extensions::Authentication

      set :plugin_name, 'account'
      set :help, <<-USAGE.gsub(/^ {6}/, '')
        Allows you to login to run commands that require authorization.
        Usage:
        - !register [<nickname>] <password>: Registration (note: <nickname> defauts to your current nickname if ommited).
        - !login [<nickname>] <password>: Logging in (note: <nickname> defaults to your current nickname if ommited).
        - !logout: Logout. Nickname defaults to the current nickname.
      USAGE

      match /register (?:(\S+) )?(\S+)/s, :method => :register
      match /login (?:(\S+) )?(\S+)/s, :method => :login
      match /logout/s, :method => :logout

      # Admin-only commands. Perhaps in a later version.
      #match /add_to_(\S+) (\S+)/s => :method => :add_to
      #match /remove_from_(\S+) (\S+)/s, :method => :remove_from

      def register(m, nickname, password)
        registration = config[:registration] || 
          bot.config.authentication.registration

        if registration.nil?
          raise StandardError, 'You have not configured a registration lambda.'
        elsif registration.call(nickname || m.user.nick, password)
          m.user.notice "You have been registered as #{nickname||m.user.nick}."
          login m, nickname, password
        else
          m.user.notice "An account with nickname #{nickname || m.user.nick} " +
            'already exists.'
        end
      rescue => e
        m.user.notice 'Something went wrong.'
        raise
      end

      def login(m, nickname, password)
        fetch_user = config[:fetch_user] || bot.config.authentication.fetch_user

        if fetch_user.nil?
          raise StandardError, 'You have not configured an fetch_user lambda.'
        end

        user = fetch_user.call(nickname || m.user.nick)

        if user.nil?
          m.user.notice 'You have not registered or mistyped your nickname.'
          return
        end

        unless user.respond_to? :authenticate
          raise StandardError, "Please implement #{user.class}#authenticate."
        end

        if user.authenticate(password)
          bot.config.authentication.logged_in[m.user] = user
          m.user.notice "You have been logged in as #{nickname || m.user.nick}."
        else
          m.user.notice 'Unknown username/password combination.'
        end
      rescue => e
        m.user.notice 'Something went wrong.'
        raise
      end

      def logout(m)
        if bot.config.authentication.logged_in.delete m.user
          m.user.notice 'You have been logged out.'
        else
          m.user.notice 'You are not logged in.'
        end
      end
    end
  end
end
