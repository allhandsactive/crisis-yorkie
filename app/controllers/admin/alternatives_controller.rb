class AlternativesController < ApplicationController
  # GET /alternatives
  # GET /alternatives.xml
  def index
    @alternatives = Alternative.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @alternatives }
    end
  end

  # GET /alternatives/1
  # GET /alternatives/1.xml
  def show
    @alternative = Alternative.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @alternative }
    end
  end

  # GET /alternatives/new
  # GET /alternatives/new.xml
  def new
    @alternative = Alternative.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @alternative }
    end
  end

  # GET /alternatives/1/edit
  def edit
    @alternative = Alternative.find(params[:id])
  end

  # POST /alternatives
  # POST /alternatives.xml
  def create
    @alternative = Alternative.new(params[:alternative])

    respond_to do |format|
      if @alternative.save
        format.html { redirect_to(@alternative, :notice => 'Alternative was successfully created.') }
        format.xml  { render :xml => @alternative, :status => :created, :location => @alternative }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @alternative.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /alternatives/1
  # PUT /alternatives/1.xml
  def update
    @alternative = Alternative.find(params[:id])

    respond_to do |format|
      if @alternative.update_attributes(params[:alternative])
        format.html { redirect_to(@alternative, :notice => 'Alternative was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @alternative.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /alternatives/1
  # DELETE /alternatives/1.xml
  def destroy
    @alternative = Alternative.find(params[:id])
    @alternative.destroy

    respond_to do |format|
      format.html { redirect_to(alternatives_url) }
      format.xml  { head :ok }
    end
  end
end
