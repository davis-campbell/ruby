require 'jumpstart_auth'
require "bitly"

class MicroBlogger
  attr_reader :client

  def initialize
    puts "Initializing MicroBlogger"
    @client = JumpstartAuth.twitter
  end
  
  def run
    puts "Welcome to the JSL Twitter Client!"
    command = ''  
    while command[0] != 'q'
      printf 'enter command: '
      command = gets.chomp.split(' ')
      case command[0].downcase
        when 'q' then puts 'Goodbye!'
        when 't' then tweet(command[1..-1].join(' '))
        when 'dm' then dm(command[1], command[2..-1].join(' '))
        when 'f' then followers_list
        when 'sp' then spam_my_followers(command[1..-1].join(' '))
        when 'elt' then everyones_last_tweet
        when 's' then shorten(command[1])
        when 'turl' then tweet(command[1..-2].join(' ') + ' ' + shorten(command[-1]))
        else puts "Sorry, I don't know how to #{command}."
      end
    end
  end  

  def tweet(message)
    @client.update(message)
  end

  def dm(user, message)
    puts "Trying to send #{user} this message:"
    puts message
    screen_names = @client.followers.collect { |follower| @client.user(follower).screen_name }
    if screen_names.include?(user)
      message = "d @#{user} #{message}"
      tweet message
    else
      puts "Failed to send direct message. User #{user} not a follower."
    end
  end

  def followers_list
    screen_names = @client.followers.collect { |follower| @client.user(follower).screen_name }
    screen_names
  end

  def spam_my_followers(message)
    list = followers_list
    list.each { |user| dm(user, message) }
  end

  def everyones_last_tweet
    friends = @client.friends.map { |friend| @client.user(friend) }
    friends = friends.sort_by { |friend| friend.screen_name.downcase }
    friends.each do |friend|
      timestamp = friend.status.created_at
      last_tweet = friend.status.text
      puts "On #{timestamp.strftime("%A, %b %d")}, #{friend.screen_name} said..."
      puts last_tweet
    end
  end

  def shorten(url)
    Bitly.use_api_version_3
    bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
    puts "Shortening this URL: #{url}"  
    url = bitly.shorten(url).short_url
    puts "Shortened URL: #{url}"
    return url
  end
 
end

blogger = MicroBlogger.new
blogger.run
