class ConfidentialityImpactsController < ApplicationController
  # GET /confidentiality_impacts
  # GET /confidentiality_impacts.xml
  def index
    @confidentiality_impacts = ConfidentialityImpact.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @confidentiality_impacts }
    end
  end

  # GET /confidentiality_impacts/1
  # GET /confidentiality_impacts/1.xml
  def show
    @confidentiality_impact = ConfidentialityImpact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @confidentiality_impact }
    end
  end

  # GET /confidentiality_impacts/new
  # GET /confidentiality_impacts/new.xml
  def new
    @confidentiality_impact = ConfidentialityImpact.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @confidentiality_impact }
    end
  end

  # GET /confidentiality_impacts/1/edit
  def edit
    @confidentiality_impact = ConfidentialityImpact.find(params[:id])
  end

  # POST /confidentiality_impacts
  # POST /confidentiality_impacts.xml
  def create
    @confidentiality_impact = ConfidentialityImpact.new(params[:confidentiality_impact])

    respond_to do |format|
      if @confidentiality_impact.save
        format.html { redirect_to(@confidentiality_impact, :notice => 'Confidentiality impact was successfully created.') }
        format.xml  { render :xml => @confidentiality_impact, :status => :created, :location => @confidentiality_impact }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @confidentiality_impact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /confidentiality_impacts/1
  # PUT /confidentiality_impacts/1.xml
  def update
    @confidentiality_impact = ConfidentialityImpact.find(params[:id])

    respond_to do |format|
      if @confidentiality_impact.update_attributes(params[:confidentiality_impact])
        format.html { redirect_to(@confidentiality_impact, :notice => 'Confidentiality impact was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @confidentiality_impact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /confidentiality_impacts/1
  # DELETE /confidentiality_impacts/1.xml
  def destroy
    @confidentiality_impact = ConfidentialityImpact.find(params[:id])
    @confidentiality_impact.destroy

    respond_to do |format|
      format.html { redirect_to(confidentiality_impacts_url) }
      format.xml  { head :ok }
    end
  end
end
