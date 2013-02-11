require 'cinch/extensions/authentication'

module Cinch
  module Plugins
    class UserList
      include Cinch::Plugin
      include Cinch::Extensions::Authentication

      set :plugin_name, 'userlists'
      set :help, <<-USAGE.gsub(/^ {6}/, '')
        Allows you to add/delete users from user lists used for authentication.
        Usage:
        - !add_to_<level> <nickname>: Adds a user to the <level> list.
        - !delete_from_<level> <nickname>: Deletes a user from the <level> list.
        - !show_<level>_list: Shows the <level> list.
      USAGE

      match /add_to_(\S+) (\S+)/s, :method => :add
      match /delete_from_(\S+) (\S)/s, :method => :delete
      match /show_(\S+)_list/s, :method => :show

      enable_authentication

      def add(m, level, nickname)
        if bot.config.send(level) << nickname
          m.user.notice "#{nickname} has been added to the #{level} list."
        end
      end

      def delete(m, level, nickname)
        if bot.config.send(level).delete nickname
          m.user.notice "#{nickname} has been deleted from the #{level} list."
        end
      end

      def show(m, level)
        m.user.notice bot.config.send(level).join ', '
      end
    end
  end
end
