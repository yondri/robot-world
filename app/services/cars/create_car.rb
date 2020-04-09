module Cars
  class CreateCar < BaseService
    attr_accessor :car

    def initialize
      price = Faker::Commerce.price(range: 2000..50000)
      @car = Car.create(
        year: Faker::Vehicle.year,
        price: price,
        cost_price: price - (price*0.12),
        car_model: CarModel.all.sample
      )
      @valid = false
    end

    def call
      basic_structure
      electronic_devices
      final_details
      @car.completed!
      @car.in_factory!

      set_as_valid!
    end

    private

    def basic_structure
      @car.basic!
      @car.parts_defect.update(wheels: part_is_defective, chassis: part_is_defective)
    end

    def electronic_devices
      @car.electronics!
      @car.parts_defect.update(laser: part_is_defective, computer: part_is_defective, engine: part_is_defective)
    end

    def final_details
      @car.details!
      @car.parts_defect.update(seats: part_is_defective)
    end

    def part_is_defective
      rand() < ENV['defective_probability'].to_d
    end
  end
end