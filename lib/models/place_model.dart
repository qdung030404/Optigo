class PlaceModel {
  final String description;
  final String placeId;
  final String mainText;
  final String secondaryText;

  PlaceModel({
    required this.description,
    required this.placeId,
    required this.mainText,
    required this.secondaryText,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      description: json['description'] ?? '',
      placeId: json['place_id'] ?? '',
      mainText: json['structured_formatting']?['main_text'] ?? '',
      secondaryText: json['structured_formatting']?['secondary_text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'place_id': placeId,
      'structured_formatting': {
        'main_text': mainText,
        'secondary_text': secondaryText,
      },
    };
  }
}
