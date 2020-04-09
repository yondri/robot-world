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

      send_guard_notification if @car.has_any_defect?

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

    def send_guard_notification
      if ENV['send_guard_notifications'] == 'true'
        text = "Robot guard 7500 ha encontrado un auto defectuoso :bangbang:"
        text += "\n*Modelo:* #{car.car_model.brand} - #{car.car_model.name} :car:"
        text += "\n*Partes defectuosas:* #{car.defective_parts}"
        uri = URI('https://hooks.slack.com/services/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')
        request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        request.body = {text: text}.to_json
        result = Net::HTTP.start(uri.hostname, uri.port) do |http|
          http.request(request)
        end
      end
    end
  end
end