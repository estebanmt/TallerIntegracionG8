

namespace :iic3103 do

  desc "Initialize IIC3103Pay"
  task init_payment: :environment do
    puts "#{Time.now} - Initialize IIC3103Pay!"

    Spree::Gateway::IIC3103pay.create(
        name: 'IIC3103pay',
        description: 'IIC3103pay like webpay',
        active: true)

#Spree::Store.first.payment_methods << payment_method


  end

end
