require "superjob_calendar/version"
require "superjob_calendar/business_days"
require "business_time"

module SuperjobCalendar
  # Initialize business time holidays
  config_file = File.join(File.expand_path('../config', __FILE__), 'calendar.yml')

  unless File.exists?(config_file)
    BusinessDays.new(config_file).get_days
  end

  BusinessTime::Config.load(config_file)

  # holidays = ActiveSupport::JSON.decode(File.read())

  # if holidays.empty? || Date.parse(holidays.first.first).year != Date.today.year
  #   calendar = SuperjobCalendar::BusinessDays.new
  #   holidays = calendar.get_days
  #   calendar.save_json
  # end

  # holidays.each do |record|
  #   BusinessTime::Config.holidays << Date.parse(record.first) if record.last =='holiday'
  # end
end
