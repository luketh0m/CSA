# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
# Taken from Kieran Dunbar's assignment solution 2016-17
class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'notifications'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    puts "Notification channel test data: #{data}"
  end
end
