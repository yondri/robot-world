namespace :robots do
  desc "run builder robot"
  task builder: :environment do
  	puts 'Press Ctrl + C to quit'
  	clear_cars_history if Car.any? && !Car.last.created_at.today?
  	start_building
  end

  desc "run guard robot"
  task guard: :environment do
  	puts 'Press Ctrl + C to quit'
  	start_guarding
  end

  desc "run buyer robot"
  task buyer: :environment do
  	puts 'Press Ctrl + C to quit'
  	start_buying
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
  			puts '----------------------------'
  		end
  		sleep 60
  	end
  end

  def start_buying
  	loop do
  		quantity = rand(1..10) * ENV['buyer_robot_time_interval'].to_i
  		puts "buying #{quantity} cars every #{ENV['buyer_robot_time_interval'].to_i} minutes..."

  		quantity.times do
  			car_model = CarModel.all.sample
  			puts "want to buy #{car_model.brand} - #{car_model.name}"

  			order = car_model.orders.create
  			car = Car.in_store.find_by(car_model: car_model)

  			if car.present?
  				puts "there is stock in store, processing order"
  				order.update(car: car, total: car.price, cost_price: car.cost_price)
  				car.sold!
  				order.completed!

  				check_sold_car_stock(order)

  				puts "created order ##{order.id}"
  			else
  				puts "there is NOT stock in store, creating failed order"
  				order.incomplete!
  			end
  			puts '----------------------------'
  		end
  		sleep ENV['buyer_robot_time_interval'].to_i * 60
  	end
  end

  def start_guarding
  	loop do
	  	Car.in_factory.each do |car|
	  		puts "Processing: #{car.car_model.brand} - #{car.car_model.name}"
  			puts "-- has defects: #{car.has_any_defect?}"
	  		if car.has_any_defect?
	  			# using defective status to avoid checking the same cars again next time
	  			car.defective!
	  			puts "-- set as defective"
	  		else
	  			car.in_store!
	  			puts "-- taken to store"
	  		end
	  		puts '----------------------------'
	  	end
	  	sleep 1800
	  end
  end

  def clear_cars_history
  	puts "new day, deleting existing cars..."
  	Car.destroy_all
  end

  def check_sold_car_stock(order)
  	if Car.in_store.where(car_model: order.car_model).count < 2
  		puts "** stock for #{order.car_model.name} is too low, checking factory stock..."
  		cars = Car.in_factory.where(car_model: order.car_model)
  		if cars.any?
  			puts "** taking #{cars.count} cars from factory to store"
  			cars.each {|car| car.in_store!}
  		end
  	end
  end
end
