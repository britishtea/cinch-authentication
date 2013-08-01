# Cinch-authentication

An authentication system with multiple strategies for the
[Cinch](https://github.com/cinchrb/cinch) IRC framework.

## Features

- **Multiple strategies**: users can be authenticated by their channel status, 
by being in a user list or by identifying with a password.
- **Easily configurable**: authentication can be configured globally, on the
plugin level and on the command level, all at the same time.

## Usage

Cinch-authentication can be set up to require authorization for a full plugin

```ruby
require 'cinch/extensions/authentication'

module Cinch::Plugins
  class Admin
    include Cinch::Plugin
    include Cinch::Extensions::Authentication

    enable_authentication # All matches require authorization.

    # ...
  end
end
```

Or only for a few commands.

```ruby
require 'cinch/extensions/authentication'

module Cinch::Plugins
  class Admin
    include Cinch::Plugin
    include Cinch::Extensions::Authentication

    match /set_topic (.+)/s, :method => :set_topic
    match /get_topic/s, :method => :get_topic

    def set_topic(m, topic)
      return unless authenticated? m

      # ...
    end

    def get_topic(m)
      m.reply m.channel.topic
    end
  end
end
```


For more documenation on usage see the 
[wiki](https://github.com/britishtea/cinch-authentication/wiki). For more 
documentation on the API see 
[rubydoc.org](http://rubydoc.org/gems/cinch-authentication/frames).

## Installation

### Rubygems

```shell
gem install cinch-authentication
```

### Bundler

```ruby
gem 'cinch-authentication', :require => 'cinch/extensions/authentication'
```

## License

See the LICENSE file.
