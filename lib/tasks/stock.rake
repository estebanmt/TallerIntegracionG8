namespace :stock do
  desc "Check Stock level"
  task check: :environment do
    puts "#{Time.now} - Deliver success!"
  end

end
