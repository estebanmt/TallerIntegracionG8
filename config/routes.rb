Rails.application.routes.draw do

  get 'api/publico/precios', to: 'products#index'

  namespace :spree do
    resources :my_pays
  end
  resources :payproxies


  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
  mount Spree::Core::Engine, at: '/'
  Spree::Core::Engine.routes.draw do
    get '/spree_coinbase/redirect', :to => "coinbase#redirect", :as => :spree_coinbase_redirect
    post '/spree_coinbase/callback', :to => "coinbase#callback", :as => :spree_coinbase_callback
    get '/spree_coinbase/cancel', :to => "coinbase#cancel", :as => :spree_coinbase_cancel
    get '/spree_coinbase/success', :to => "coinbase#success", :as => :spree_coinbase_success
  end

  resources :warehouses
  resources :receipts
  resources :transactions
  resources :invoices
  resources :products
  resources :orders
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #Indicar suceso de payment
  get '/payproxies/:id/sucess', to: 'payproxies#sucess'


  #Indicar fallo de payment
  get '/payproxies/:id/fail', to: 'payproxies#fail'

  # Ruteos del enunciado

  # Crear orden de compra

  # Dashboard principal
  get 'dashboard', to: 'dashboards#index'

  # Dashboard de IDs factura
  get 'dashboard/facturas', to: 'dashboards#facturas'

  put 'crear', to: 'orders#create_order'

  # Recepcionar orden de compra
  post 'oc/recepcionar/:id', to: 'orders#receive_order'
  get 'oc/recepcionar/:id', to: 'orders#receive_order'

  # Rechazar orden de compra
  post 'oc/rechazar/:id', to: 'orders#reject_order'
  get 'oc/rechazar/:id', to: 'orders#reject_order'

  # Anular orden de compra
  post 'oc/anular/:id', to: 'orders#cancel_order'
  get 'oc/anular/:id', to: 'orders#cancel_order'

  # Obtener order de compra
  # get 'obtener/:id', to: 'orders#show'
  get 'obtener/:id', to: 'orders#show_order'

  # Ruteos del banco

  # Transferir dinero
  put 'trx', to: 'transactions#transfer'

  # Obtener transaccion
  #get 'trx/:id', to: 'transactions#show'
  get 'trx/:id', to: 'transactions#show_transaction'

  # Obtener cartola
  get 'cartola', to: 'transactions#index'

  # Obtener cuenta y saldo
  get 'banco/cuenta/:id', to: 'transactions#account'


  # Ruteos de facturas

  #Crear factura
  get 'factura/crear/:id_oc', to: 'invoices#create'

  #Aceptar factura
  get 'factura/aceptar/:id_factura', to: 'invoices#accept'

  #Rechazar factura
  get 'factura/rechazar/:id_factura', to: 'invoices#reject'

  #Get factura
  get 'factura/:id_factura', to: 'invoices#get'

  #Recibir notificacion de factura
  get 'invoices/:id_factura/:bank_account', to: 'invoices#notifyFactura'
  put 'invoices/:id_factura', to: 'invoices#notifyFactura'

  # Emitir factura
  #post '', to: 'invoices#generate'

  # Obtener factura
  # get ':id', to: 'invoices#show'
  #get '1', to: 'invoices#show_invoice'

  # Rechazar factura
  #post 'reject', to: 'invoices#reject'

  # Anular factura
  #post 'cancel', to: 'invoices#cancel'

  # Crear boleta
  get 'sii/boleta/:id/:monto', to: 'invoices#pagar'
  get 'order/:id', to: 'warehouses#order_id'



  # Ruteos acordados con otros grupos

  # Obtener lista de productos
  get 'precios', to: 'products#index'


  # Notificar orden de compra (otro grupo notifica que creo una o/c para nosotros)
  put 'purchase_orders/:id', to: 'orders#notify'
  put 'test/test', to: 'orders#test'

  # Informar aceptacion de orden de compra
  post 'purchase_orders/:id', to: 'orders#accept'
  patch 'purchase_orders/:id/accepted', to: 'orders#accept'

  # Informar rechazo de orden de compra
  delete 'purchase_order/:id', to: 'orders#reject'
  patch 'purchase_orders/:id/rejected', to: 'orders#reject'

  # Enviar nueva factura
  put 'invoices', to: 'invoices#receive'
  put 'invoices/:id', to: 'invoices#receive'

  # Informar aceptacion orden de compra
  post 'invoices/:id', to: 'invoices#accept'
  patch 'invoices/:id/accepted', to: 'invoices#accept'

  # Informar rechazo factura
  delete 'invoices/:id', to: 'invoices#reject'
  patch 'invoices/:id/rejected', to: 'invoices#reject'

  # Informar envio de productos
  patch 'invoices/:id/delivered', to: 'invoices#delivered'

  # Recibir pago
  patch 'invoices/:id/paid', to: 'invoices#paid'

  # GET almacenes
  get 'getAlmacenes', to: 'warehouses#getAlmacenes'

  #GET skusWithStock
  get 'getSkusWithStock/:id', to: 'warehouses#getSkusWithStock'

  #GET stock
  get 'getStock/:id/:sku', to: 'warehouses#getStock'

  # GET inicializar
  get 'inicializar/1', to: 'warehouses#initialize1'
  get 'inicializar/2', to: 'warehouses#initialize2'
  get 'inicializar/3', to: 'warehouses#initialize3'
  get 'inicializar/4', to: 'warehouses#initialize4'
  get 'inicializar/5', to: 'warehouses#initialize5'
  get 'inicializar/primas', to: 'warehouses#initializePrimas'
  # get 'order/19', to: 'warehouses#order19'
  # get 'order/20', to: 'warehouses#order20'
  # get 'order/26', to: 'warehouses#order26'
  # get 'order/27', to: 'warehouses#order27'
  # get 'order/38', to: 'warehouses#order38'
  get 'order/:id', to: 'warehouses#order_id'
  get 'order/:id/:lotes', to: 'warehouses#order_lotes'

  # vaciar recepcion
  get 'vaciar_recepcion', to: 'warehouses#vaciar_recepcion'
  # Mover desdde general a despacho
  get 'mover_general_despacho/:sku/:cantidad', to: 'warehouses#mover_general_despacho'
  # mover dede pulmon a general.
  get 'mover_pulmon_general/:sku/:cantidad', to: 'warehouses#mover_pulmon_general'
  # Mover desdde despacho a general.
  get 'mover_despacho_general/:sku/:cantidad', to: 'warehouses#mover_despacho_general'

  get 'despachar_orden/:sku/:cantidad/:precio/:almacenId/:oc', to: 'warehouses#despachar'
  get 'despachar_orden_desde_despacho/:sku/:cantidad/:precio/:almacenId/:oc', to: 'warehouses#despachar_despacho'
  get 'despachar_aceptar/:sku/:cantidad/:precio/:almacenId/:oc', to: 'warehouses#despachar_aceptar'
  get 'despachar_ftp/:sku/:cantidad/:precio/:oc', to: 'warehouses#despachar_ftp'

  get 'distribuidores_dev', to: 'orders#distribuidores_dev'
  get 'distribuidores_prod', to: 'orders#distribuidores_prod'
  get 'transaccionar/:monto/:destino', to: 'invoices#transaccionar'
  get 'estado_distribuidores_dev', to: 'orders#estado_distribuidores_dev'
  get 'estado_distribuidores_prod', to: 'orders#estado_distribuidores_prod'

  get 'auto_distribuidores_dev', to: 'orders#auto_distribuidores_dev'
  get 'auto_distribuidores_prod', to: 'orders#auto_distribuidores_prod'

end
