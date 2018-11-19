require 'lifx_api'
require 'yaml'
require 'rest-client'
require 'json'

CONFIG = YAML.load_file(File.join(File.expand_path(File.dirname(__FILE__)), "config.yml"))
SECRET = YAML.load_file(File.join(File.expand_path(File.dirname(__FILE__)), "secret.yml"))

BRIGHTNESS = CONFIG[:brightness]
COLORS = {
  grey:   "white brightness:0.05",
  green:  "rgb:20,180,90 brightness:#{BRIGHTNESS}",
  orange: "rgb:230,220,120 brightness:#{BRIGHTNESS}",
  red:    "rgb:255,0 0 brightness:#{BRIGHTNESS}"
}

access_token = SECRET[:api_token]
LIFX_CLIENT = LifxApi.new access_token
lights = LIFX_CLIENT.list_lights
exit() if lights.count == 0
LIGHT_ID = SECRET[:light_id]

def off
  LIFX_CLIENT.set_state selector: "id:#{LIGHT_ID}", power: "off"
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
      puts "#{Time.now}: Showing #{color}"
      LIFX_CLIENT.set_state selector: "id:#{LIGHT_ID}", power: "on", color: COLORS[color.to_sym]
    rescue SocketError
      puts "It seems that you are not connected to the Internet"
    end
    sleep(5)
  end
rescue SystemExit, Interrupt
  off
end

at_exit do
  off
end
