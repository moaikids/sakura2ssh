#: coding: utf-8

require 'thor'
require 'yaml'
require 'json'
require 'uri'
require 'httpclient'

#  is1a https://secure.sakura.ad.jp/cloud/zone/is1a/api/cloud/1.1/ (第1ゾーン)
#  is1b https://secure.sakura.ad.jp/cloud/zone/is1b/api/cloud/1.1/ (第2ゾーン)
ZONES = %w[ is1a is1b ] 

module Sakura2ssh
  class SakuraCli < Thor
    class_option :conf, :required => true
    class_option :timeout, :required => false, :default => 60
 
    desc "update", "update ssh_config"
    def update
      conf = YAML.load_file(options[:conf])

      ssh_config_path = conf['ssh_config']
      unless ssh_config_path
        raise "not defined 'ssh_config'.please set it."
      end
      access_token = conf['apikey']['access_token']
      access_token_secret = conf['apikey']['access_token_secret']
      user = conf['user']

      client = HTTPClient.new
      entry = ""
      ZONES.each do |zone|
        uri_prefix = "https://secure.sakura.ad.jp/cloud/zone/#{zone}/api/cloud/1.1/"
        client.set_auth(uri_prefix, access_token, access_token_secret)
        url = URI.join(uri_prefix, 'server').to_s
        puts "request to -> #{url}"
        res=nil
        begin
          timeout( options[:timeout].to_i ) {
            res = client.get(url)
          }
        rescue Exception => e
          puts "  #{e}"
          next
        end
        if res == nil
          puts "  response is empty."
        elsif res.status_code.to_i != 200
          puts "  an occurred error processing your request. (#{res.status_code})"
        else
          result = ""
          json = JSON.parse(res.content)
          json['Servers'].each do |server|
            host = server['Name']
            host_suffix = ".#{server['Zone']['Name']}"
            comment = server['Zone']['Description'] + " " + server['Zone']['Region']['Name']
            server = server['Interfaces'].first['UserIPAddress'] # FIXME: Error Handling #.map{|net| net['UserIPAddress']}
            if server == nil
              next # FIXME:
            end
            # Display
            result += <<-"EOS" # .split("\n").map{|a|a.lstrip}.join('')
Host #{host} #{host}#{host_suffix}
  HostName #{server}
  TCPKeepALive yes
  StrictHostKeyChecking no
EOS
            if user != nil
              result += "  User #{user}\n"
            end
          end
          puts result
          entry += result
        end
      end
      puts "write to result -> #{ssh_config_path} "
      open( ssh_config_path , "w" ){|f| f.write(entry)}
    end
  end
end
