FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    description { 'A test project.' }
    due_on { 1.week.from_now }
    association :owner

    # 締め切りが昨日
    trait :due_yesterday do
      due_on { 1.day.ago }
    end

    # 締め切りが今日
    trait :due_today do
      due_on { Date.current.in_time_zone }
    end

    # 締め切りが明日
    trait :due_tomorrow do
      due_on { 1.day.from_now }
    end
  end
end
