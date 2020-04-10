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

  factory :order do
    car { create(:car) }
    car_model { car.car_model }
    total { car.price }
    cost_price { car.cost_price }
    status { 'completed' }
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