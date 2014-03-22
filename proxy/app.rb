require 'sinatra'
require 'json'

set :environment, :production
set :show_exceptions, false
set :server, %w(thin)

config_file = ARGV[0]
commit_command = '/usr/sbin/apache2ctl -k graceful'
#
class Appservers
  attr_accessor :balance_members, :lbmethod

  def initialize
    self.lbmethod = 'byrequests'
    self.balance_members = []
  end

  def build(template, config_file)
    write_config_file(
      populated_template(template),
      config_file)
  end

  def populated_template(template)
    File.open(template, 'r') do |fh|
      ERB.new(fh.read).result(binding)
    end
  end

  def write_config_file(text, config_file)
    File.open(config_file, 'w') do |fh|
      fh.write(text)
    end
  end
end

appservers = Appservers.new
appservers.build(config_file + '.erb', config_file)

get '/appservers/balance_members' do
  content_type :json
  JSON[appservers.balance_members]
end

put '/appservers/balance_members' do
  appservers.balance_members = JSON[request.body.read]
  JSON[appservers.balance_members]
  ''
end

post '/appservers/balance_members' do
  appservers.balance_members += JSON[request.body.read]
  JSON[appservers.balance_members]
  ''
end

get '/appservers/lbmethod' do
  content_type :json
  JSON[{ 'lbmethod' => appservers.lbmethod }]
end

put '/appservers/lbmethod' do
  appservers.lbmethod = JSON[request.body.read]['lbmethod']
end

post '/appservers/commit' do
  appservers.build(config_file + '.erb', config_file)
  system(commit_command)
end
