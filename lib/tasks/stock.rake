

namespace :stock do
  require 'security'
  desc "Check Stock level"
  task check: :environment do
    puts "#{Time.now} - Generate Authorization!"
    puts Security.doHashSHA1('GET590baa77d6b4ec0004902cbf')
  end

end
