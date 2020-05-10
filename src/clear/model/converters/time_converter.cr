require "./base"

class Clear::Model::Converter::TimeConverter
  def self.to_column(x) : Time?
    case x
    when Nil
      nil
    when Time
      x.to_local
    else
      time = x.to_s
      if time.ends_with?(">>")
        time = time.gsub(">>", "")
      end
      if !time.ends_with?("Z") && !time.includes?("+")
        Time::Format::RFC_3339.parse("#{time}Z")
      else
        Time::Format::RFC_3339.parse(time)
      end
    end
  end

  def self.to_db(x : Time?)
    case x
    when Nil
      nil
    else
      x.to_utc.to_s(Clear::Expression::DATABASE_DATE_TIME_FORMAT)
    end
  end
end

Clear::Model::Converter.add_converter("Time", Clear::Model::Converter::TimeConverter)
