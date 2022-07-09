#!/usr/bin/env ruby
require 'bunny'

connection = Bunny.new
connection.start

channel = connection.create_channel
queue = channel.queue('hello')

# If a consumer dies (its channel is closed, connection is closed, or TCP connection is lost)
# without sending an ack, RabbitMQ will understand that a message wasn't processed fully and
# will re-queue it. If there are other consumers online at the same time, it will then quickly 
# redeliver it to another consumer. That way you can be sure that no message is lost, even if 
# the workers occasionally die.

begin
    puts ' [*] Waiting for messages. To exit press CTRL + C'
    # Message acknowledgments are turned off by default. It's time to turn them on using the :manual_ack option
    # and send a proper acknowledgment from the worker, once we're done with a task.
    queue.subscribe(manual_ack: true, block: true) do | delivery_info, _properties, body|
        puts " [X] received Lionel Reach says: '#{body}'"
        # imitate some work
        sleep body.count('.').to_i
        puts ' [x] Done'

        channel.ack(_delivery_info.delivery_tag)
    end
rescue Interrupt => _
    connection.close

    exit(0)
end