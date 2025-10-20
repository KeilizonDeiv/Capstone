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
    // Normalize all text fields to lowercase strings for comparison
    String normalize(dynamic value) =>
        (value ?? '').toString().trim().toLowerCase();

    final name = normalize(json["name"]);
    final sciName = normalize(json["scientific_name"]);
    final desc = normalize(json["description"]);

    // Check if detection failed or returned "N/A", "Unknown", etc.
    final isNotDetected = name.isEmpty ||
        sciName.isEmpty ||
        desc.isEmpty ||
        name == "n/a" ||
        sciName == "n/a" ||
        desc == "n/a" ||
        name == "unknown" ||
        sciName == "unknown" ||
        desc == "unknown";

    if (isNotDetected) {
      return PlantInfo(
        name: "We couldn't detect a valid herbal plant.",
        scientificName: "",
        description:
            "Please recapture and make sure to capture an image of a herbal plant.",
        uses: [],
        benefits: [],
        funFacts: [],
        whereToFind: "",
      );
    }

    // Normal valid result
    return PlantInfo(
      name: json["name"] ?? "",
      scientificName: json["scientific_name"] ?? "",
      description: json["description"] ?? "",
      uses: List<String>.from(json["uses"] ?? []),
      benefits: List<String>.from(json["benefits"] ?? []),
      funFacts: List<String>.from(json["fun_facts"] ?? []),
      whereToFind: json["where_to_find"] ?? "",
    );
  }


}
