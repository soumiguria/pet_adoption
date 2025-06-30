import 'package:flutter/material.dart';
import '../../../core/models/pet.dart';

class PetListItem extends StatefulWidget {
  final Pet pet;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final bool isAdopted;
  final bool isFavorite;

  const PetListItem({
    Key? key,
    required this.pet,
    required this.onTap,
    required this.onFavorite,
    required this.isAdopted,
    required this.isFavorite,
  }) : super(key: key);

  @override
  State<PetListItem> createState() => _PetListItemState();
}

class _PetListItemState extends State<PetListItem>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.97);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final pet = widget.pet;
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeInOut,
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            height: 120,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Stack(
                  children: [
                    Hero(
                      tag: 'petImage_${pet.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          pet.imageUrl,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () {
                          widget.onFavorite();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 4),
                            ],
                          ),
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            widget.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                widget.isFavorite
                                    ? Colors.pinkAccent
                                    : Colors.grey,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            pet.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.deepPurple,
                            ),
                          ),
                          if (widget.isAdopted)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Adopted',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${pet.type} • ${pet.age} yrs',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.attach_money,
                            color: Colors.amber[700],
                            size: 20,
                          ),
                          Text(
                            pet.price.toStringAsFixed(0),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
