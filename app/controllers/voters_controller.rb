class VotersController < ApplicationController
  # GET /voters
  # GET /voters.xml
  def index
    @voters = Voter.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @voters }
    end
  end

  # GET /voters/1
  # GET /voters/1.xml
  def show
    @voter = Voter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @voter }
    end
  end

  # GET /voters/new
  # GET /voters/new.xml
  def new
    @voter = Voter.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @voter }
    end
  end

  # GET /voters/1/edit
  def edit
    @voter = Voter.find(params[:id])
  end

  # POST /voters
  # POST /voters.xml
  def create
    @voter = Voter.new(params[:voter])

    respond_to do |format|
      if @voter.save
        format.html { redirect_to(@voter, :notice => 'Voter was successfully created.') }
        format.xml  { render :xml => @voter, :status => :created, :location => @voter }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @voter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /voters/1
  # PUT /voters/1.xml
  def update
    @voter = Voter.find(params[:id])

    respond_to do |format|
      if @voter.update_attributes(params[:voter])
        format.html { redirect_to(@voter, :notice => 'Voter was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @voter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /voters/1
  # DELETE /voters/1.xml
  def destroy
    @voter = Voter.find(params[:id])
    @voter.destroy

    respond_to do |format|
      format.html { redirect_to(voters_url) }
      format.xml  { head :ok }
    end
  end
end
