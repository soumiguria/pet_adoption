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
    id: json['id']?.toString() ?? 'unknown_id', // Handle any type of ID
    name: json['name']?.toString() ?? 'Unnamed Pet', // Handle null name
    type: json['type']?.toString() ?? 'Unknown', // Handle null type
    age: (json['age'] as num?)?.toInt() ?? 0, // Handle null or non-int age
    price: (json['price'] as num?)?.toDouble() ?? 0.0, // Handle null price
    imageUrl: json['imageUrl']?.toString() ?? '', // Handle null image
    isAdopted: json['isAdopted'] as bool? ?? false,
    isFavorite: json['isFavorite'] as bool? ?? false,
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
