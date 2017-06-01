
require 'api_pago'

class Spree::Gateway::IIC3103pay  < Spree::Gateway

  def provider
    @provider = self
  end

  def provider_class
    self.class
  end

  #def provider_class
  #  Spree::Gateway::IIC3103pay
  #end

  def source_required?
    false
  end

  def payment_source_class
    Spree::DataCash
  end

  def auto_capture?
    false
  end

  def payment_profiles_supported?
    true
  end


  def method_type
    'iic3103pay'
  end



  def purchase(amount, transaction_details, options = {})
    puts "iic3103 - purchase #{amount}"

    response = ApiPago.pay('1', 1000)

    puts "iic3103 - pay = #{response}"


    ActiveMerchant::Billing::Response.new(true, 'success', {}, {})
  end

end