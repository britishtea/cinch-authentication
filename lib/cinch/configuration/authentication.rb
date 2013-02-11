module Cinch
  class Configuration
    class Authentication < Configuration
      KnownOptions = [:strategy, :level, :channel, :logged_in, :registration,
        :fetch_user]

      def self.default_config
        {
          :logged_in => {}
        }
      end
    end
  end
end
