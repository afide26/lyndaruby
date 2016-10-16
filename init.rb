#### Food Finder ####
#
# Launch this Ruby file from the command line
# to get started
#

APP_ROOT = File.dirname(__FILE__)

# Various methods
# require "{APP_ROOT}/lib/guide"
# require File.join(APP_ROOT, 'lib', 'guide')
# require File.join(APP_ROOT, 'lib', 'guide.rb')

# Best Method
#Take note of the special variable $:

$:.unshift(File.join(APP_ROOT, 'lib'))


require'guide'

guide = Guide.new('restaurants.txt')
guide.launch!