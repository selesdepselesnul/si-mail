require 'gmail'
require 'highline'

if ARGV.count == 0
  puts "fill email"
else

  cli = HighLine.new
  password = cli.ask("Enter your password:  ") { |q| q.echo = "x" }
  email = ARGV[0]
  opt = ARGV[1]

  if opt == "--delete-all"
    gmail = Gmail.new(email, password)

    gmail.inbox.emails(:all).each do |x|
      puts "remove message -> #" + x.uid.to_s
      x.delete!
    end
    gmail.logout
  else
    puts "option doesnt valid!"
  end
  
end
