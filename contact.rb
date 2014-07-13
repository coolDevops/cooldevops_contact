require "rubygems"
require "sinatra/base"
require 'pony'
require 'yaml'
require 'json'

class Contact < Sinatra::Base

  before do
    logger.debug "START LOGGING"
    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Allow-Methods"] = "POST"
    logger.debug response.headers.inspect
  end

  # Load the configuration file for the mailserver settings
  conf = YAML.load_file('configuration.yml')

  post '/contact/' do
    content_type :json

    logger.debug params.inspect

    if params[:email].empty?
      response[:status] = "error"
      response[:message] = "No email"
      response.to_json
    elsif params[:mailbody].empty?
      response[:status] = "error"
      response[:message] = "No message?"
      response.to_json
    elsif 
      
    	Pony.mail(
          :from => params[:email] + "<" + params[:email] + ">",
          :to => 'geert.theys@gmail.com',
          :subject => params[:email] + " has contacted you",
          :body => params[:mailbody],
          :via => :smtp,
          :via_options => { 
            :address              => conf['smtp'], 
            :port                 => conf['port'], 
            :user_name            => conf ['user_name'],
            :password             => conf ['password'],
            :enable_starttls_auto => true, 
            :authentication       => :plain
          })
        response[:status] = "success"
        response[:message] = "Email sent. We will contact you as soon as possible"
        
        logger.debug response.inspect

        response.to_json

      end

  end
end
