Rails.application.routes.draw do
  resources :transactions
  resources :invoices
  resources :products
  resources :orders
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Ruteos del enunciado

  # Crear orden de compra
  put 'crear', to: 'orders#create'

  # Recepcionar orden de compra
  post 'recepcionar/:id', to: 'orders#receive'

  # Rechazar orden de compra
  post 'rechazar/:id', to: 'orders#reject'

  # Anular orden de compra
  delete 'anular/:id', to: 'orders#cancel'

  # Obtener order de compra
  get 'obtener/:id', to: 'orders#show'

  # Ruteos del banco

  # Transferir dinero
  put 'trx', to: 'transactions#transfer'

  # Obtener transaccion
  get 'trx/:id', to: 'transactions#show'

  # Obtener cartola
  get 'cartola', to: 'transactions#index'

  # Obtener cuenta y saldo
  get 'banco/cuenta/:id', to: 'transactions#account'


  # Ruteos de facturas

  # Emitir factura
  post '', to: 'invoices#generate'

  # Obtener factura
  get ':id', to: 'invoices#show'

  # Anular factura
  post 'cancel', to: 'invoices#cancel'

  # Ruteos acordados con otros grupos

  # Obtener lista de productos
  get 'products', to: 'products#index'

  # Enviar orden de compra
  put 'purchase_orders', to: 'orders#receive'
  put 'purchase_orders/:id', to: 'orders#receive'

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

end
