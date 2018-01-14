require 'gmail'
require 'highline'

class SiMail
  
   def initialize(email, password)
    @email = email
    @password = password
    @gmail = Gmail.new(@email, @password)
   end

   def delete!(flag)
     
     emails = @gmail.inbox.emails(flag)

     if emails.length == 0
       puts "nothing to be delete"
     else
       emails.each do |x|
         puts "remove message -> " + x.inspect.to_s
         x.delete!
       end
     end
  
     @gmail.logout
   end

   def send_text!(emails, subject, message)

     emails.each { |x|
       @gmail.deliver do
         to x
         subject subject
         text_part do
           body message
         end
       end
     }

     @gmail.logout
   end

   def send_html!(emails, subject, message)

     emails.each { |x|
       @gmail.deliver do
         to x
         subject subject
         html_part do
           content_type 'text/html; charset=UTF-8'
           body message
         end
       end
     }

     @gmail.logout
   end

   def send_from_file!(filename)
     s_builder = StringIO.new
     IO.foreach(File.join(Dir.pwd, filename)) do |x|
         s_builder << x
     end
     yield(s_builder.string)
   end

   def send_text_from_file!(emails, subject, filename)
     send_from_file!(filename) {
       |x| send_text!(emails, subject, x)
     }
   end

   def send_html_from_file!(emails, subject, filename)
     send_from_file!(filename) {
       |x| send_html!(emails, subject, x)
     }
   end
   
end

def extract_emails(x)
  x.strip.split(",")
end

def send_email!(argv)
  if argv.count == 5
    emails = extract_emails(argv[2])
    yield(emails, argv[3], argv[4])
  else
    puts "argument too few"
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
      when opt == "--send-txt"
        send_email!(ARGV) { |emails, subject, message|
          simail.send_text!(emails, subject, message)
        }
      when opt == "--send-txt-from"
        send_email!(ARGV) { |emails, subject, message|
          simail.send_text_from_file!(emails, subject, message)
        }
      when opt == "--send-html"
        send_email!(ARGV) { |emails, subject, message|
          simail.send_html!(emails, subject, message)
        }
      when opt == "--send-html-from"
        send_email!(ARGV) { |emails, subject, message|
          simail.send_html_from_file!(emails, subject, message)
        }
      else
        puts "option doesnt valid!"
      end
  rescue Exception => e
    puts "Error running script: " + e.message
  end  
end

