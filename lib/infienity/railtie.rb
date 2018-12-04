module Infienity
  class Railtie < Rails::Railtie
    initializer 'fie.load_layout_path', :after => :add_view_paths do |app|
      ActiveSupport.on_load(:action_controller) do
        append_view_path("#{Gem.loaded_specs['infienity'].full_gem_path}/lib")
      end
    end
  end
end