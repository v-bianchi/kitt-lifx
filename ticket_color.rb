require 'blink1'
require 'yaml'
require 'rest-client'
require 'json'

CONFIG = YAML.load_file(File.join(File.expand_path(File.dirname(__FILE__)), "config.yml"))

COLORS = {
  grey:   [   30, 30,   30 ],
  green:  [  20, 180,   90 ],
  orange: [ 230, 220,  120 ],
  red:    [ 255,   0,    0 ]
}

def off
  Blink1.open &:off
  puts "Bye"
end

def batch_color
  query = "?waiting_duration_alarm=#{CONFIG[:waiting_duration_alarm]}"
  url = "#{CONFIG[:base_url]}/api/v1/camps/#{CONFIG[:batch_slug]}/color#{query}"
  JSON.parse(RestClient.get(url))['color']
end

begin
  loop do
    begin
      color = batch_color
      Blink1.open do |blink1|
        puts "#{Time.now}: Showing #{color}"
        blink1.set_rgb *COLORS[color.to_sym]
      end
    rescue SocketError
      puts "It seems that your not connected to the Internet"
    end
    sleep(5)
  end
rescue SystemExit, Interrupt
  off
end

at_exit do
  off
end
