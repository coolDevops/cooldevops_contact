require "rubygems"
require "sinatra/base"
require 'pony'
require 'yaml'
require 'json'

class Contact < Sinatra::Base

  before do
    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Allow-Methods"] = "POST"
  end

  # Load the configuration file for the mailserver settings
  conf = YAML.load_file('configuration.yml')

  post '/' do
    content_type :json

    if params[:email].empty?
      {:status => "error", :message => "No email"}.to_json
    elsif params[:mailbody].empty?
      {:status => "error", :message => "No Message"}.to_json
    else
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
            :authentication       => :plain,
            :domain               => "cooldevops.com" 
          })

        {:status => "succes", :message => "Email sent. We will contact you as soon as possible"}.to_json        
    end
  end
end