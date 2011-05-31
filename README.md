# bbl-twitter

... is a Barebones Lua Twitter module (OAuth-enabled) with minimal dependencies.

It is intended for thin/embedded platforms like OpenWRT routers.

## License

MIT Licensed as per the LICENSE file.

## Dependencies

* Lua (5.1 assumed)
* luasocket
* shell w/ echo support (ie nearly any shell)
* an openssl executable binary.

## Examples

### Tweet from a client (known preset consumer & request secrets)
(If it's your app then you can authenticate yourself for a developer/hardcoded request secret at dev.twitter.com)
```lua
require("bbl-twitter")
c=client(config.consumer_key, config.consumer_secret, config.request_token, config.request_secret)
update_status(c, "Look ma, tweets from Lua!")
```

### Tweet w/ error handling
```lua
require("bbl-twitter")
c=client(config.consumer_key, config.consumer_secret, config.request_token, config.request_secret)
local r, e = update_status(c, "Look ma, this tweet might not make it!")
if (not r) then
  if string.match(e, "duplicate") then
    print("Best guess is this tweet was rejected as a duplicate. Did you already tweet this?")
  else
    print("Error sending tweet: " .. e)
  end
end
```

### Authenticate Out-Of-Band to Twitter
```lua
require("bbl-twitter")
c=client(config.consumer_key, config.consumer_secret)
-- at this stage you will be prompted on the console to visit a URL and enter a
-- PIN for out-of-band authentication
update_status(c, "Look ma, I just authenticated my Lua twitter app!")
print(string.format("My secrets are request_token '%s' request_secret '%s'",
								c.token_key, c.token_secret))
```

### Provide bbl-twitter options in a global 'twitter_config' table
```lua
require("bbl-twitter")
twitter_config.openssl = "/opt/bin/openssl" -- for openssl not on PATH
twitter_config.consumer_key = "myconsumerkey"
twitter_config.consumer_secret = "myconsumersecret"
twitter_config.token_key = "myrequesttoken"
twitter_config.token_secret = "myrequestsecret"
update_status(client(), "Look ma, global settings!")
```

## Alternatives

This is inspired by "shtter" shell twitter client for OpenWRT, by "lostman"
http://lostman-worlds-end.blogspot.com/2010/05/openwrt_22.html
(lostman's is better if you want command-line tweeting on a very severe budget!)

If you have easy access to luarocks + working C compiler then a better
fully-featured option is ltwitter - https://github.com/TheLinx/ltwitter

## Todo

* Make less bodgy
* Add more Twitter API features (parsing JSON/XML w/o additional dependencies FTL)