class VulnerableConfigurationsController < ApplicationController
  # GET /vulnerable_configurations
  # GET /vulnerable_configurations.xml
  def index
    @vulnerable_configurations = VulnerableConfiguration.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vulnerable_configurations }
    end
  end

  # GET /vulnerable_configurations/1
  # GET /vulnerable_configurations/1.xml
  def show
    @vulnerable_configuration = VulnerableConfiguration.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vulnerable_configuration }
    end
  end

  # GET /vulnerable_configurations/new
  # GET /vulnerable_configurations/new.xml
  def new
    @vulnerable_configuration = VulnerableConfiguration.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vulnerable_configuration }
    end
  end

  # GET /vulnerable_configurations/1/edit
  def edit
    @vulnerable_configuration = VulnerableConfiguration.find(params[:id])
  end

  # POST /vulnerable_configurations
  # POST /vulnerable_configurations.xml
  def create
    @vulnerable_configuration = VulnerableConfiguration.new(params[:vulnerable_configuration])

    respond_to do |format|
      if @vulnerable_configuration.save
        format.html { redirect_to(@vulnerable_configuration, :notice => 'Vulnerable configuration was successfully created.') }
        format.xml  { render :xml => @vulnerable_configuration, :status => :created, :location => @vulnerable_configuration }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vulnerable_configuration.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /vulnerable_configurations/1
  # PUT /vulnerable_configurations/1.xml
  def update
    @vulnerable_configuration = VulnerableConfiguration.find(params[:id])

    respond_to do |format|
      if @vulnerable_configuration.update_attributes(params[:vulnerable_configuration])
        format.html { redirect_to(@vulnerable_configuration, :notice => 'Vulnerable configuration was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vulnerable_configuration.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vulnerable_configurations/1
  # DELETE /vulnerable_configurations/1.xml
  def destroy
    @vulnerable_configuration = VulnerableConfiguration.find(params[:id])
    @vulnerable_configuration.destroy

    respond_to do |format|
      format.html { redirect_to(vulnerable_configurations_url) }
      format.xml  { head :ok }
    end
  end
end
