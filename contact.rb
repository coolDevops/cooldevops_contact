require "rubygems"
require "sinatra/base"
require 'pony'
require 'yaml'

class Contact < Sinatra::Base

  # Load the configuration file for the mailserver settings
  conf = YAML.load_file('configuration.yml')

  post '/contact/?' do
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
      redirect '/success'	
  end

  get('/success'){"Thanks for your email. We'll be in touch soon."}

  get '/' do
	 "This is the contact form program"
  end

  get '/contact' do
  end

end
