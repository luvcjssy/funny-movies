FactoryBot.define do
  factory :video do
    title { Faker::Movie.title }
    url { 'https://www.youtube.com/watch?v=9vaLkYElidg' }
    description { Faker::Lorem.paragraphs }
    user { create(:user) }
  end
end
