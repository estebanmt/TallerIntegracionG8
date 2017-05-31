require 'uri'

class Spree::Gateway::IIC3103pay  < Spree::Gateway



  @API_URL_PAGO = ENV["URL_API_PAGO"]
  @URL_PAY_PROXY = ENV["URL_PAY_PROXY"]
  @PARAM_URL_OK = 'callbackUrl='
  @PARAM_URL_FAIL = 'cancelUrl='
  @PARAM_BOLETA_ID = 'boletaId'

  def provider_class
    Spree::Gateway::IIC3103pay
  end

  def source_required?
    false
  end

  def auto_capture?
    false
  end

  def method_type
    'iic3103pay'
  end



  def purchase(amount, transaction_details, options = {})
    @boleta_id = 1


    @url = @API_URL_PAGO + @PARAM_URL_OK + URI.encode(@URL_PAY_PROXY + '/' + @boleta_id + '/sucess') + '&' + URI.encode(@PARAM_URL_FAIL +  @URL_PAY_PROXY + '/fail')  + '&' + @PARAM_BOLETA_ID + @boleta_id
    puts "iic3103 - url_pago  #{@url}"

    puts "iic3103 - purchase #{amount}"
    ActiveMerchant::Billing::Response.new(true, 'success', {}, {})
  end

end