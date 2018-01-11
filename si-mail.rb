require 'gmail'
require 'highline'

if ARGV.count == 0
  puts "fill email"
else

  begin
    
      cli = HighLine.new
      password = cli.ask("Enter your password:  ") { |q| q.echo = "*" }
      email = ARGV[0]
      opt = ARGV[1]

      if opt == "--delete-all"
        gmail = Gmail.new(email, password)
        all_email = gmail.inbox.emails(:all)

        if all_email.length == 0
          puts "nothing to be delete"
        else
          all_email.each do |x|
            puts "remove message -> " + x.inspect.to_s
            x.delete!
          end
        end
        
        gmail.logout
      elsif opt == "--delete-read"
        gmail = Gmail.new(email, password)
        unread_email = gmail.inbox.emails(:read)
        unread_email.each do |x|
          puts "remove message -> " + x.inspect.to_s
          x.delete!
        end
      else
        puts "option doesnt valid!"
      end
  rescue Exception => e
    puts "Error running script: " + e.message
  end
  
end

