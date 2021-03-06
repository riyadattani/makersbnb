require 'pg'
require './lib/database_connection.rb'

class Request

  attr_reader :title, :description, :price_per_night, :requester_id, :owner_id, :date, :space_id, :confirmation

  def initialize(title:, description:, price_per_night:, date:, requester_id:, owner_id:, space_id:, confirmation:)
    @title = title
    @description = description
    @price_per_night = price_per_night
    @date = date
    @requester_id = requester_id
    @owner_id = owner_id
    @space_id = space_id
    @confirmation = confirmation
  end

  def self.made(requester_id:)
    result = DatabaseConnection.query("SELECT title, description, price_per_night, requester_id, user_id, date, space_id, confirmation FROM bookings JOIN spaces ON bookings.space_id = spaces.id WHERE requester_id = '#{requester_id.to_i}'")
    result.map do |space|
      Request.new(
        title: space['title'],
        description: space['description'],
        price_per_night: space['price_per_night'],
        requester_id: space['requester_id'],
        owner_id: space['user_id'],
        date: space['date'],
        space_id: space['space_id'],
        confirmation: space['confirmation']
      )
    end
  end

  def self.received(owner_id:)
    result = DatabaseConnection.query("SELECT title, description, price_per_night, requester_id, user_id, date, space_id, confirmation FROM bookings JOIN spaces ON bookings.space_id = spaces.id WHERE user_id = '#{owner_id.to_i}'")
    result.map do |space|
      Request.new(
        title: space['title'],
        description: space['description'],
        price_per_night: space['price_per_night'],
        requester_id: space['requester_id'],
        owner_id: space['user_id'],
        date: space['date'],
        space_id: space['space_id'],
        confirmation: space['confirmation']
      )
    end
  end
end
