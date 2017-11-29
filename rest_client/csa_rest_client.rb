# A simple REST client for the CSA application. Note that this
# example will only support the user accounts feature. Clearly
# the passwords should not be sent in plain text, but rather HTTPS used.
# Also the password info should go in a config file and accessed as ebvironment
# variables.
# @author Chris Loftus
require 'rest-client'
require 'json'
require 'base64'
require 'io/console'
class CSARestClient

  #@@DOMAIN = 'https://csa-web-service-cloftus.c9users.io'
  @@DOMAIN = 'http://localhost:3000'

  def run_menu
    loop do
      display_menu
      option = STDIN.gets.chomp.upcase
      case option
        when '1'
          puts 'Displaying users:'
          display_users
        when '2'
          puts 'Displaying user:'
          display_user
        when '3'
          puts 'Creating user:'
          create_user
        when '4'
          puts 'Updating user:'
          update_user
        when '5'
          puts 'Deleting user:'
          delete_user
        when 'Q'
          break
        else
          puts "Option #{option} is unknown."
      end
    end
  end

  private

  def display_menu
    puts 'Enter option: '
    puts '1. Display users'
    puts '2. Display user by ID'
    puts '3. Create new user'
    puts '4. Update user by ID'
    puts '5. Delete user by ID'
    puts 'Q. Quit'
  end

  def display_users
    begin
      response = RestClient.get "#{@@DOMAIN}/api/users.json?all", authorization_hash

      puts "Response code: #{response.code}"
      puts "Response cookies:\n #{response.cookies}\n\n"
      puts "Response headers:\n #{response.headers}\n\n"
      puts "Response content:\n #{response.to_str}"

      js = JSON response.body
      js.each do |item_hash|
        item_hash.each do |k, v|
          puts "#{k}: #{v}"
        end
      end
    rescue => e
      puts STDERR, "Error accessing REST service. Error: #{e}"
    end
  end

  def display_user
    begin
      print "Enter the user ID: "
      id = STDIN.gets.chomp
      response = RestClient.get "#{@@DOMAIN}/api/users/#{id}.json", authorization_hash

      js = JSON response.body
      js.each do |k, v|
        puts "#{k}: #{v}"
      end
    rescue => e
      puts STDERR, "Error accessing REST service. Error: #{e}"
    end
  end

  def create_user
    begin
      print "Surname: "
      surname = STDIN.gets.chomp
      print "Firstname: "
      first_name = STDIN.gets.chomp
      print "Phone: "
      phone = STDIN.gets.chomp
      print "graduating year: "
      grad_year = STDIN.gets.chomp
      print "Require job information? (y/n): "
      jobs = STDIN.gets.chomp.upcase == 'Y' ? '1' : '0'
      print "Email: "
      email = STDIN.gets.chomp
      print "Filename path: "
      filename = STDIN.gets.chomp
      print "Login: "
      login = STDIN.gets.chomp
      print "Password: "
      password = STDIN.noecho(&:gets).chomp
      print "\nPassword confirmation: "
      password_confirmation = STDIN.noecho(&:gets).chomp


      # Rails will reject this unless you configure the cross_forgery_request check to
      # a null_session in the receiving controller. This is because we are not sending
      # an authenticity token. Rails by default will only send the token with forms /users/new and
      # /users/1/edit and REST clients don't get those.
      # We could perhaps arrange to send this on a previous
      # request but we would then have to have an initial call (a kind of login perhaps).
      # This will automatically send as a multi-part request because we are adding a
      # File object.
      response = RestClient.post "#{@@DOMAIN}/api/users.json",

                                 {
                                     user: {
                                         surname: surname,
                                         firstname: first_name,
                                         phone: phone,
                                         grad_year: grad_year,
                                         jobs: jobs,
                                         email: email
                                     },
                                     user_detail: {
                                         login: login,
                                         password: password,
                                         password_confirmation: password_confirmation
                                     },
                                     image_file: File.new(filename, 'r')
                                 }, authorization_hash

      if (response.code == 201)
        puts "Created successfully"
      end
      puts "URL for new resource: #{response.headers[:location]}"
    rescue => e
      puts STDERR, "Error accessing REST service. Error: #{e}"
    end
  end

  def update_user
    begin
      print "Enter the user ID: "
      id = STDIN.gets.chomp
      response = RestClient.get "#{@@DOMAIN}/api/users/#{id}.json"

      # Extract each element and ask the user if they'd like to change it
      js = JSON response.body

      result = {}
      puts 'Hit return to keep value the same or else type new value:'
      js.each do |k, v|
        unless k == 'id' || k == 'updated_at' || k == 'created_at'
          print "#{k}[#{v}]: "
          res = STDIN.gets.chomp
          result[k] = res.length > 0 ? res : v
        end
      end

      response = RestClient.put "#{@@DOMAIN}/api/users/#{id}.json",
                                {user: result}, authorization_hash

      if (response.code == 201)
        puts "Update successfully"
      end
    rescue => e
      puts STDERR, "Error accessing REST service. Error: #{e}\n"
    end

  end

  def delete_user
    begin
      print "Enter the user ID: "
      id = STDIN.gets.chomp
      response = RestClient.delete "#{@@DOMAIN}/api/users/#{id}.json", authorization_hash

      if (response.code == 204)
        puts "Deleted successfully"
      end
    rescue => e
      puts STDERR, "Error accessing REST service. Error: #{e}\n"
    end
  end

  def authorization_hash
    {Authorization: "Basic #{Base64.strict_encode64('admin:taliesin')}"}
  end


end

client = CSARestClient.new
client.run_menu
