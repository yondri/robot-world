namespace :orders do
  desc "exchange order car model"
  task :exchange, [:order_id, :car_model] => [:environment] do |task, args|
    puts "chacking params..."
    order = Order.find args[:order_id]
    if order.present?
      car_model = CarModel.find_by(name: args[:car_model])
      if car_model.present?
        new_car = Car.in_store.find_by(car_model: car_model)
        if new_car.present?
          order.car.in_store!
          order.returned!

          new_order = car_model.orders.create(car: new_car, total: new_car.price, cost_price: new_car.cost_price)
          new_car.sold!
          new_order.completed!

          puts "Change request completed!"
        else
          puts "There's no stock available for requested model, please try again later"
        end
      else
        puts "Invalid car model, please use car model name"
      end
    else
      puts "Invalid order id"
    end
  end

  desc "show daily stats"
  task :stats, [:order_id, :car_model] => [:environment] do |task, args|
    puts "general stats..."

    daily_revenue = Order.completed.sum(&:total)
    total_cars_sold = Order.completed.count
    average_order_total = daily_revenue / total_cars_sold

    puts "daily revenue: #{daily_revenue.round(2)}"
    puts "total cars sold: #{total_cars_sold}"
    puts "average order total: #{average_order_total.round(2)}"
  end
end
