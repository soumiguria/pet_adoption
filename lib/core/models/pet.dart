class Pet {
  final String id;
  final String name;
  final String type;
  final int age;
  final double price;
  final String imageUrl;
  final bool isAdopted;
  final bool isFavorite;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.age,
    required this.price,
    required this.imageUrl,
    this.isAdopted = false,
    this.isFavorite = false,
  });

  Pet copyWith({
    String? id,
    String? name,
    String? type,
    int? age,
    double? price,
    String? imageUrl,
    bool? isAdopted,
    bool? isFavorite,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      age: age ?? this.age,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isAdopted: isAdopted ?? this.isAdopted,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      age: json['age'] as int,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      isAdopted: json['isAdopted'] ?? false,
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'age': age,
      'price': price,
      'imageUrl': imageUrl,
      'isAdopted': isAdopted,
      'isFavorite': isFavorite,
    };
  }
}
