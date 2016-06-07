class InvitationsController < ApplicationController
  def index
  end

  def create
    params[:emails].scan(/[^@\s]+@(?:[-a-z0-9]+\.)+[a-z]{2,}/) { |match|
      Invitation.create(:inviter_email => current_user.email, :message => params[:message], :invite_email => match)
      Notifier.send_invitation(current_user, params[:message], match, @area).deliver
    }
    flash[:success] = 'Success. Invitations sent!'
    redirect_to invitations_path
  end
end
