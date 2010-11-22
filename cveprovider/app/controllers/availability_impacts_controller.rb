class AvailabilityImpactsController < ApplicationController
  # GET /availability_impacts
  # GET /availability_impacts.xml
  def index
    @availability_impacts = AvailabilityImpact.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @availability_impacts }
    end
  end

  # GET /availability_impacts/1
  # GET /availability_impacts/1.xml
  def show
    @availability_impact = AvailabilityImpact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @availability_impact }
    end
  end

  # GET /availability_impacts/new
  # GET /availability_impacts/new.xml
  def new
    @availability_impact = AvailabilityImpact.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @availability_impact }
    end
  end

  # GET /availability_impacts/1/edit
  def edit
    @availability_impact = AvailabilityImpact.find(params[:id])
  end

  # POST /availability_impacts
  # POST /availability_impacts.xml
  def create
    @availability_impact = AvailabilityImpact.new(params[:availability_impact])

    respond_to do |format|
      if @availability_impact.save
        format.html { redirect_to(@availability_impact, :notice => 'Availability impact was successfully created.') }
        format.xml  { render :xml => @availability_impact, :status => :created, :location => @availability_impact }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @availability_impact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /availability_impacts/1
  # PUT /availability_impacts/1.xml
  def update
    @availability_impact = AvailabilityImpact.find(params[:id])

    respond_to do |format|
      if @availability_impact.update_attributes(params[:availability_impact])
        format.html { redirect_to(@availability_impact, :notice => 'Availability impact was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @availability_impact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /availability_impacts/1
  # DELETE /availability_impacts/1.xml
  def destroy
    @availability_impact = AvailabilityImpact.find(params[:id])
    @availability_impact.destroy

    respond_to do |format|
      format.html { redirect_to(availability_impacts_url) }
      format.xml  { head :ok }
    end
  end
end
