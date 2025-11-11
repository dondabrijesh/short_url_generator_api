class Utils
  def initialize(timezone)
    @timezone = timezone
  end

  def parse_time(date_str)
    return if date_str.blank?
    @timezone.parse(date_str)&.utc
  rescue ArgumentError
    Rails.logger.error("[Utils] Something Went Wrong: #{@timezone}, #{date_str}")
    nil
  end

  def timezone_parser
    tz = case @timezone
    when nil, "", "Z", "UTC"
       ActiveSupport::TimeZone["UTC"]
    when /^([+-])\d{2}:\d{2}$/ # e.g. +05:30
       sign, hh, mm = @timezone[0], @timezone[1..2].to_i, @timezone[4..5].to_i
       offset = (hh * 60 + mm) * (sign == "-" ? -1 : 1)
       ActiveSupport::TimeZone[offset]
    else
       ActiveSupport::TimeZone[@timezone] || ActiveSupport::TimeZone["UTC"]
    end
    Rails.logger.error("[Utils] Timezone: #{tz}")
    tz
  end
end
