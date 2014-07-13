require "rubygems"
require "sinatra"

require File.expand_path '../contact.rb', __FILE__

root = ::File.dirname(__FILE__)
logfile = ::File.join(root,'logs','requests.log')
$stdout.reopen(logfile)
$stderr.reopen(logfile)

$stderr.sync = true
$stdout.sync = true

require 'logger'
class ::Logger; alias_method :write, :<<; end
logger  = ::Logger.new(logfile,'weekly')

use Rack::CommonLogger, logger

require ::File.join(root,'contact')
run Contact.new # Subclassed from Sinatra::Application