# -*- encoding : utf-8 -*-
require 'active_support/time'
require 'nokogiri'
require 'net/http'

module SuperjobCalendar
  class BusinessDays

    def initialize(config_file = '')
      @config_file = config_file

      url ||= 'http://www.superjob.ru/proizvodstvennyj_kalendar/'
      @url = URI.parse(url)

      @month_names = {
        "Январь" => 1,
        "Февраль" => 2,
        "Март" => 3,
        "Апрель" => 4,
        "Май" => 5,
        "Июнь" => 6,
        "Июль" => 7,
        "Август" => 8,
        "Сентябрь" => 9,
        "Октябрь" => 10,
        "Ноябрь" => 11,
        "Декабрь" => 12
      }

    end

    def get_days
      if File.exists?(file_path)
        @config = YAML.load_file(file_path)
        if Date.parse(@config["business_time"]["holidays"].first).year != Date.today.year
          retrieve_days
          save_config
        end
      else
        retrieve_days
        save_config
      end
      @days
    end

    def retrieve_days
      begin
        @doc = Nokogiri::HTML((Net::HTTP.get(@url)))
        @days ||= parse_year(@doc)
      rescue StandardError => e
        puts e
        puts e.backtrace
      end
    end

    def parse_year(year)
      @days = {}
      current_year = year.css('div span.bigger').first.content.to_i
      year.css('td.pk_container').each do |month|
        current_month = month.css('div.pk_header').first.content
        month.css('div.pk_cells > div').each do |day|
          if day.attributes['class'].to_s != 'pk_other'
            day_type = case day.attributes['class'].to_s
            when "pk_holiday pie"
              "holiday"
            when "pk_preholiday pie"
              "short"
            else
              "work"
            end
            current_day = DateTime.new(current_year, @month_names[current_month], day.content.to_i).strftime("%Y-%m-%d")
            @days[current_day] = day_type
          end
        end
      end
      @days
    end

    private
    def decode(string)
      string.force_encoding('cp1251').encode('UTF-8')
    end

    def file_path
      @config_file ||= File.join(File.expand_path('../../config', __FILE__), 'calendar.yml')
    end

    def save_config
      File.open(file_path, 'w') {|f| f.write({ "business_time" => default_config.merge({
        "holidays" => @days.select{|k,v| v =~ /holiday/ }.map(&:first)
        })}.to_yaml) }
    end

    def default_config
      {
        "beginning_of_workday" => "8:00 am",
        "end_of_workday" => "5:00 pm",
        "work_week" => %w(mon tue wed thu fri),
        "work_hours" => {},
        "work_hours_total" => {},
        "_weekdays" => nil,
        "holidays" => [] 
      }
    end

    def load_config
      json = File.read(file_path)
      ActiveSupport::JSON.decode(json)
    end
  end
end
