class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;
  final double windSpeed;
  final double humidity;
  final double feelsLike;
  final List<DailyWeather> dailyWeather;
  final List<HourlyWeather> hourlyWeather;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.windSpeed,
    required this.humidity,
    required this.feelsLike,
    required this.dailyWeather,
    required this.hourlyWeather,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    List<DailyWeather> dailyWeather = (json['forecast']['forecastday'] as List)
        .map((day) => DailyWeather.fromJson(day))
        .toList();
    List<HourlyWeather> hourlyWeather =
        (json['forecast']['forecastday'][0]['hour'] as List)
            .map((hour) => HourlyWeather.fromJson(hour))
            .toList();

    return Weather(
      cityName: json['location']['name'],
      temperature: (json['current']['temp_c'] as num).toDouble(),
      description: json['current']['condition']['text'],
      icon: 'https:${json['current']['condition']['icon']}',
      windSpeed: (json['current']['wind_kph'] as num).toDouble(),
      humidity: (json['current']['humidity'] as num).toDouble(),
      feelsLike: (json['current']['feelslike_c'] as num).toDouble(),
      dailyWeather: dailyWeather,
      hourlyWeather: hourlyWeather,
    );
  }
}

class DailyWeather {
  final String date;
  final double maxTemp;
  final double minTemp;
  final String icon;

  DailyWeather({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.icon,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    return DailyWeather(
      date: json['date'],
      maxTemp: (json['day']['maxtemp_c'] as num).toDouble(),
      minTemp: (json['day']['mintemp_c'] as num).toDouble(),
      icon: 'https:${json['day']['condition']['icon']}',
    );
  }
}

class HourlyWeather {
  final String time;
  final double temperature;
  final String icon;

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.icon,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(
      time: json['time'],
      temperature: (json['temp_c'] as num).toDouble(),
      icon: 'https:${json['condition']['icon']}',
    );
  }
}
