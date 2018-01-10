require 'gmail'

if ARGV.count == 0
  puts "fill the option"
else
  opt = ARGV[0]

  if opt == "--delete-all"
    gmail = Gmail.new('uname', 'pass')

    gmail.inbox.emails(:all).each do |x|
      puts "remove message -> #" + x.uid.to_s
      x.delete!
    end
    gmail.logout
  else
    puts "option doesnt valid!"
  end
  
end
