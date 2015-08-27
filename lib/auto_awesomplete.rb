require 'auto_awesomplete/version'
require 'auto_awesomplete/helpers'
require 'auto_awesomplete/engine'

module AutoAwesomplete
  extend ActiveSupport::Autoload

  autoload :SearchAdapter
end