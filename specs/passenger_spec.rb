require_relative 'spec_helper'

describe "Passenger class" do

  describe "Passenger instantiation" do
    before do
      @passenger = RideShare::Passenger.new({id: 1, name: "Smithy", phone: "353-533-5334"})
    end

    it "is an instance of Passenger" do
      @passenger.must_be_kind_of RideShare::Passenger
    end

    it "throws an argument error with a bad ID value" do
      proc{ RideShare::Passenger.new(id: 0, name: "Smithy")}.must_raise ArgumentError
    end

    it "sets trips to an empty array if not provided" do
      @passenger.trips.must_be_kind_of Array
      @passenger.trips.length.must_equal 0
    end

    it "is set up for specific attributes and data types" do
      [:id, :name, :phone_number, :trips].each do |prop|
        @passenger.must_respond_to prop
      end

      @passenger.id.must_be_kind_of Integer
      @passenger.name.must_be_kind_of String
      @passenger.phone_number.must_be_kind_of String
      @passenger.trips.must_be_kind_of Array
    end
  end


  describe "trips property" do
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723", trips: [])
      trip = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, start_time: "2016-04-05T14:01:00+00:00", end_time: "2016-04-05T14:09:00+00:00", rating: 5})

      @passenger.add_trip(trip)
    end

    it "each item in array is a Trip instance" do
      @passenger.trips.each do |trip|
        trip.must_be_kind_of RideShare::Trip
      end
    end

    it "all Trips must have the same Passenger id" do
      @passenger.trips.each do |trip|
        trip.passenger.id.must_equal 9
      end
    end
  end

  describe "get_drivers method" do
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723")
      driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
      trip = RideShare::Trip.new({id: 8, driver: driver, passenger: @passenger, start_time: "2016-04-05T14:01:00+00:00", end_time: "2016-04-05T14:09:00+00:00", rating: 5})

      @passenger.add_trip(trip)
    end

    it "returns an array" do
      drivers = @passenger.get_drivers
      drivers.must_be_kind_of Array
      drivers.length.must_equal 1
    end

    it "all items in array are Driver instances" do
      @passenger.get_drivers.each do |driver|
        driver.must_be_kind_of RideShare::Driver
      end
    end
  end

  describe "#calculate_total_revenue" do
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723", trips: [])
      trip_one = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, start_time: "2016-04-05T14:01:00+00:00", end_time: "2016-04-05T14:09:00+00:00", cost: 5.75, rating: 5})
      trip_two = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, start_time: "2016-04-05T14:01:00+00:00", end_time: "2016-04-05T14:09:00+00:00", cost: 10.00, rating: 5})

      @passenger.add_trip(trip_one)
      @passenger.add_trip(trip_two)
    end

    it "returns the total amount of money a passenger has spent on all trips" do
      @passenger.calculate_total_revenue.must_equal 15.75
    end

    it "returns the total amount of money as a float" do
      @passenger.calculate_total_revenue.must_be_instance_of Float
    end
  end

  describe "#calculate_total_time" do
    before do
      @passenger = RideShare::Passenger.new(id: 9, name: "Merl Glover III", phone: "1-602-620-2330 x3723", trips: [])
      trip_one = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, start_time: Time.parse("2016-04-05T14:01:00+00:00"), end_time: Time.parse("2016-04-05T14:09:00+00:00"), cost: 5.75, rating: 5})
      trip_two = RideShare::Trip.new({id: 8, driver: nil, passenger: @passenger, start_time: Time.parse("2016-04-05T16:01:00+00:00"), end_time: Time.parse("2016-04-05T16:09:00+00:00"), cost: 10.00, rating: 5})

      @passenger.add_trip(trip_one)
      @passenger.add_trip(trip_two)
    end

    it "returns the total amount of time a passenger has spent on their trips in minutes" do
      @passenger.calculate_total_time.must_equal 16
    end

    it "returns the time in minutes as a float" do
      @passenger.calculate_total_time.must_be_instance_of Float
    end
  end
end
