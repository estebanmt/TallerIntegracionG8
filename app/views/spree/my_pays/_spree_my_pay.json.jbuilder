json.extract! spree_my_pay, :id, :live, :event_code, :psp_reference, :original_reference, :merchant_reference, :merchant_account_code, :event_date, :success, :payment_method, :operations, :reason, :currency, :value, :processed, :created_at, :updated_at
json.url spree_my_pay_url(spree_my_pay, format: :json)
