#!/usr/bin/lua
--[[
Karl Palsson, 2012.
Considered to be released into the public domain
This handles Out of band auth, and preserving the auth
for future status updates.  It's intended for use in scripted twitter updates...
--]]
require "bbl-twitter"

-- Get your own app keys...
twitter_config.consumer_key = ""
twitter_config.consumer_secret = ""

-- this can be anywhere you like....
secrets_file = "twitter.secrets.lua"


local new_status = arg[1]
if not new_status then
    print(string.format("usage: %s <new tweet content>", arg[0])
    os.exit(1)
end

local f, load_res = loadfile(secrets_file)
if f then
    f()
else
    print("Proceeding to OOB auth because: " .. load_res)
end

if (twitter_config.token_key and twitter_config.token_secret) then
    print "good, we have auth"
    c = client()
else
    c = client()
    out_of_band_cli(c)
    io.output(secrets_file)
    io.write("-- auth for: ", c.screen_name, "\n")
    io.write("twitter_config.token_key=", string.format("%q", c.token_key), "\n")
    io.write("twitter_config.token_secret=", string.format("%q", c.token_secret), "\n")
    print("Out Of Band auth complete, you can now rerun this to post updates")
    print(string.format("Tokens are kept in %s, simply remove that file to reauth", secrets_file))
    os.exit(0)
end

local r, e = pcall(update_status, c, new_status)
if not r then
    print("It broke :( e=" .. e)
end
