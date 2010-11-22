class VulnerableSoftwaresController < ApplicationController
  # GET /vulnerable_softwares
  # GET /vulnerable_softwares.xml
  def index
    @vulnerable_softwares = VulnerableSoftware.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vulnerable_softwares }
    end
  end

  # GET /vulnerable_softwares/1
  # GET /vulnerable_softwares/1.xml
  def show
    @vulnerable_software = VulnerableSoftware.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vulnerable_software }
    end
  end

  # GET /vulnerable_softwares/new
  # GET /vulnerable_softwares/new.xml
  def new
    @vulnerable_software = VulnerableSoftware.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vulnerable_software }
    end
  end

  # GET /vulnerable_softwares/1/edit
  def edit
    @vulnerable_software = VulnerableSoftware.find(params[:id])
  end

  # POST /vulnerable_softwares
  # POST /vulnerable_softwares.xml
  def create
    @vulnerable_software = VulnerableSoftware.new(params[:vulnerable_software])

    respond_to do |format|
      if @vulnerable_software.save
        format.html { redirect_to(@vulnerable_software, :notice => 'Vulnerable software was successfully created.') }
        format.xml  { render :xml => @vulnerable_software, :status => :created, :location => @vulnerable_software }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vulnerable_software.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /vulnerable_softwares/1
  # PUT /vulnerable_softwares/1.xml
  def update
    @vulnerable_software = VulnerableSoftware.find(params[:id])

    respond_to do |format|
      if @vulnerable_software.update_attributes(params[:vulnerable_software])
        format.html { redirect_to(@vulnerable_software, :notice => 'Vulnerable software was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vulnerable_software.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vulnerable_softwares/1
  # DELETE /vulnerable_softwares/1.xml
  def destroy
    @vulnerable_software = VulnerableSoftware.find(params[:id])
    @vulnerable_software.destroy

    respond_to do |format|
      format.html { redirect_to(vulnerable_softwares_url) }
      format.xml  { head :ok }
    end
  end
end
