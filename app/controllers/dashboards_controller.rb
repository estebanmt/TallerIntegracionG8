class DashboardsController < ActionController::Base
  def index
    @dicc = create_prod_dict
    @dicc_almacenes = create_alm_dict
  end

  def create_prod_dict
    products = Product.all
    dicc = {}
    products.each do |prod|
      if dicc[prod.sku] == nil
        dicc[prod.sku] = 1
      else
        dicc[prod.sku] += 1
      end
    end
    return dicc
  end

  def create_alm_dict
    dicc_almacenes = {}
    almacenes = Warehouse.all
    almacenes.each do |alma|
      if dicc_almacenes[alma.warehouse_id] == nil #No se encuentra en el dicc!
        if alma.reception
          dicc_almacenes[alma.warehouse_id] = ['Recepcion', alma.spaceUsed, alma.spaceTotal]
        elsif alma.lung
          dicc_almacenes[alma.warehouse_id] = ['Pulmon', alma.spaceUsed, alma.spaceTotal]
        elsif alma.dispatch
          dicc_almacenes[alma.warehouse_id] = ['Despacho', alma.spaceUsed, alma.spaceTotal]
        else
          dicc_almacenes[alma.warehouse_id] = ['General', alma.spaceUsed, alma.spaceTotal]
        end
      end
    end
    return dicc_almacenes
  end

end
