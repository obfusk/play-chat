# --                                                            ; {{{1
#
# File        : chat.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-02-24
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2
#
# --                                                            ; }}}1

require 'coffee-script'
require 'haml'
require 'json'
require 'sinatra/base'

class Chat < Sinatra::Base

  SCRIPTS = %w{
    http://code.jquery.com/jquery-1.9.1.min.js
    /js/es-poly-remy.js
    /__coffee__/chat.js
  }

  set :server, :thin
  connections = []

  get '/' do
    redirect '/chat'
  end

  get '/chat' do
    haml :chat
  end

  get '/stream' do
    content_type 'text/event-stream'
    stream(:keep_open) { |out| connections << out }
  end

  post '/say' do
    time  = Time.new.strftime '%F %T'
    data  = { user: params[:user], message: params[:message],
              time: time }
    msg   = "data: #{data.to_json}\n\n"

    connections.each { |out| out << msg }
    "message sent\n"
  end

  get '/__coffee__/:name.js' do |name|
    content_type 'text/javascript'
    coffee :"coffee/#{name}"
  end

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
