# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

warehouse_list = [
    [ "Recepcion", 10000, 0 ],
    [ "Principal", 50000, 0 ],
    [ "Despacho", 10000, 0 ],
    [ "Pulmon", 99999999, 0 ]
]

warehouse_list.each do |name, capacity, stock|
  Warehouse.create( nombre: name, capacidad: capacity, stock: stock)
end