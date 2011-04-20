class DecisionController < ApplicationController
  skip_before_filter :authorize
  def new
    slug = params['slug']
    @decision = Decision.find_by_intern(slug) or return decision_not_found
    if File.exist? @decision.create_path
      puts "RENDERING #{@decision.intern}"
      render @decision.intern
    else
      @decision.errors.add('base', "for now we have no scaffolding for decisions. "<<
        "No view found for #{@decision.intern.inspect}.")
    end
  end

  def create
    slug = params['slug']
    @decision = Decision.find_by_intern(slug) or return decision_not_found
    @vote = Vote.new(params[:vote]) # :token

    respond_to do |format|
      if @vote.save
        format.html do redirect_to('/',
          :notice => "You successfully voted #{@vote.value.inspect} on the #{@vote.name} vote."
        )
          end
      else
        format.html { render(@decision.intern) }
      end
    end
  end
private
  def decision_not_found
    @decision = Decision.new
    @decision.errors.add('base', "There is no decision on recored with the name " <<
      "#{slug.inspect}")
  end
end

# format.xml  { render :xml => @vote.errors, :status => :unprocessable_entity }
# format.html { render :action => "new" }
# format.xml  { render :xml => @vote, :status => :created, :location => @vote }
# format.html { redirect_to(@vote, :notice => 'Vote was successfully created.') };
