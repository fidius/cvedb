class NvdEntriesController < ApplicationController
  # GET /nvd_entries
  # GET /nvd_entries.xml
  def index
    @nvd_entries = NvdEntry.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @nvd_entries }
    end
  end

  # GET /nvd_entries/1
  # GET /nvd_entries/1.xml
  def show
    @nvd_entry = NvdEntry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @nvd_entry }
    end
  end

  # GET /nvd_entries/new
  # GET /nvd_entries/new.xml
  def new
    @nvd_entry = NvdEntry.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nvd_entry }
    end
  end

  # GET /nvd_entries/1/edit
  def edit
    @nvd_entry = NvdEntry.find(params[:id])
  end

  # POST /nvd_entries
  # POST /nvd_entries.xml
  def create
    @nvd_entry = NvdEntry.new(params[:nvd_entry])

    respond_to do |format|
      if @nvd_entry.save
        format.html { redirect_to(@nvd_entry, :notice => 'Nvd entry was successfully created.') }
        format.xml  { render :xml => @nvd_entry, :status => :created, :location => @nvd_entry }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @nvd_entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /nvd_entries/1
  # PUT /nvd_entries/1.xml
  def update
    @nvd_entry = NvdEntry.find(params[:id])

    respond_to do |format|
      if @nvd_entry.update_attributes(params[:nvd_entry])
        format.html { redirect_to(@nvd_entry, :notice => 'Nvd entry was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @nvd_entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /nvd_entries/1
  # DELETE /nvd_entries/1.xml
  def destroy
    @nvd_entry = NvdEntry.find(params[:id])
    @nvd_entry.destroy

    respond_to do |format|
      format.html { redirect_to(nvd_entries_url) }
      format.xml  { head :ok }
    end
  end
end
