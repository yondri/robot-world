require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:order) { create(:order) }

  it "is valid with valid attributes" do
    expect(order).to be_valid
  end

  it "is valid without car" do
  	order.car = nil
    expect(order).to be_valid
  end

  it "is not valid without total" do
    order.total = nil
    expect(order).to_not be_valid
  end

  it "is not valid without car_model" do
    order.car_model = nil
    expect(order).to_not be_valid
  end
end
