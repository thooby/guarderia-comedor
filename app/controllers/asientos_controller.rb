class AsientosController < ApplicationController
  # GET /asientos
  # GET /asientos.json
  load_and_authorize_resource
  
  def index    
    if params[:asiento]
      @usercuenta = params[:asiento][:cuentum_id] 
    elsif params[:cuentum_id]
      @usercuenta = params[:cuentum_id]
    else
      @usercuenta = 1
    end
    @asientos2 = Asiento.cuentas(@usercuenta).ascen
    @asientos = Asiento.cuentas(@usercuenta).descen.page(params[:page])
    logger.debug "METHOD: i n d e x  -------> #{params} @usercuenta = #{@usercuenta} "
    hoy=Date.today
    caja_cuenta=Cuentum.find(@usercuenta).nombre
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @asientos }
      format.csv { response.headers['Content-Disposition'] = "attachment; filename=\"asientos_#{hoy}_#{caja_cuenta}.csv\""}
    end
  end

  # GET /asientos/1
  # GET /asientos/1.json
  def show
    @asiento = Asiento.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @asiento }
    end
  end

  # GET /asientos/new
  # GET /asientos/new.json
  def new
    logger.debug "METHOD: n e w  -------> #{params} "
    if params[:asiento]
      @usercuenta = params[:asiento][:cuentum_id] 
    elsif params[:cuentum_id]
      @usercuenta = params[:cuentum_id]
    else
      @usercuenta = 1
    end

    @asiento = Asiento.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @asiento }
    end
  end

  # GET /asientos/1/edit
  def edit

    logger.debug "METHOD: e d i t  -------> #{params} "
    if params[:asiento]
      @usercuenta = params[:asiento][:cuentum_id] 
    elsif params[:cuentum_id]
      @usercuenta = params[:cuentum_id]
    else
      @usercuenta = 1
    end
    @asiento = Asiento.find(params[:id])
  end

  # POST /asientos
  # POST /asientos.json
  def create

    @asiento = Asiento.new(params[:asiento])
    if params[:asiento][:categorium_id]=="4" and 
      (  params[:asiento][:cuentum_id]=="2"  
      ) then
      guardar =save_pair("1","2",params)
    elsif params[:asiento][:categorium_id]=="9" and
      (  params[:asiento][:cuentum_id]=="1"  
      ) then
      guardar =save_pair("1","3",params)
    else
      guardar = @asiento.save
    end
    respond_to do |format|
      if guardar  
        format.html { redirect_to @asiento, :notice => 'El apunte fue creado.' }
        format.json { render :json => @asiento, :status => :created, :location => @asiento }
      else
        format.html { render :action => "new" }
        format.json { render :json => @asiento.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /asientos/1
  # PUT /asientos/1.json
  def update
    @asiento = Asiento.find(params[:id])
    respond_to do |format|
      if @asiento.update_attributes(params[:asiento])
        format.html { redirect_to @asiento, :notice => 'El apunte fue cambiado.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @asiento.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /asientos/1
  # DELETE /asientos/1.json
  def destroy
    @asiento = Asiento.find(params[:id])
    @usercuenta=@asiento.cuentum_id
    @asiento.destroy
  
    respond_to do |format|
      logger.debug "Asiento  D E S T R O Y E D -------> #{params} #{@usercuenta} "
      format.html { redirect_to asientos_url :cuentum_id => @usercuenta }
      format.json { head :ok }
    end
  end
def save_pair(cuentum1_id, cuentum2_id,params)
  @params2=params[:asiento]
  logger.debug "P A R A M S (0)-------> #{params[:asiento]} -> #{@usercuenta}"
  logger.debug "P A R A M S (00)-------> #{cuentum1_id} -> #{cuentum2_id}"
  if params[:asiento][:tipo_id]=="2" then
    @params2[:tipo_id]="1"
  else 
    @params2[:tipo_id]="2"
  end       
  if params[:asiento][:cuentum_id]==cuentum2_id then
    logger.debug "P A R A M S (1) -------> #{params[:asiento][:cuentum_id]} -> #{cuentum2_id} "
    @params2[:cuentum_id]=cuentum1_id
  else 
    logger.debug "P A R A M S (2) -------> #{params[:asiento][:cuentum_id]} -> #{cuentum2_id} "
    @params2[:cuentum_id]=cuentum2_id
  end       
  @asiento2 = Asiento.new(@params2)
  guardar = @asiento.save and @asiento2.save
end
end
