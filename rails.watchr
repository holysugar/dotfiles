# vim: ft=ruby fileencoding=utf-8

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

def notify_screen_rspec(result = nil, message = '')
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
# RSpec
# --------------------------------------------------
def all_spec_files
  Dir['spec/**/*_spec.rb']
end

def run_spec_matching(thing_to_match)
  matches = all_spec_files.grep(/#{thing_to_match}/i)
  if matches.empty?
    puts "Sorry, thanks for playing, but there were no matches for #{thing_to_match}"
  else
    run_spec matches.join(' ')
  end
end

def run_spec(files_to_run)
  notify_spec_starting("Running: #{files_to_run}")

  option = "-X -cfs"
  #option += ' --fail-fast'
  result = system("rspec #{option} #{files_to_run}")
  output = ''
  #output = `bundle exec rspec #{option} #{files_to_run}`
  #result = $?
  no_int_for_you

  notify_spec_result(result, output)
end

def run_all_specs
  run_spec(all_spec_files.join(' '))
end

def notify_spec_starting(message)
  puts message
  notify_screen_rspec(nil, message)
end

def notify_spec_result(result, output = '')
  puts output
  puts "$?: #{$?} #{result}"
  notify_screen_rspec(result)
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
watch('^spec/(.*)_spec\.rb')    { |m| run_spec_matching(m[1]) }
watch('^app/(.*)\.rb')          { |m| run_spec_matching(m[1]) }
watch('^app/(.*\.haml)')        { |m| run_spec_matching(m[1]) }
watch('^app/(.*\.slim)')        { |m| run_spec_matching(m[1]) }
watch('^lib/(.*)\.rb')          { |m| run_spec_matching(m[1]) }
watch('^spec/spec_helper\.rb')  { run_all_specs }
watch('^spec/support/.*\.rb')   { run_all_specs }
#
watch('Gemfile') { run_bundle }

# --------------------------------------------------
# Signal Handling
# --------------------------------------------------

def no_int_for_you
  @sent_an_int = nil
end

Signal.trap 'INT' do
  if @sent_an_int then
    puts "   A second INT?  Ok, I get the message.  Shutting down now."
    clear_screen
    exit
  else
    puts "   Did you just send me an INT? Ugh.  I'll quit for real if you do it again."
    @sent_an_int = true
    Kernel.sleep 1.5
    run_all_specs
  end
end

