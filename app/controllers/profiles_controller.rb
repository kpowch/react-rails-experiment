class ProfilesController < ApplicationController
  # redirect users who are not logged in
  before_action :require_login

  helper ProfileHelper

  # shows the current user's profile - their name, info, suggested/pending friendships
  def index
    # query database to get a new set of friends matching the current user's interests
    save_friendships
    # get the list of suggested and pending friends
    suggested_friends = friendly_three_amigos_method
    pending_friends = pending_three_amigos_method
    # notifications indicating new chatrooms
    notifications = Notification.where(user_id: current_user.id)
    puts "\n\n User notifications #{notifications.inspect}\n\n\n"

    # pass in props to profile page
    @profile_props = {
      current_user: current_user,
      suggested_friends: suggested_friends,
      pending_friends: pending_friends,
      notifications: notifications,
      current_interests: current_interests
    }
  end

  # returns an array of users who have friendship status 'suggested' with current user
  def friendly_three_amigos_method
    suggestedFriends = []

    # find 'suggested' friendships involving the current user
    suggestedFriendshipsInitiator = Friendship.where(user_id: current_user.id, friendship_status: 'suggested')
    suggestedFriendshipsReceiver = Friendship.where(friend_id: current_user.id, friendship_status: 'suggested')
    suggestedFriendships = suggestedFriendshipsInitiator + suggestedFriendshipsReceiver

    # save each suggested friend to the array to render
    suggestedFriendships.each do |friendship|
      # 'suggestedFriend' is the other person in the friendship
      if (friendship.user_id == current_user.id)
        suggestedFriend = User.find(friendship.friend_id)
      else
        suggestedFriend = User.find(friendship.user_id)
      end

      # add the friend's info to the array
      suggestedFriends.push({
        friendship_match: percent_compare(suggestedFriend.id),
        user_id: suggestedFriend.id,
        friendship: friendship,
        first_name: suggestedFriend.first_name,
        last_name: suggestedFriend.last_name,
        email: suggestedFriend.email,
        dob: suggestedFriend.dob,
        profile_picture: suggestedFriend.profile_picture.thumb.url,
        bio: suggestedFriend.bio
      })
    end
    puts "\n\n suggested friends: #{suggestedFriends.inspect} \n\n"
    suggestedFriends # return array
  end

  # returns an array of users who have asked the current user to be friends
  def pending_three_amigos_method
    pendingFriends = []

    # find friendships that users have initiated with current user
    pendingFriendshipsReciever =  Friendship.where(friend_id: current_user.id, friendship_status: 'pending')
    pendingFriendshipsInitiator = Friendship.where(user_id: current_user.id, friendship_status: 'pending')
    pendingFriendships = pendingFriendshipsReciever + pendingFriendshipsInitiator

    # save each pending friend to the array to render
    pendingFriendships.each do |friendship|
      # 'pendingFriend' is the person who initiated the friendship
      if (friendship.user_id == current_user.id)
        pendingFriend = User.find(friendship.friend_id)
      else
        pendingFriend = User.find(friendship.user_id)
      end

      # add the friend's info to the array
      pendingFriends.push({
        friendship_match: percent_compare(pendingFriend.id),
        user_id: pendingFriend.id,
        friendship: friendship,
        first_name: pendingFriend.first_name,
        last_name: pendingFriend.last_name,
        email: pendingFriend.email,
        dob: pendingFriend.dob,
        profile_picture: pendingFriend.profile_picture.thumb.url,
        bio: pendingFriend.bio
      })
    end
    puts "\n\n pending friends: #{pendingFriends.inspect} \n\n"
    pendingFriends # return array
  end

  def current_interests
    array = []
    current_interests = @current_user.interests
    current_interests.each {|interest| array.push(interest.name) }
    array
  end

  def percent_compare(friend_id)
    friend_array = []
    user_array = []
    friend = User.find(friend_id)
    friend_interests = friend.interests
    user_interests = @current_user.interests
    current_interests.each {|interest| user_array.push(interest) }
    friend_interests.each {|interest| friend_array.push(interest.name) }
    compare = friend_array & user_array
    (compare.count.to_f / user_array.count).round(2)
  end
end
