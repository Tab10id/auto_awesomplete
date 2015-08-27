module AutoAwesomplete
  class Engine < ::Rails::Engine
    # Get rails to add app, lib, vendor to load path

    initializer :javascripts do |app|
      app.config.assets.precompile << 'auto_awesomplete/ajax.js'
    end
  end
end