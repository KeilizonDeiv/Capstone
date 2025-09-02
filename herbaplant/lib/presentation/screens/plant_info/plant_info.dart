class PlantInfo {
  final String name;
  final String scientificName;
  final String description;
  final List<String> uses;
  final List<String> benefits;
  final List<String> funFacts;
  final String whereToFind;

  PlantInfo({
    required this.name,
    required this.scientificName,
    required this.description,
    required this.uses,
    required this.benefits,
    required this.funFacts,
    required this.whereToFind,
  });

  factory PlantInfo.fromJson(Map<String, dynamic> json) {
    return PlantInfo(
      name: json["name"] ?? "Unknown",
      scientificName: json["scientific_name"] ?? "N/A",
      description: json["description"] ?? "",
      uses: List<String>.from(json["uses"] ?? []),
      benefits: List<String>.from(json["benefits"] ?? []),
      funFacts: List<String>.from(json["fun_facts"] ?? []),
      whereToFind: json["where_to_find"] ?? "",
    );
  }
}
