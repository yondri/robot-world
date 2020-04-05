require 'rails_helper'

RSpec.describe Car, type: :model do
  let(:car) { create(:car) }

  it "is valid with valid attributes" do
    expect(car).to be_valid
  end

  it "is not valid without a year" do
    car.year = nil
    expect(car).to_not be_valid
  end

  it "is not valid without a model" do
    car.car_model = nil
    expect(car).to_not be_valid
  end
end
