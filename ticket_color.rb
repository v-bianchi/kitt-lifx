require 'blink1'
require 'yaml'
require 'rest-client'
require 'json'

CONFIG = YAML.load_file(File.join(File.expand_path(File.dirname(__FILE__)), "config.yml"))

COLORS = {
  green:  [  20, 180, 90 ],
  orange: [ 230, 220,  120 ],
  red:    [ 255,   0,   0 ]
}

def off
  Blink1.open &:off
  puts "Bye"
end

def batch_color
  url = "#{CONFIG[:base_url]}/api/v1/camps/#{CONFIG[:batch_slug]}/color?waiting_duration_alarm=#{CONFIG[:waiting_duration_alarm]}"
  JSON.parse(RestClient.get(url))['color']
end

begin
  loop do
    color = batch_color
    Blink1.open do |blink1|
      puts "#{Time.now}: Showing #{color}"
      blink1.set_rgb *COLORS[color.to_sym]
    end
    sleep(5)
  end
rescue SystemExit, Interrupt
  off
end

at_exit do
  off
end
