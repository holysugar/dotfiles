# vim: ft=ruby fileencoding=utf-8

# observr for rails with screen

$rubocop_enabled = system("which rubocop > /dev/null")
# --------------------------------------------------
# Notifier to screen
# --------------------------------------------------
def hardstatus
  status = open("#{ENV['HOME']}/.screenrc"){|f| f.grep(/^hardstatus/)[-1] } || ""
  status.chomp.rstrip
end

def screencolor(color)
  c = {
    :black => 'k',
    :red => 'r',
    :green => 'g',
    :yellow => 'y',
    :blue => 'b',
    :cyan => 'c',
    :magenta => 'm',
    :white => 'w',
    :none => '.',
  }
  c.default = 'd'
  c[color]
end

def notify_screen(message, foreground = :none, background = :none)
  str = "%{=b #{screencolor background}#{screencolor foreground}} #{message} %{-}"
  command = hardstatus.sub(/"\s*$/){|s| %< #{str}"> }
  system %|screen -X eval '#{command}'|
end

def clear_screen
  system %|screen -X eval '#{hardstatus}'|
end

def notify_screen_result(result, message)
  succeeded = case result
              when 0, true
                true
              else
                false
              end
  notify_screen(message, :white, succeeded ? :green : :red)
end

def notify_screen_test(result = nil, message = '')
  case result
  when nil
    notify_screen(message[0..80], :default, :default)
  when 0, true
    notify_screen("    GREEN    ", :white, :green)
  else
    notify_screen("     RED     ", :white, :red)
  end
end

# --------------------------------------------------
# Minitest
# --------------------------------------------------
def all_test_files
  Dir['test/**/*_test.rb']
end

def run_test_matching(thing_to_match)
  matches = all_test_files.grep(/#{thing_to_match}/i)
  if matches.empty?
    puts "Sorry, thanks for playing, but there were no matches for #{thing_to_match}"
  else
    run_test matches.join(' ')
  end
end

def run_test(files_to_run = nil)
  pre = FileTest.exist?(".env") ? "dotenv" : ""

  if $rubocop_enabled
    command = "rubocop #{files_to_run}"
    notify_test_starting("Running: #{command}")
    system(command)
  end

  command = "#{pre} bin/rails test #{files_to_run}"
  notify_test_starting("Running: #{command}")
  result = system(command)
  output = ''

  notify_test_result(result, output)
end

def run_all_tests
  run_test
end

def notify_test_starting(message)
  puts message
  notify_screen_test(nil, message)
end

def notify_test_result(result, output = '')
  puts output
  puts "$?: #{$?} #{result}"
  notify_screen_test(result)
end


# --------------------------------------------------
# Other Rails
# --------------------------------------------------
def run_bundle
  notify_screen("bundle install")
  result = system("bundle install")
  notify_screen_result(result, "done: bundle install")
end

# --------------------------------------------------
# Watchr Rules
# --------------------------------------------------
watch('^test/(.*)_test\.rb')    { |m| run_test_matching(m[1]) }
watch('^app/(.*)\.rb')          { |m| run_test_matching(m[1]) }
watch('^app/(.*\.haml)')        { |m| run_test_matching(m[1]) }
watch('^app/(.*\.slim)')        { |m| run_test_matching(m[1]) }
watch('^lib/(.*)\.rb')          { |m| run_test_matching(m[1]) }
watch('^test/test_helper\.rb')  { run_all_tests }
watch('^test/support/.*\.rb')   { run_all_tests }
#
watch('Gemfile') { run_bundle }

# --------------------------------------------------
# Signal Handling
# --------------------------------------------------

def no_int_for_you
  @sent_an_int = nil
end

@sent_an_int = Time.now

Signal.trap 'INT' do
  if Time.now - @sent_an_int < 2
    puts "   A second INT?  Ok, I get the message.  Shutting down now."
    clear_screen
    exit
  else
    puts "   Did you just send me an INT? Ugh.  I'll quit for real if you do it again."
    @sent_an_int = Time.now
    run_all_tests
  end
end

