# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Product.create(name: 'Platano', sku: '123', unit_price: 1234, product_id: '0', warehouse_id: '0', cost: '1234')
Product.create(name: 'Platano', sku: '123', unit_price: 1234, product_id: '0', warehouse_id: '0', cost: '1234')
Product.create(name: 'Platano', sku: '123', unit_price: 1234, product_id: '0', warehouse_id: '0', cost: '1234')
Product.create(name: 'Platano', sku: '123', unit_price: 1234, product_id: '0', warehouse_id: '0', cost: '1234')
Product.create(name: 'Platano', sku: '123', unit_price: 1234, product_id: '0', warehouse_id: '0', cost: '1234')
Product.create(name: 'Peras', sku: '124', unit_price: 1232, product_id: '1', warehouse_id: '1', cost: '1231')
Product.create(name: 'Peras', sku: '124', unit_price: 1232, product_id: '1', warehouse_id: '1', cost: '1231')
Product.create(name: 'Peras', sku: '124', unit_price: 1232, product_id: '1', warehouse_id: '1', cost: '1231')
Product.create(name: 'Peras', sku: '124', unit_price: 1232, product_id: '1', warehouse_id: '1', cost: '1231')
Product.create(name: 'Peras', sku: '124', unit_price: 1232, product_id: '1', warehouse_id: '1', cost: '1231')
Product.create(name: 'Peras', sku: '124', unit_price: 1232, product_id: '1', warehouse_id: '1', cost: '1231')
Product.create(name: 'Peras', sku: '124', unit_price: 1232, product_id: '1', warehouse_id: '1', cost: '1231')
Product.create(name: 'Naranjas', sku: '125', unit_price: 1231, product_id: '2', warehouse_id: '2', cost: '1230')
Product.create(name: 'Naranjas', sku: '125', unit_price: 1231, product_id: '2', warehouse_id: '2', cost: '1230')
Product.create(name: 'Naranjas', sku: '125', unit_price: 1231, product_id: '2', warehouse_id: '2', cost: '1230')
Product.create(name: 'Naranjas', sku: '125', unit_price: 1231, product_id: '2', warehouse_id: '2', cost: '1230')
Product.create(name: 'Naranjas', sku: '125', unit_price: 1231, product_id: '2', warehouse_id: '2', cost: '1230')
Product.create(name: 'Naranjas', sku: '125', unit_price: 1231, product_id: '2', warehouse_id: '2', cost: '1230')
Product.create(name: 'Naranjas', sku: '125', unit_price: 1231, product_id: '2', warehouse_id: '2', cost: '1230')
Receipt.create(supplier: 'Dude 1', client: 'Dude -1', amount: 100)
Receipt.create(supplier: 'Dude 3', client: 'Dude 0', amount: 99)
Receipt.create(supplier: 'Dude 4', client: 'Dude -2', amount: 98)
Transaction.create(amount: 100, sender: 'Somebody', receiver: 'Somebody-else')
Transaction.create(amount: 101, sender: 'Somebody1', receiver: 'Somebody-else1')
Transaction.create(amount: 102, sender: 'Somebody2', receiver: 'Somebody-else2')
Warehouse.create(warehouse_id: 0, spaceUsed: 5, spaceTotal: 10000, reception: false, dispatch: false, lung: false)
Warehouse.create(warehouse_id: 1, spaceUsed: 7, spaceTotal: 10, reception: true, dispatch: false, lung: false)
Warehouse.create(warehouse_id: 2, spaceUsed: 7, spaceTotal: 10, reception: false, dispatch: true, lung: false)
Warehouse.create(warehouse_id: 3, spaceUsed: 0, spaceTotal: 5, reception: false, dispatch: false, lung: true)
#Order.create(order_id: '0', channel: 'B2B', supplier: 'G1', client: 'G2', sku: '125', amount: 100, amount_dispatched: 121, unit_price: 30,status: 'OK', notes: 'All Ok', invoice_id: '30')
#Invoice.create(invoice_id: '30', supplier: '20', client: '23', gross_amount: 119, iva: 19, total_amount: 10, status: 'OK',order_id: '123' )


Spree::Core::Engine.load_seed if defined?(Spree::Core)
Spree::Auth::Engine.load_seed if defined?(Spree::Auth)

#Spree::Gateway::IIC3103pay.create(name: 'IIC3103Pay',descriptio"#{n: 'IIC3103Pay Webpay',active: true,environment: 'development')

#Spree::Store.first.payment_methods << payment_method
