class ImpactsController < ApplicationController
  # GET /impacts
  # GET /impacts.xml
  def index
    @impacts = Impact.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @impacts }
    end
  end

  # GET /impacts/1
  # GET /impacts/1.xml
  def show
    @impact = Impact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @impact }
    end
  end

  # GET /impacts/new
  # GET /impacts/new.xml
  def new
    @impact = Impact.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @impact }
    end
  end

  # GET /impacts/1/edit
  def edit
    @impact = Impact.find(params[:id])
  end

  # POST /impacts
  # POST /impacts.xml
  def create
    @impact = Impact.new(params[:impact])

    respond_to do |format|
      if @impact.save
        format.html { redirect_to(@impact, :notice => 'Impact was successfully created.') }
        format.xml  { render :xml => @impact, :status => :created, :location => @impact }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @impact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /impacts/1
  # PUT /impacts/1.xml
  def update
    @impact = Impact.find(params[:id])

    respond_to do |format|
      if @impact.update_attributes(params[:impact])
        format.html { redirect_to(@impact, :notice => 'Impact was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @impact.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /impacts/1
  # DELETE /impacts/1.xml
  def destroy
    @impact = Impact.find(params[:id])
    @impact.destroy

    respond_to do |format|
      format.html { redirect_to(impacts_url) }
      format.xml  { head :ok }
    end
  end
end
