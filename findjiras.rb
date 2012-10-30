#!/usr/bin/env ruby
=begin

  findjiras.rb

  A stripped down Ruby port of the original Python-based findjiras script 
  authored by Kent Quirk. (https://bitbucket.org/kentquirk/findjiras) 

  Created by Sarah Kuehnle <sarah@sooperduper.com> on October 27, 2012
=end

require 'json'
require 'curb'
require 'yaml'

options = {
  username: nil,
  password: nil,
  jira_url: nil,
  projects: nil
}

CONFIG_FILE = File.join(ENV['HOME'], '.findjiras.yaml')

if File.exists? CONFIG_FILE
  config_options = YAML.load_file(CONFIG_FILE)
  options.merge!(config_options)

  if options[:username] == nil || options[:password] == nil || options[:jira_url] == nil || options[:projects] == nil
    puts "\nPlease edit your config file to include your Jira username and password."
  else
    jiras = Array.new

    ARGF.each_line do |l|
      jkeys = /(#{options[:projects]})-\d{1,6}/i.match(l)
      if jkeys
        jkeys = jkeys.to_s.upcase
        if jiras.include?(jkeys) == false
          jiras.push(jkeys)
        end
      end
    end

    def getkey(s)
      p, v = s.split('-')
      return [p, v.to_i]
    end

    jiras.sort! { |x, y| getkey(x) <=> getkey(y) }

    jiras.each do |j|
      jira_api_url_issues = "#{options[:jira_url]}/rest/api/latest/issue/#{j}?fields=summary"

      c = Curl::Easy.http_get(jira_api_url_issues) do |curl|
        curl.headers['Accept'] = 'application/json'
        curl.headers['Content-Type'] = 'application/json'
        curl.http_auth_types = :basic
        curl.username = options[:username]
        curl.password = options[:password]
      end
      c.perform
      result = JSON.parse c.body_str

      puts "[#{result['key']}] #{result['fields']['summary']}"

    end
  end
else
  File.open(CONFIG_FILE, 'w') { |file| YAML::dump(options, file) }
  puts "\nCreated configuration file in #{CONFIG_FILE}."
  puts "Open that file and add your Jira username and password, then rerun this script.\n\n"
end