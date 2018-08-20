# # # USAGE: PUBSUB_EMULATOR_HOST=pubsub_emulator:8085 ruby pubsub.rb

require "google/cloud/pubsub"

pubsub = Google::Cloud::Pubsub.new(
  project_id: "foo",
  # credentials: "/path/to/keyfile.json"
  emulator_host: ENV['PUBSUB_EMULATOR_HOST']
)

puts "Connecting to emulator at #{ENV['PUBSUB_EMULATOR_HOST']}"

# puts 'Creating a topic...'
# topic = pubsub.create_topic "test-topic"

puts 'Retrieving topic...'
# Retrieve a topic
topic = pubsub.topic "test-topic"

# puts 'Publishing message...'
# # Publish a new message
# msg = topic.publish "new-message"

# puts 'Retrieving subscription...'
# # Retrieve a subscription
# sub = topic.subscribe "test-topic-sub"

puts 'Retrieving subscription...'
# Retrieve a subscription
sub = topic.subscription("test-topic-sub")


puts "SUBSCRIPTION: #{sub}"


puts 'Listening for message...'
# Create a subscriber to listen for available messages
subscriber = sub.listen do |received_message|
  # process message
  puts received_message
  received_message.acknowledge!
end

# Start background threads that will call the block passed to listen.
puts 'Starting....'
subscriber.start

# Shut down the subscriber when ready to stop receiving messages.
# subscriber.stop.wait!

puts 'Publishing message...'
# Publish a new message
msg = topic.publish "new-message"

sleep 300
