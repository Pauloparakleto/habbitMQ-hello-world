#!/usr/bin/env ruby
require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel
queue = channel.queue('hello')

channel.queue('durable_task', durable: true)

message = ARGV.empty? ? 'Hello World!' : ARGV.join('')

queue.publish(message, persistent: true)
puts "[x] Sent #{message}"

#channel.default_exchange.publish('Hello, is it me are you looking for?', routing_key: queue.name)
#puts " [x] Sent 'Hello World!'"

connection.close