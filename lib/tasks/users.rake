namespace :users do
  desc "Create a new user and send them a magic link login email"
  task :create, [ :email ] => :environment do |_t, args|
    email = args[:email]

    if email.blank?
      puts "Usage: rails users:create[email@example.com]"
      exit 1
    end

    user = User.find_by(email_address: email)

    if user
      puts "User with email #{email} already exists."
      print "Send them a new login link? (y/n): "
      response = $stdin.gets.chomp.downcase

      if response == "y"
        user.send_magic_link!
        puts "✓ Magic link sent to #{email}"
        print_magic_link(user)
      else
        puts "Aborted."
      end
    else
      user = User.create!(email_address: email)
      user.send_magic_link!
      puts "✓ User created: #{email}"
      puts "✓ Magic link sent to #{email}"
      print_magic_link(user)
    end
  end

  desc "List all users"
  task list: :environment do
    users = User.order(:created_at)

    if users.empty?
      puts "No users found."
    else
      puts "Users (#{users.count}):"
      puts "-" * 50
      users.each do |user|
        puts "#{user.id}: #{user.email_address} (created: #{user.created_at.strftime('%Y-%m-%d')})"
      end
    end
  end

  desc "Send a magic link to an existing user"
  task :send_magic_link, [ :email ] => :environment do |_t, args|
    email = args[:email]

    if email.blank?
      puts "Usage: rails users:send_magic_link[email@example.com]"
      exit 1
    end

    user = User.find_by(email_address: email)

    if user
      user.send_magic_link!
      puts "✓ Magic link sent to #{email}"
      print_magic_link(user)
    else
      puts "✗ No user found with email: #{email}"
      exit 1
    end
  end

  def print_magic_link(user)
    include Rails.application.routes.url_helpers
    default_url_options[:host] = ENV.fetch("HOST", "localhost:3000")
    url = magic_link_url(token: user.login_token)
    puts "\n🔗 Magic link (expires in 15 minutes):"
    puts url
  end
end
