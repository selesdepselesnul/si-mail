require 'gmail'
require 'highline'

class SiMail
  
   def initialize(email, password)
    @email = email
    @password = password
   end

   def delete!(flag)
     gmail = Gmail.new(@email, @password)
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
   
end


if ARGV.count == 0
  puts "fill email"
else
  begin    
      cli = HighLine.new

      email = ARGV[0]
      password = cli.ask("Enter your password:  ") { |q| q.echo = "*" }

      simail = SiMail.new(email, password)

      opt = ARGV[1]

      case
      when opt == "--delete-all"
        simail.delete!(:all)
      when opt == "--delete-read"
        simail.delete!(:read)
      else
        puts "option doesnt valid!"
      end
  rescue Exception => e
    puts "Error running script: " + e.message
  end  
end


