namespace :robots do
  desc "run robot builder"
  task builder: :environment do
  	puts 'Press Ctrl + C to quit'
  	clear_cars_history if Car.any? && !Car.last.created_at.today?
  	start_building
  end

  desc "TODO"
  task guard: :environment do
  end

  desc "TODO"
  task buyer: :environment do
  end

  def start_building
  	loop do
  		puts "building #{ENV['cars_built_per_minute']} cars..."
  		ENV['cars_built_per_minute'].to_i.times do
  			service = Cars::CreateCar.new
  			service.call

  			if service.valid?
  				puts "Built: #{service.car.car_model.brand} - #{service.car.car_model.name}"
  				puts "-- has any defects: #{service.car.has_any_defect?}"
  				if service.car.has_any_defect?
  					puts "-- defective parts: #{service.car.defective_parts}"
  				end
  			else
  				puts "It was a problem building a car: #{service.errors}"
  			end
  		end
  		sleep 10
  	end
  end

  def clear_cars_history
  	puts "new day, deleting existing cars..."
  	Car.destroy_all
  end
end
