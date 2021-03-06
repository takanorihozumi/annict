# frozen_string_literal: true
# == Schema Information
#
# Table name: follows
#
#  id           :integer          not null, primary key
#  user_id      :integer          not null
#  following_id :integer          not null
#  created_at   :datetime
#  updated_at   :datetime
#
# Indexes
#
#  follows_following_id_idx          (following_id)
#  follows_user_id_following_id_key  (user_id,following_id) UNIQUE
#  follows_user_id_idx               (user_id)
#

module Api
  module Internal
    class FollowsController < ApplicationController
      before_action :authenticate_user!
      before_action :load_user, only: %i(create unfollow)

      def create(page_category)
        current_user.follow(@user)
        ga_client.page_category = page_category
        ga_client.events.create(:follows, :create)
        keen_client.publish(
          "create_follows",
          user: current_user,
          page_category: page_category,
          via: "internal_api",
          followed_user: @user
        )
        EmailNotificationService.send_email("followed_user", @user, current_user.id)
        head 201
      end

      def unfollow
        current_user.unfollow(@user)
        head 200
      end

      private

      def load_user
        @user = User.find_by(username: params[:username])
      end
    end
  end
end
