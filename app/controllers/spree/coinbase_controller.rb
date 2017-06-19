require 'rest_client'
require 'api_pago'
require 'api_bodega'
require 'cgi'
require 'addressable/uri'

module Spree
  class CoinbaseController < StoreController
    include HTTParty
    ssl_ca_file File.expand_path(File.join(File.dirname(__FILE__), 'ca-coinbase.crt'))
    skip_before_filter :verify_authenticity_token

    def redirect
      order = current_order || raise(ActiveRecord::RecordNotFound)

      if order.state != "payment"
        redirect_to root_url() # Order is not ready for payment / has already been paid
        return
      end




      pago = ::ApiPago.new

      boleta_id = ::ApiPago.get_boleta_id(1, order.total.round)



      secret_token = SecureRandom.base64(30)

      # Add a "processing" payment that is used to verify the callback
      transaction = CoinbaseTransaction.new
      transaction.button_id = boleta_id
      transaction.secret_token = secret_token

      gateway = PaymentMethod.find(params[:payment_method_id])

      order.payments.clear
      payment = order.payments.create
      payment.started_processing
      payment.amount = order.total
      payment.payment_method = gateway
      payment.source = transaction
      order.next
      order.save

      url_ok = CGI::escape(spree_coinbase_success_url(:payment_method_id => params[:payment_method_id], :order_num => order.number, :boleta_id => boleta_id))
      url_fail = CGI::escape(spree_coinbase_cancel_url(:payment_method_id => params[:payment_method_id], :boleta_id => boleta_id))

      @API_URL_PAGO = ENV["API_URL_PAGO"]
      @url = @API_URL_PAGO + 'pagoenlinea?' + 'callbackUrl=' + url_ok + '&' + 'cancelUrl=' + url_fail + '&' + 'boletaId=' + boleta_id

      redirect_to @url and return

      puts "url_pago #{@url}"

    end


    def cancel

      order = current_order || raise(ActiveRecord::RecordNotFound)

      payments = order.payments.where(:state => "pending")
      payments.each do |payment|
        if payment.source.button_id == params[:boleta_id]
          payment.void!
        end
      end

      redirect_to edit_order_checkout_url(order, :state => 'payment'),
                  :notice => "Pagamento Cancelado"
    end

    def success

      order = Spree::Order.find_by_number(params[:order_num]) || raise(ActiveRecord::RecordNotFound)

      payments = order.payments
      payment = nil
      payments.each do |p|
        #if payment.source.button_id == params[:boleta_id]
          payment = p
        #  end
      end

      # Make payment pending -> make order complete -> make payment complete -> update order
      payment.complete!
      order.next
      if !order.complete?
        order.next
      end


      if order.complete?
        session[:order_id] = nil # Reset cart

        mover_skus(order, params[:boleta_id])

        redirect_to spree.order_path(order), :notice => Spree.t(:order_processed_successfully)
      else
          redirect_to checkout_state_path(order.state),
                      :notice => "Pagamento incompleto, intentar nuevamente"

      end

      # If order not complete, wait for callback to come in... (page will automatically refresh, see view)
    end

    private

    def payment_method
      m = Spree::PaymentMethod.find(params[:payment_method_id])
      if !(m.is_a? Spree::PaymentMethod::Coinbase)
        raise "Invalid payment_method_id"
      end
      m
    end

    # the coinbase-ruby gem is not used because of its dependence on incompatible versions of the money gem
    def make_coinbase_request verb, path, options

      key = payment_method.preferred_api_key
      secret = payment_method.preferred_api_secret

      base_uri = "https://integracion-2017-dev.herokuapp.com/"
      nonce = (Time.now.to_f * 1e6).to_i
      message = nonce.to_s + base_uri + path + options.to_json
      #signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::Digest.new('sha256'), secret, message)

      headers = {
          'ACCESS_KEY' => key,
          #'ACCESS_SIGNATURE' => signature,
          'ACCESS_NONCE' => nonce.to_s,
          "Content-Type" => "application/json",
      }

      #r = self.class.send(verb, base_uri + path, {headers: headers, body: options.to_json})
      JSON.parse(r.body)
    end

    def get_url(url)
      #puts @url

      @response = RestClient::Request.execute(
          method: :get,
          url: url,
          headers: {'Content-Type' => 'application/json',
                    "Authorization" => @auth})

      # TODO more error checking (500 error, etc)
      json = JSON.parse(@response.body)
      #puts json
      return json

    end

    def mover_skus (order, boleta_id)
      order.line_items.each do |item|

        puts "sku #{item.sku} single_money #{item.single_money} quantity #{item.quantity} money #{item.money} "

          for i in 1..item.quantity
            puts "mover stoke para item #{i} sku #{item.sku} single_money #{item.single_money} money #{item.money}  oc/boleta #{boleta_id}"
            puts ::APIBodega.despachar_Stock(item.sku, " callle a", item.single_money, boleta_id)
          end

      end

    end

    def query_params(params)
      if params != nil
        queryParams = "";
        params.each do |field, value|
          queryParams.concat(field).concat("=").concat(value.to_s).concat("&");
          #queryParams = queryParams + field + "=" + value + "&";
        end
        return queryParams
      else
        return nil;
      end
    end

  end
end