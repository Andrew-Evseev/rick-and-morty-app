import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/character.dart';
import 'services/api_service.dart';
import 'widgets/character_card.dart';
import 'screens/favorites_screen.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Rick and Morty',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: themeProvider.themeMode,
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final ApiService _apiService = ApiService();
  List<Character> _characters = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String _error = '';
  int _currentPage = 1;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  Future<void> _loadCharacters({bool loadMore = false}) async {
    try {
      if (loadMore) {
        setState(() {
          _isLoadingMore = true;
        });
      } else {
        setState(() {
          _isLoading = true;
          _error = '';
        });
      }
      
      final characters = await _apiService.getCharacters(_currentPage);
      
      setState(() {
        if (loadMore) {
          _characters.addAll(characters);
        } else {
          _characters = characters;
        }
        _hasMore = characters.isNotEmpty;
        _currentPage++;
        _isLoading = false;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Ошибка загрузки: $e';
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  void _toggleFavorite(int characterId) {
    setState(() {
      final index = _characters.indexWhere((c) => c.id == characterId);
      if (index != -1) {
        _characters[index] = _characters[index].copyWith(
          isFavorite: !_characters[index].isFavorite,
        );
      }
    });
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      final metrics = notification.metrics;
      if (metrics.extentAfter < 500 && !_isLoadingMore && _hasMore) {
        _loadCharacters(loadMore: true);
      }
    }
    return false;
  }

  final List<Widget> _screens = [];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    _screens.clear();
    _screens.addAll([
      // Главный экран
      Scaffold(
        appBar: AppBar(
          title: const Text('Rick and Morty Characters'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          actions: [
            // Кнопка переключения темы
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Выбор темы'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.light_mode),
                          title: const Text('Светлая тема'),
                          onTap: () {
                            themeProvider.setThemeMode(ThemeMode.light);
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.dark_mode),
                          title: const Text('Тёмная тема'),
                          onTap: () {
                            themeProvider.setThemeMode(ThemeMode.dark);
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.phone_android),
                          title: const Text('Как в системе'),
                          onTap: () {
                            themeProvider.setThemeMode(ThemeMode.system);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              icon: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
            ),
          ],
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: _onScrollNotification,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error.isNotEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_error),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _loadCharacters(),
                            child: const Text('Попробовать снова'),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: _characters.length + (_isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == _characters.length) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              final character = _characters[index];
                              return CharacterCard(
                                character: character,
                                onToggleFavorite: () => _toggleFavorite(character.id),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _loadCharacters(),
          tooltip: 'Reload',
          child: const Icon(Icons.refresh),
        ),
      ),
      
      // Экран избранного
      FavoritesScreen(
        characters: _characters,
        onToggleFavorite: _toggleFavorite,
      ),
    ]);

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Персонажи',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Избранное',
          ),
        ],
      ),
    );
  }
}
