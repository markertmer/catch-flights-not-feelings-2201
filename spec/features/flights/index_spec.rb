require 'rails_helper'

RSpec.describe "Flights Index:", type: :feature do
  before :each do
    @airline1 = Airline.create(name: "American")
    @airline2 = Airline.create(name: "Delta")
    @airline3 = Airline.create(name: "JetBlue")
    @airline4 = Airline.create(name: "Southwest")
    @airline5 = Airline.create(name: "United")

    @flight1 = @airline1.flights.create(number: "7990", date: "2/7/2022", departure_city: "Glendale", arrival_city: "Dallas")
    @flight2 = @airline2.flights.create(number: "3940", date: "3/10/2022", departure_city: "Detroit", arrival_city: "Orlando")
    @flight3 = @airline3.flights.create(number: "9091", date: "5/17/2022", departure_city: "Chicago", arrival_city: "Kansas City")
    @flight4 = @airline4.flights.create(number: "6798", date: "10/9/2022", departure_city: "Tulsa", arrival_city: "Fresno")
    @flight5 = @airline5.flights.create(number: "9665", date: "11/22/2022", departure_city: "Durham", arrival_city: "New Orleans")

    @passenger1 = Passenger.create(name: "Tina Belcher", age: 13)
    @passenger2 = Passenger.create(name: "Louise Belcher", age: 9)
    @passenger3 = Passenger.create(name: "Bob Belcher", age: 46)
    @passenger4 = Passenger.create(name: "Linda Belcher", age: 44)
    @passenger5 = Passenger.create(name: "Big Bob", age: 84)

    FlightPassenger.create(flight_id: @flight1.id, passenger_id: @passenger1.id)
    FlightPassenger.create(flight_id: @flight1.id, passenger_id: @passenger2.id)
    FlightPassenger.create(flight_id: @flight1.id, passenger_id: @passenger3.id)
    FlightPassenger.create(flight_id: @flight2.id, passenger_id: @passenger4.id)
    FlightPassenger.create(flight_id: @flight2.id, passenger_id: @passenger5.id)
    FlightPassenger.create(flight_id: @flight3.id, passenger_id: @passenger5.id)
    FlightPassenger.create(flight_id: @flight4.id, passenger_id: @passenger5.id)
  end

  it 'lists each flight number' do
    visit("/flights")
    expect(page).to have_content(@flight1.number)
    expect(page).to have_content(@flight2.number)
    expect(page).to have_content(@flight3.number)
    expect(page).to have_content(@flight4.number)
    expect(page).to have_content(@flight5.number)
  end

  it 'lists each flights airline' do
    visit("/flights")

    within("#flight-#{@flight1.id}") do
      expect(page).to have_content(@flight1.airline.name)
    end

    within("#flight-#{@flight2.id}") do
      expect(page).to have_content(@flight2.airline.name)
    end

    within("#flight-#{@flight3.id}") do
      expect(page).to have_content(@flight3.airline.name)
    end

    within("#flight-#{@flight4.id}") do
      expect(page).to have_content(@flight4.airline.name)
    end

    within("#flight-#{@flight5.id}") do
      expect(page).to have_content(@flight5.airline.name)
    end
  end

  it 'lists each flights passengers' do
    visit("/flights")

    within("#flight-#{@flight1.id}") do
      expect(page).to have_content(@passenger1.name)
      expect(page).to have_content(@passenger2.name)
      expect(page).to have_content(@passenger3.name)
      expect(page).to_not have_content(@passenger4.name)
      expect(page).to_not have_content(@passenger5.name)
    end

    within("#flight-#{@flight2.id}") do
      expect(page).to_not have_content(@passenger1.name)
      expect(page).to_not have_content(@passenger2.name)
      expect(page).to_not have_content(@passenger3.name)
      expect(page).to have_content(@passenger4.name)
      expect(page).to have_content(@passenger5.name)
    end

    within("#flight-#{@flight3.id}") do
      expect(page).to_not have_content(@passenger1.name)
      expect(page).to_not have_content(@passenger2.name)
      expect(page).to_not have_content(@passenger3.name)
      expect(page).to_not have_content(@passenger4.name)
      expect(page).to have_content(@passenger5.name)
    end

    within("#flight-#{@flight4.id}") do
      expect(page).to_not have_content(@passenger1.name)
      expect(page).to_not have_content(@passenger2.name)
      expect(page).to_not have_content(@passenger3.name)
      expect(page).to_not have_content(@passenger4.name)
      expect(page).to have_content(@passenger5.name)
    end

    within("#flight-#{@flight5.id}") do
      expect(page).to_not have_content(@passenger1.name)
      expect(page).to_not have_content(@passenger2.name)
      expect(page).to_not have_content(@passenger3.name)
      expect(page).to_not have_content(@passenger4.name)
      expect(page).to_not have_content(@passenger5.name)
    end
  end

  it 'removes a passenger from the flight' do
    visit("/flights")
save_and_open_page
    within("#flight-#{@flight1.id}") do
      within("#passenger-#{@passenger1.id}")do
        click_button("remove")
      end
    end

    expect(current_path).to eq("/flights")
    within("#flight-#{@flight1.id}") do
      expect(page).to_not have_content(@passenger1.name)
    end
  end
end
