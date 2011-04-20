class DecisionController < ApplicationController
  skip_before_filter :authorize
  def new
    find_decision! or return
    render_form
  end

  def create
    find_decision! or return
    @vote = Vote.new(params[:vote]) # "token" | "human_hash"
    @vote.question_type = @decision.question_type || :yes_no_abstain # @todo
    @vote.decision_intern = @decision.intern
    if @vote.save
      msg = "You successfully voted #{@vote.value.inspect} on the #{@vote.name} vote."
      respond_to { |f| f.html { redirect_to('/', :notice => msg) } }
    else
      respond_to { |f| f.html { render_form } }
    end
  end
private
  def find_decision!
    slug = params['slug']
    if @decision = Decision.find_by_intern(slug)
      # @todo unhack!
      @decision.question_type = :choice if /direlect/i =~ @decision.intern
      true
    else
      decision_not_found slug
    end
  end
  def decision_not_found slug
    @decision = Decision.new
    @decision.errors.add('base', "There is no decision on recored with the name " <<
      "#{slug.inspect}")
    false # important
  end
  def populate_alternatives
    @alternatives = Alternative.all # @todo
    @alternatives.shuffle!
    @alternatives.each_with_index { |a, idx| a.random_ordinal_index = idx + 1 }
  end
  def render_form
    if @decision.create_path && File.exist?(@decision.create_path)
      populate_alternatives if :choice == @decision.question_type
      render @decision.intern
    else
      @decision.errors.add('base', "for now we have no scaffolding for decisions. "<<
        "No view found for #{@decision.intern.inspect}.")
    end
  end
end

# format.xml  { render :xml => @vote.errors, :status => :unprocessable_entity }
# format.html { render :action => "new" }
# format.xml  { render :xml => @vote, :status => :created, :location => @vote }
# format.html { redirect_to(@vote, :notice => 'Vote was successfully created.') };
