# frozen_string_literal: true

FactoryBot.define do
  factory :activity do
    association :user
    association :recipient
    association :trackable
    action "create_record"
  end
end
