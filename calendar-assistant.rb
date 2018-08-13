require 'google_calendar'
require 'json'
require 'yaml'

module CalendarAssistant
  CLIENT_ID_FILE = "client_id.json"
  CALENDAR_TOKENS_FILE = "calendar_tokens.yml"
  
  def self.token_for calendar_id
    calendar_tokens = File.exists?(CALENDAR_TOKENS_FILE) ?
                        YAML.load(File.read(CALENDAR_TOKENS_FILE)) :
                        Hash.new
    calendar_tokens[calendar_id]
  end

  def self.save_token_for calendar_id, refresh_token
    calendar_tokens[calendar_id] = refresh_token
    File.open(CALENDAR_TOKENS_FILE, "w") { |f| f.write calendar_tokens.to_yaml }
  end

  def self.calendar_for calendar_id, refresh_token=nil
    client_id = JSON.parse(File.read(CLIENT_ID_FILE))

    params = {
      :client_id     => client_id["installed"]["client_id"],
      :client_secret => client_id["installed"]["client_secret"],
      :calendar      => CALENDAR_ID,
      :redirect_url  => "urn:ietf:wg:oauth:2.0:oob",
    }
    params[:refresh_token] = refresh_token if refresh_token

    Google::Calendar.new params
  end
end
