class Country {
  final String id;
  final String name;
  final String continent;
  final String flagUrl;
  final int goldMedals;
  final int silverMedals;
  final int bronzeMedals;
  final int totalMedals;
  final int rank;
  final int rankTotalMedals;

  Country({
    required this.id,
    required this.name,
    required this.continent,
    required this.flagUrl,
    required this.goldMedals,
    required this.silverMedals,
    required this.bronzeMedals,
    required this.totalMedals,
    required this.rank,
    required this.rankTotalMedals,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'],
      continent: json['continent'],
      flagUrl: json['flag_url'],
      goldMedals: json['gold_medals'],
      silverMedals: json['silver_medals'],
      bronzeMedals: json['bronze_medals'],
      totalMedals: json['total_medals'],
      rank: json['rank'],
      rankTotalMedals: json['rank_total_medals'],
    );
  }
}