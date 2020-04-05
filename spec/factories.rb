FactoryBot.define do
	factory :car_model do
		name { Faker::Vehicle.make }
		brand { Faker::Vehicle.manufacture }
	end

  factory :car do
  	year { Faker::Vehicle.year }
  	price { Faker::Commerce.price(range: 2000..50000) }
  	cost_price { price - (price*0.12) }
    car_model { create(:car_model) }
    association :parts_defect, strategy: :build
  end

  factory :parts_defect do
  	wheels { true }
  	chassis { true }
  	laser { true }
  	computer { true }
  	engine { true }
  	seats { true }
  end
end