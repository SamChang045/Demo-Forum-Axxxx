class FriendshipsController < ApplicationController

  #我加的但對方還沒接受
  def create
    @friendship = current_user.not_yet_accepted_by_friendships.build(friend_id: params[:friend_id])
    if @friendship.save
      flash[:notice] = "Friend all together."
    end
    @user = User.find(params[:friend_id])
    respond_to do |format|
      format.js
    end
  end

  #加我但我還沒回應, 我該回應了!
  def accept
    @friendship = current_user.not_yet_responded_to_friendships.find_by(user_id: params[:id])
    @friendship.update(status: true)
    @user = User.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  #加我但我還沒回應
  def ignore
    @friendship = current_user.not_yet_responded_to_friendships.find_by(user_id: params[:id])
    @friendship.destroy
    @user = User.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def destroy
  end  
end
