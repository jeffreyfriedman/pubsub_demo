# [START pub_sub_enqueue]
require "google/cloud/pubsub"
class PubSubWorker
  PROJECT_ID = 'foo'.freeze
  TOPIC = 'test-topic'.freeze
  SUBSCRIPTION = 'my_subscription'.freeze

  def self.pubsub
    @pubsub ||= begin
      project_id = PROJECT_ID
      Google::Cloud::Pubsub.new(project_id: project_id, emulator_host: ENV['PUBSUB_EMULATOR_HOST'])
    end
  end

  def self.pubsub_topic
    @pubsub_topic ||= TOPIC
  end

  def self.pubsub_subscription
    @pubsub_subscription ||= SUBSCRIPTION
  end

  def self.enqueue(job)
    puts "[PubSubWorker] enqueue job #{job.inspect}"

    book = job.arguments.first

    topic = pubsub.topic(pubsub_topic)

    topic.publish(book.id.to_s)
  end
# [END pub_sub_enqueue]

  # [START pub_sub_worker]
  def self.run_worker!
    puts "Running worker..."

    topic = pubsub.topic(pubsub_topic)
    topic = pubsub.create_topic(TOPIC) if topic.nil?
    
    subscription = topic.subscription(pubsub_subscription)
    puts subscription

    subscriber = subscription.listen do |message|
      message.acknowledge!

      puts "Incoming request (#{message.data})"
    end

    # Start background threads that will call block passed to listen.
    subscriber.start

    # Fade into a deep sleep as worker will run indefinitely
    sleep
  end
  # [END pub_sub_worker]
end

PubSubWorker.run_worker!
