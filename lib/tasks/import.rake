namespace :active_pivot do
  namespace :import do

    task :pivotal_update, [:interval] => :environment do |t, args|
      updated_after = args[:interval].to_i.minutes.ago
      puts "Updating since #{updated_after}"
      ActivePivot::Importer.run(updated_after)
    end

    task pivotal_initial: :environment do
      interval = 3.years.ago
      ActivePivot::Importer.run(interval)
    end

    task :pivotal_date, [:interval] => :environment do |t, args|
      begin
        updated_after = DateTime.parse args[:interval]
        puts "Updating since #{updated_after}"
        ActivePivot::Importer.run(updated_after)
      rescue
        puts "Could not parse your start date"
        puts "Enter a date such as 'August 12, 2015'"
        puts "Example: rake active_import:import:pivotal_date['August 12, 2015']"
      end
    end
  end
end
