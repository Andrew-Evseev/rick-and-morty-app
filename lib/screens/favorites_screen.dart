import 'package:flutter/material.dart';
import '../models/character.dart';
import '../widgets/character_card.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Character> characters;
  final Function(int) onToggleFavorite;

  const FavoritesScreen({
    super.key,
    required this.characters,
    required this.onToggleFavorite,
  });

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String _sortBy = 'name';

  List<Character> get favoriteCharacters {
    List<Character> favorites = widget.characters.where((character) => character.isFavorite).toList();
    
    if (_sortBy == 'name') {
      favorites.sort((a, b) => a.name.compareTo(b.name));
    } else if (_sortBy == 'status') {
      favorites.sort((a, b) => a.status.compareTo(b.status));
    }
    
    return favorites;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранные персонажи'),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'name',
                child: Text('Сортировать по имени'),
              ),
              const PopupMenuItem(
                value: 'status', 
                child: Text('Сортировать по статусу'),
              ),
            ],
          ),
        ],
      ),
      body: favoriteCharacters.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Нет избранных персонажей',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Theme.of(context).cardColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.sort, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        _sortBy == 'name' ? 'Сортировка по имени' : 'Сортировка по статусу',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: favoriteCharacters.length,
                    itemBuilder: (context, index) {
                      final character = favoriteCharacters[index];
                      return CharacterCard(
                        character: character,
                        onToggleFavorite: () => widget.onToggleFavorite(character.id),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}