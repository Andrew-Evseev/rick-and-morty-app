class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String image;
  final String location;
  bool isFavorite;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image,
    required this.location,
    this.isFavorite = false,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      image: json['image'],
      location: json['location']['name'],
    );
  }

  Character copyWith({bool? isFavorite}) {
    return Character(
      id: id,
      name: name,
      status: status,
      species: species,
      image: image,
      location: location,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}