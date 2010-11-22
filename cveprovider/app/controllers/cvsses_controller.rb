class CvssesController < ApplicationController
  # GET /cvsses
  # GET /cvsses.xml
  def index
    @cvsses = Cvss.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cvsses }
    end
  end

  # GET /cvsses/1
  # GET /cvsses/1.xml
  def show
    @cvss = Cvss.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cvss }
    end
  end

  # GET /cvsses/new
  # GET /cvsses/new.xml
  def new
    @cvss = Cvss.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cvss }
    end
  end

  # GET /cvsses/1/edit
  def edit
    @cvss = Cvss.find(params[:id])
  end

  # POST /cvsses
  # POST /cvsses.xml
  def create
    @cvss = Cvss.new(params[:cvss])

    respond_to do |format|
      if @cvss.save
        format.html { redirect_to(@cvss, :notice => 'Cvss was successfully created.') }
        format.xml  { render :xml => @cvss, :status => :created, :location => @cvss }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cvss.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cvsses/1
  # PUT /cvsses/1.xml
  def update
    @cvss = Cvss.find(params[:id])

    respond_to do |format|
      if @cvss.update_attributes(params[:cvss])
        format.html { redirect_to(@cvss, :notice => 'Cvss was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cvss.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cvsses/1
  # DELETE /cvsses/1.xml
  def destroy
    @cvss = Cvss.find(params[:id])
    @cvss.destroy

    respond_to do |format|
      format.html { redirect_to(cvsses_url) }
      format.xml  { head :ok }
    end
  end
end
