require 'active_pivot'
require 'rails'
module ActivePivot
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'lib/tasks/import.rake'
    end
  end
end
