require "rubygems"
require "sinatra"

require File.expand_path '../contact.rb', __FILE__

root = ::File.dirname(__FILE__)

require ::File.join(root,'contact')
run Contact.new # Subclassed from Sinatra::Application