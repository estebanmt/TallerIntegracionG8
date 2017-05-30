Rails.application.routes.draw do

  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
  mount Spree::Core::Engine, at: '/'

  resources :warehouses
  resources :receipts
  resources :transactions
  resources :invoices
  resources :products
  resources :orders
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  # Ruteos del enunciado

  # Crear orden de compra
  get 'dashboard', to: 'dashboards#index'


  put 'crear', to: 'orders#create_order'

  # Recepcionar orden de compra
  post 'recepcionar/:id', to: 'orders#receive'

  # Rechazar orden de compra
  post 'rechazar/:id', to: 'orders#reject_order'

  # Anular orden de compra
  post 'anular/:id', to: 'orders#cancel_order'

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

  # Emitir factura
  post '', to: 'invoices#generate'

  # Obtener factura
  # get ':id', to: 'invoices#show'
  get '1', to: 'invoices#show_invoice'

  # Rechazar factura
  post 'reject', to: 'invoices#reject'

  # Anular factura
  post 'cancel', to: 'invoices#cancel'

  # Crear boleta
  post 'boleta', to: 'invoices#paid'



  # Ruteos acordados con otros grupos

  # Obtener lista de productos
  get 'products', to: 'products#index'
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




end
