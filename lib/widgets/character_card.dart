import 'package:flutter/material.dart';
import '../models/character.dart';

class CharacterCard extends StatefulWidget {
  final Character character;
  final VoidCallback onToggleFavorite;

  const CharacterCard({
    super.key,
    required this.character,
    required this.onToggleFavorite,
  });

  @override
  State<CharacterCard> createState() => _CharacterCardState();
}

class _CharacterCardState extends State<CharacterCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    // Стартовое состояние - звездочка ВИДНА всегда
    _animationController.value = widget.character.isFavorite ? 1.0 : 0.0;
  }

  @override
  void didUpdateWidget(CharacterCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.character.isFavorite != oldWidget.character.isFavorite) {
      if (widget.character.isFavorite) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение персонажа
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.character.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            
            // Информация о персонаже
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.character.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildStatusRow(),
                  Text('Species: ${widget.character.species}'),
                  Text('Location: ${widget.character.location}'),
                ],
              ),
            ),
            
            // Кнопка избранного - ПРОСТАЯ И РАБОЧАЯ ВЕРСИЯ
            IconButton(
              onPressed: () {
                widget.onToggleFavorite();
              },
              icon: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Icon(
                    _animationController.value > 0.5 ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 30,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow() {
    Color statusColor = Colors.grey;
    
    switch (widget.character.status.toLowerCase()) {
      case 'alive':
        statusColor = Colors.green;
        break;
      case 'dead':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }
    
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text('Status: ${widget.character.status}'),
      ],
    );
  }
}