FactoryGirl.define do 
  factory :user do
    year "2002" 
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"
    profile_info "Random Info"


    factory :admin do 
      admin true 
    end
  end

  factory :micropost do 
    title   "Lorem ipsum"
    content "Lorem ipsum"
    user
  end
end