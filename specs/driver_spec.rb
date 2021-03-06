require_relative 'spec_helper'

describe "Driver class" do

  describe "Driver instantiation" do
    before do
      @driver = RideShare::Driver.new(id: 1, name: "George", vin: "33133313331333133")
    end

    it "is an instance of Driver" do
      @driver.must_be_kind_of RideShare::Driver
    end

    it "throws an argument error with a bad ID value" do
      proc{ RideShare::Driver.new(id: 0, name: "George", vin: "33133313331333133")}.must_raise ArgumentError
    end

    it "throws an argument error with a bad VIN value" do
      proc{ RideShare::Driver.new(id: 100, name: "George", vin: "")}.must_raise ArgumentError
      proc{ RideShare::Driver.new(id: 100, name: "George", vin: "33133313331333133extranums")}.must_raise ArgumentError
    end

    it "sets trips to an empty array if not provided" do
      @driver.trips.must_be_kind_of Array
      @driver.trips.length.must_equal 0
    end

    it "is set up for specific attributes and data types" do
      [:id, :name, :vehicle_id, :status].each do |prop|
        @driver.must_respond_to prop
      end

      @driver.id.must_be_kind_of Integer
      @driver.name.must_be_kind_of String
      @driver.vehicle_id.must_be_kind_of String
      @driver.status.must_be_kind_of Symbol
    end
  end

  describe "add trip method" do
    before do
      pass = RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640")
      @driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678")
      @trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: pass, start_time: "2016-04-05T14:01:00+00:00", end_time: "2016-04-05T14:09:00+00:00", rating: 5})
    end

    it "throws an argument error if trip is not provided" do
      proc{ @driver.add_trip(1) }.must_raise ArgumentError
    end

    it "increases the trip count by one" do
      previous = @driver.trips.length
      @driver.add_trip(@trip)
      @driver.trips.length.must_equal previous + 1
    end
  end

  describe "average_rating method" do
    before do
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      trip = RideShare::Trip.new({id: 8, driver: @driver, passenger: nil, start_time: "2016-04-05T14:01:00+00:00", end_time: "2016-04-05T14:09:00+00:00", rating: 5})
      @driver.add_trip(trip)
    end

    it "returns a float" do
      @driver.average_rating.must_be_kind_of Float
    end

    it "returns a float within range of 1.0 to 5.0" do
      average = @driver.average_rating
      average.must_be :>=, 1.0
      average.must_be :<=, 5.0
    end

    it "returns zero if no trips" do
      driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ")
      driver.average_rating.must_equal 0
    end
  end

  describe "calculate_driver_revenue method" do
    it "returns the total revenue the driver earned on 80% of the total fare after the service fee" do

      trip_data_one = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: Time.parse('2015-05-20T12:14:00+00:00'),
        end_time: Time.parse('2015-05-20T12:24:00+00:00'),
        cost: 23.45,
        rating: 3,
      }

      trip_data_two = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: Time.parse('2015-05-20T12:14:00+00:00'),
        end_time: Time.parse('2015-05-20T12:24:00+00:00'),
        cost: 23.45,
        rating: 3,
      }

      trips = [
        RideShare::Trip.new(trip_data_one),
        RideShare::Trip.new(trip_data_two),
      ]
      driver_data = {
        id: 7,
        vin: 'a' * 17,
        name: 'test driver',
        trips: trips
      }
      driver = RideShare::Driver.new(driver_data)
      driver.calculate_driver_revenue.must_equal 34.88
    end
  end

  describe "calculate_driver_average_revenue method" do
    it "returns the average revenue the driver earned on all trips" do

      trip_data_one = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: Time.parse('2015-05-20T12:14:00+00:00'),
        end_time: Time.parse('2015-05-20T12:24:00+00:00'),
        cost: 23.45,
        rating: 3,
      }

      trip_data_two = {
        id: 8,
        driver: RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678"),
        passenger: RideShare::Passenger.new(id: 1, name: "Ada", phone: "412-432-7640"),
        start_time: Time.parse('2015-05-20T12:14:00+00:00'),
        end_time: Time.parse('2015-05-20T12:24:00+00:00'),
        cost: 23.45,
        rating: 3,
      }

      trips = [
        RideShare::Trip.new(trip_data_one),
        RideShare::Trip.new(trip_data_two),
      ]
      driver_data = {
        id: 7,
        vin: 'a' * 17,
        name: 'test driver',
        trips: trips
      }
      driver = RideShare::Driver.new(driver_data)
      driver.calculate_driver_average_revenue.must_equal 17.44

    end
  end

  # describe "change_driver_status" do
  #   it "toggles the driver's status" do
  #     driver_one = RideShare::Driver.new(id: 1, name: "George", vin: "33133313331333133", status: :AVAILABLE)
  #     driver_one.change_driver_status
  #     driver_one.status.must_equal :UNAVAILABLE
  #
  #     driver_two = RideShare::Driver.new(id: 2, name: "Gorges", vin: "11311131113111311", status: :UNAVAILABLE)
  #     driver_two.change_driver_status
  #     driver_two.status.must_equal :AVAILABLE
  #   end
  # end

end
