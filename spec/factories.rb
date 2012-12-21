FactoryGirl.define do
  factory :user do |f|
    f.sequence(:email){ |n| "foo-#{n}@example.com"}
    f.password "secret"
  end

  factory :message do |f|
    f.sequence(:text){ |n| "foo bar #{n}"}
  end

end

