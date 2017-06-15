require 'net/sftp'
require 'net/ssh'
require 'json'
require 'active_support/core_ext/hash'
require 'api_orden_compra'


class APIDistribuidores
  @OCDistribuidoresHASH = Array.new
  @API_URL = ENV["URL_DISTRIBUIDORES"]
  @API_URL_OC_DEV = "https://integracion-2017-dev.herokuapp.com/oc/"
  @API_URL_OC_PROD = "https://integracion-2017.herokuapp.com/oc/"

#Descarga las oc de distribuidores en DEV
  def self.OCDistribuidoresXMLDEV
    host = 'integra17dev.ing.puc.cl'
    user = 'grupo8'
    pass = 'h5GEam7Qe6M3nTD4'
    ocxml = []
    Net::SFTP.start(host, user, {:password => pass}) do |sftp|
        name = "/pedidos/"
        local = "public/OCDistribuidoresXMLDEV"
        puts "descargando " + name
        sftp.download!(name,local,:recursive => true)
        puts "descargado"
    end
  end

#Descarga las oc de distribuidores en PROD
  def self.OCDistribuidoresXMLPROD
    host = 'integra17.ing.puc.cl'
    user = 'grupo8'
    pass = 'PKMSLpV6U8ex3ACZ'
    ocxml = []
    Net::SFTP.start(host, user, {:password => pass}) do |sftp|
        name = "/pedidos/"
        local = "public/OCDistribuidoresXMLPROD"
        puts "descargando " + name
        sftp.download!(name,local,:recursive => true)
        puts "descargado"
    end
  end

#Hashea los XML para poder trabajarlos más facilmente
  def self.OCDistribuidoresHASHDEV
    puts "Entrando OCDistribuidoresHASHDEV"
    @OCDistribuidoresHASH = Array.new
    files = Dir.glob("public/OCDistribuidoresXMLDEV/*.xml")
    for f in files
      ochash = Hash.from_xml(File.read(f))
      @OCDistribuidoresHASH.push(ochash)
    end
    puts "Saliendo OCDistribuidoresHASHDEV"
  end

#Hashea los XML para poder trabajarlos más facilmente
  def self.OCDistribuidoresHASHPROD
    @OCDistribuidoresHASH = Array.new
    files = Dir.glob("../public/OCDistribuidoresXMLPROD/*.xml")
    for f in files
      ochash = Hash.from_xml(File.read(f))
      @OCDistribuidoresHASH.push(ochash)
    end
  end

#Llama a ApiB2b.revisarOrdenFtp para cada id de las oc de distribuidores
  def self.revisar_Ordenes
    puts "Entrando revisar_Ordenes"
    for oc in @OCDistribuidoresHASH
      puts "-----------------------------------------------------------"
      id = oc["order"]["id"]
      puts "Revisando oc"
      ApiB2b.revisarOrdenFtp(id)
    end
  end

#Llama a ApiB2b.revisarOrdenFtp para cada id de las oc de distribuidores en DEV
  def self.revisar_Ordenes_DEV
    #descargamos ocs en dev
    self.OCDistribuidoresXMLDEV
    #Hasheamos
    self.OCDistribuidoresHASHDEV
    #Actualizamos el modelo
    self.estado_Ordenes_DEV
    #Revisamos
    self.revisar_Ordenes
  end

  def self.revisar_Ordenes_PROD
    self.OCDistribuidoresXMLPROD
    self.OCDistribuidoresHASHPROD
    self.estado_Ordenes_PROD
    self.revisar_Ordenes_PROD
  end

  def self.estado_Ordenes_DEV
    self.OCDistribuidoresHASHDEV
    Odistribuidore.delete_all
    for oc in @OCDistribuidoresHASH
      begin
      orden_compra = ApiOrdenCompra.getOrdenCompra(oc["order"]["id"])
      puts Odistribuidore.create("_id": orden_compra["_id"], "estado": orden_compra["estado"])
      rescue
        retry
      end
    end
  end

  def self.estado_Ordenes_PROD
    self.OCDistribuidoresHASHPROD
    Odistribuidore.delete_all
    for oc in @OCDistribuidoresHASH
      begin
      orden_compra = ApiOrdenCompra.getOrdenCompra(oc["order"]["id"])
      puts Odistribuidore.create("_id": orden_compra["_id"], "estado": orden_compra["estado"])
      rescue
        retry
      end
    end
  end

end

#APIDistribuidores.OCDistribuidoresXMLDEV
