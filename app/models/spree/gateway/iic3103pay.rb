class Spree::Gateway::IIC3103pay  < Spree::Gateway
  def provider_class
    Spree::Gateway::IIC3103pay
  end
  def payment_source_class
    Spree::CreditCard
  end

  def method_type
    'iic3103pay'
  end

  def purchase(amount, transaction_details, options = {})
    puts "purchase #{amount}"
    ActiveMerchant::Billing::Response.new(true, 'success', {}, {})
  end

end