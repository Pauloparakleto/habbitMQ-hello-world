#!/usr/bin/env ruby
# https://www.rabbitmq.com/tutorials/tutorial-two-ruby.html
require 'bunny'

QUANTITY_OF_MESSAGES_TO_WORKER = 1 # This tells RabbitMQ not to give more than one message to a worker at a time.

connection = Bunny.new
connection.start

channel = connection.create_channel
queue = channel.queue('hello')

channel.queue('durable_task', durable: true)

channel.prefetch(QUANTITY_OF_MESSAGES_TO_WORKER)

message = ARGV.empty? ? 'Hello World!' : ARGV.join('')

queue.publish(message, persistent: true)
puts "[x] Sent #{message}"

#channel.default_exchange.publish('Hello, is it me are you looking for?', routing_key: queue.name)
#puts " [x] Sent 'Hello World!'"

connection.close