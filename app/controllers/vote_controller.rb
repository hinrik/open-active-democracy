class VoteController < ApplicationController

  before_filter :get_vote, :except => :index
  
  def index
    redirect_to "/"
  end
  
  def yes
    @vote.approve!
    flash[:notice] = tr("Your endorsement/opposition was transferred to {priority_name}", "controller/vote", :priority_name => @vote.change.new_priority.name)
    self.current_user = @vote.user unless logged_in?
    redirect_to priority_change_url(@vote.change.priority, @vote.change)
    return
  end
  
  def maybe
    self.current_user = @vote.user unless logged_in?
    redirect_to priority_change_url(@vote.change.priority, @vote.change)
    return
  end  
  
  def no
    @vote.decline!
    flash[:notice] = tr("Your endorsement/opposition will remain unchanged.", "controller/vote", :priority_name => @vote.change.priority.name)
    self.current_user = @vote.user unless logged_in?
    redirect_to priority_change_url(@vote.change.priority, @vote.change)
    return
  end

  private
  def get_vote
    @vote = Vote.find_by_code(params[:code])
    if not @vote
      flash[:error] = tr("Could not find that ballot, check to make sure your link is correct and didn't get chopped up by your email program.", "controller/vote")
    end
    for n in @vote.notifications.unread
      n.read!
    end
    if @vote.status == 'approved'
      flash[:error] = tr("You already voted yes on this acquisition. Your endorsement/opposition was transferred to {priority_name}", "controller/vote", :priority_name => @vote.change.new_priority.name)
      redirect_to @vote.change.new_priority
      return
    elsif @vote.status == 'declined'
      flash[:error] = tr("You already voted no", "controller/vote", :priority_name => @vote.change.priority.name)
      redirect_to @vote.change.priority      
      return
    elsif @vote.status == 'implicit_approved'
      flash[:error] = tr("Voting is over, the proposal passed, and your endorsement/opposition was moved to this priority", "controller/vote", :priority_name => @vote.change.new_priority.name)
      redirect_to @vote.change.new_priority
      return      
    elsif @vote.status == 'implicit_declined'
      flash[:error] = tr("Voting is over, the proposal failed, so your endorsement/opposition remains with this priority.", "controller/vote", :priority_name => @vote.change.priority.name)
      redirect_to @vote.change.priority      
      return      
    elsif @vote.status == 'inactive'
      flash[:error] = tr("Voting period expired", "controller/vote")
      if @vote.change.status == 'approved'
        redirect_to @vote.change.new_priority
      else
        redirect_to @vote.change.priority
      end
      return
    elsif @vote.status == 'removed'
      redirect_to "/"
      return
    end    
    
  end
  
end
