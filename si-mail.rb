require 'gmail'
require 'highline'

def delete_message(email, password, flag)
  gmail = Gmail.new(email, password)
  emails = gmail.inbox.emails(flag)

  if emails.length == 0
    puts "nothing to be delete"
  else
    emails.each do |x|
      puts "remove message -> " + x.inspect.to_s
      x.delete!
    end
  end
  
  gmail.logout
end

if ARGV.count == 0
  puts "fill email"
else
  begin    
      cli = HighLine.new

      email = ARGV[0]
      password = cli.ask("Enter your password:  ") { |q| q.echo = "*" }

      opt = ARGV[1]

      if opt == "--delete-all"
        delete_message(email, password, :all)
      elsif opt == "--delete-read"
        delete_message(email, password, :read)
      else
        puts "option doesnt valid!"
      end
  rescue Exception => e
    puts "Error running script: " + e.message
  end  
end


