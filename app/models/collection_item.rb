# frozen_string_literal: true
# == Schema Information
#
# Table name: collection_items
#
#  id              :integer          not null, primary key
#  user_id         :integer          not null
#  collection_id   :integer          not null
#  work_id         :integer          not null
#  title           :string           not null
#  comment         :text
#  aasm_state      :string           default("published"), not null
#  reactions_count :integer          default(0), not null
#  position        :integer          default(0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_collection_items_on_collection_id              (collection_id)
#  index_collection_items_on_collection_id_and_work_id  (collection_id,work_id) UNIQUE
#  index_collection_items_on_user_id                    (user_id)
#  index_collection_items_on_work_id                    (work_id)
#

class CollectionItem < ApplicationRecord
  include AASM

  acts_as_list scope: :collection_id

  aasm do
    state :published, initial: true
    state :hidden

    event :hide do
      transitions from: :published, to: :hidden
    end
  end

  belongs_to :user
  belongs_to :collection, touch: true
  belongs_to :work
  has_many :reactions, dependent: :destroy

  validates :title, presence: true, length: { maximum: 50 }
  validates :comment, length: { maximum: 1000 }
end
