class DecisionController < ApplicationController
  skip_before_filter :authorize
  def new
  end

  def create
    @vote = Vote.new(params[:vote]) # :token

    respond_to do |format|
      if @vote.save
        # format.html { redirect_to(@vote, :notice => 'Vote was successfully created.') }
        format.html do redirect_to('/',
          :notice => "One #{@vote.name} vote was successfully cast for " <<
            "voting token \"#{@vote.token}\".")
        end
        # format.xml  { render :xml => @vote, :status => :created, :location => @vote }
      else
        # format.html { render :action => "new" }
        format.html { render('bylaws') }
        # format.xml  { render :xml => @vote.errors, :status => :unprocessable_entity }
      end
    end
  end

  def bylaws
    # just show static view for now
  end

end
