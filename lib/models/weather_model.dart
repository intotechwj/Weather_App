class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final String icon;
  final List<DailyWeather> dailyWeather;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.dailyWeather,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    List<DailyWeather> dailyWeather = (json['forecast']['forecastday'] as List)
        .map((day) => DailyWeather.fromJson(day))
        .toList();

    return Weather(
      cityName: json['location']['name'],
      temperature: json['current']['temp_c'],
      description: json['current']['condition']['text'],
      icon: 'https:${json['current']['condition']['icon']}',
      dailyWeather: dailyWeather,
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
      maxTemp: json['day']['maxtemp_c'],
      minTemp: json['day']['mintemp_c'],
      icon: 'https:${json['day']['condition']['icon']}',
    );
  }
}
