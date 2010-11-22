class IntegrityImpactsController < ApplicationController
  # GET /integrity_impacts
  # GET /integrity_impacts.xml
  def index
    @integrity_impacts = IntegrityImpact.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @integrity_impacts }
    end
  end

  # GET /integrity_impacts/1
  # GET /integrity_impacts/1.xml
  def show
    @integrity_impact = IntegrityImpact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @integrity_impact }
    end
  end

  # GET /integrity_impacts/new
  # GET /integrity_impacts/new.xml
  def new
    @integrity_impact = IntegrityImpact.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @integrity_impact }
    end
  end

  # GET /integrity_impacts/1/edit
  def edit
    @integrity_impact = IntegrityImpact.find(params[:id])
  end

  # POST /integrity_impacts
  # POST /integrity_impacts.xml
  def create
    @integrity_impact = IntegrityImpact.new(params[:integrity_impact])

    respond_to do |format|
      if @integrity_impact.save
        format.html { redirect_to(@integrity_impact, :notice => 'Integrity impact was successfully created.') }
        format.xml  { render :xml => @integrity_impact, :status => :created, :location => @integrity_impact }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @integrity_impact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /integrity_impacts/1
  # PUT /integrity_impacts/1.xml
  def update
    @integrity_impact = IntegrityImpact.find(params[:id])

    respond_to do |format|
      if @integrity_impact.update_attributes(params[:integrity_impact])
        format.html { redirect_to(@integrity_impact, :notice => 'Integrity impact was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @integrity_impact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /integrity_impacts/1
  # DELETE /integrity_impacts/1.xml
  def destroy
    @integrity_impact = IntegrityImpact.find(params[:id])
    @integrity_impact.destroy

    respond_to do |format|
      format.html { redirect_to(integrity_impacts_url) }
      format.xml  { head :ok }
    end
  end
end
