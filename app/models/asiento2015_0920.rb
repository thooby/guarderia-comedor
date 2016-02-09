class Asiento < ActiveRecord::Base
  validates :fecha, :tipo, :monto, :descripcion, :presence => true
  belongs_to :categorium
  belongs_to :tipo
  belongs_to :cuentum
  self.per_page = 10
  scope :cuentas, lambda {|cuentum_id| where "'asientos'.'cuentum_id' = ?", cuentum_id}
  scope :descen, order('fecha DESC, id DESC')
  scope :ascen, order('fecha ASC, id ASC')
  scope :sel_trozo,lambda {|fech1,fech2,categorium_id,cuentum_id,tipo_id| where("(date('asientos'.'fecha') >= ?) and 
                                              (date('asientos'.'fecha') <= ?) and 
                                              ('asientos'.'categorium_id' = ?) and
                                              ('asientos'.'cuentum_id' = ?) and
                                              ('asientos'.'tipo_id' = ?)",
                                               fech1,fech2,categorium_id,cuentum_id,tipo_id)}
  
  @mes_nom = {
              1 => "Enero",
              2 => "Febrero",
              3 => "Marzo",
              4 => "Abril",
              5 => "Mayo",
              6 => "Junio",
              7 => "Julio",
              8 => "Agosto",
              9 => "Septiembre",
              10 => "Octubre",
              11 => "Noviembre",
              12 => "Diciembre"
             }
                                              
  def self.informe_mensual
  end
  def self.informe_mes(mes,anno)
    gap = Date.new(anno,mes,1)
    gap2 = Date.today
    gap_ini = gap.at_beginning_of_month
    gap_end = gap.at_end_of_month  
    if (gap_ini.month==gap2.month) and (gap_ini.year==gap2.year) then
      gap_end=gap2
    end
    informe(gap_ini, gap_end)
  end
  def self.informe(gap_ini,gap_end)
    salida = ["Informe del mes de #{@mes_nom[gap_ini.month]} hasta el dia #{gap_end.day}"]
    cates = Categorium.all.map{|x| [x.id,x.descripcion]}
    cuentas = Cuentum.all.map{|x| [x.id,x.nombre]}
    tipos = Tipo.all.map{|x| [x.id,x.descripcion]}
    n = 0

    cuentas.each do |cuenta|
          @suma_total = 0
      salida  << ["<h2>Cuenta #{cuenta[1]}</h2>"]
      tipos.each do |tipo|
        suma = 0
        salida  << ["<h3>#{tipo[1]}</h3>"]
        cates.each do |cate|
          item = cate[1].capitalize
          logger.debug "Mirando Luzarra *********** #{gap_ini.month}   #{gap_ini.day}  " 
          #logger.debug “Mirando Luzarra ********** #{gap_ini.month}  #{gap_ini.day}”
          valor = self.sel_trozo(gap_ini,gap_end,cate[0],cuenta[0],tipo[0]).sum(:monto)
          if (valor != 0)
            suma += valor
            z = [item,valor]
            salida <<z
          end
        end
        item = "<b>Sub total #{tipo[1].downcase}</b>"
        z = [item,suma]
        if tipo[1]=='Ingreso'
          @suma_total += suma
        elsif tipo[1]=='Gasto'
          @suma_total -= suma
        end
        salida <<z
      end
      salida << ['<span class="green">Saldo mensual</span>',@suma_total]
    end
    salida
  end
  def save_pair(cuentum1_id,cuentum2_id,categorium1_id)
     if params[:asiento][:categorium_id]==categorium1_id then
      @params2=params[:asiento]
      params[:asiento][:cuentum_id]=@usercuenta
      if params[:asiento][:tipo_id]==2 then
        @params2[:tipo_id]=1
      else
        @params2[:tipo_id]=2
      end
      if params[:asiento][:cuentum_id]==cuentum2 then
        @params2[:cuentum_id]=cuentum1
      else
        @params2[:cuentum_id]=cuentum2
      end
      @asiento2 = Asiento.new(@params2)
      guardar = @asiento.save and @asiento2.save
    else
      guardar = @asiento.save
    end
  end

end
