import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/pet_api_service.dart';
import '../../core/services/local_storage_service.dart';
import '../../core/models/pet.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart';
import 'bloc/home_state.dart';
import 'widgets/pet_list_item.dart';
import 'widgets/search_bar.dart';
import 'widgets/banner_slider.dart';
import '../../core/notifiers/adopted_pets_notifier.dart';
import '../../core/notifiers/theme_mode_notifier.dart';

final List<Pet> fallbackPets = [
  Pet(
    id: 'f1',
    name: 'Mochi',
    type: 'Cat',
    age: 2,
    price: 99.0,
    imageUrl:
        'https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg',
  ),
  Pet(
    id: 'f2',
    name: 'Bubbles',
    type: 'Dog',
    age: 1,
    price: 120.0,
    imageUrl:
        'https://images.pexels.com/photos/1108099/pexels-photo-1108099.jpeg',
  ),
  Pet(
    id: 'f3',
    name: 'Peanut',
    type: 'Dog',
    age: 3,
    price: 110.0,
    imageUrl:
        'https://www.usatoday.com/gcdn/presto/2020/03/17/USAT/c0eff9ec-e0e4-42db-b308-f748933229ee-XXX_ThinkstockPhotos-200460053-001.jpg?crop=1170,658,x292,y120&width=1170&height=658&format=pjpg&auto=webp',
  ),
  Pet(
    id: 'f4',
    name: 'Mimi',
    type: 'Cat',
    age: 4,
    price: 80.0,
    imageUrl:
        'https://t3.ftcdn.net/jpg/02/31/17/32/360_F_231173210_stzZNH7tblr3esfej44EpbKqAQfbkfsT.jpg',
  ),
];

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(petApiService: PetApiService())..add(LoadPets()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  String searchQuery = '';
  final LocalStorageService _localStorageService = LocalStorageService();
  List<String> favoriteIds = [];
  final ScrollController _scrollController = ScrollController();
  int _currentMax = 12;
  bool _isLoadingMore = false;

  // Animation controllers for navigation buttons
  late AnimationController _historyButtonController;
  late AnimationController _favoritesButtonController;
  late Animation<double> _historyButtonAnimation;
  late Animation<double> _favoritesButtonAnimation;

  @override
  void initState() {
    super.initState();
    _loadAdoptedAndFavorites();
    _scrollController.addListener(_onScroll);

    // Initialize animation controllers
    _historyButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _favoritesButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _historyButtonAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _historyButtonController,
        curve: Curves.easeInOut,
      ),
    );

    _favoritesButtonAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _favoritesButtonController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _historyButtonController.dispose();
    _favoritesButtonController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_isLoadingMore &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
      setState(() {
        _isLoadingMore = true;
        _currentMax += 10;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _isLoadingMore = false;
        });
      });
    }
  }

  Future<void> _loadAdoptedAndFavorites() async {
    final adopted = await _localStorageService.getAdoptedPets();
    final favorites = await _localStorageService.getFavoritePets();
    adoptedPetsNotifier.value = adopted.map((e) => e.id).toSet();
    setState(() {
      favoriteIds = favorites.map((e) => e.id).toList();
    });
  }

  void _onFavorite(Pet pet) async {
    final favorites = await _localStorageService.getFavoritePets();
    final isFav = favorites.any((p) => p.id == pet.id);
    List<Pet> updated;
    if (isFav) {
      updated = favorites.where((p) => p.id != pet.id).toList();
    } else {
      updated = [...favorites, pet];
    }
    await _localStorageService.saveFavoritePets(updated);
    _loadAdoptedAndFavorites();
  }

  void _navigateToHistory() async {
    _historyButtonController.forward().then((_) {
      _historyButtonController.reverse();
    });
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      Navigator.pushNamed(context, '/history');
    }
  }

  void _navigateToFavorites() async {
    _favoritesButtonController.forward().then((_) {
      _favoritesButtonController.reverse();
    });
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      Navigator.pushNamed(context, '/favorites');
    }
  }

  Future<void> _handleRefresh() async {
    await _loadAdoptedAndFavorites();
    setState(() {}); // Force rebuild after refresh
  }

  void _toggleThemeMode() {
    if (themeModeNotifier.value == ThemeMode.system) {
      themeModeNotifier.value = ThemeMode.light;
    } else if (themeModeNotifier.value == ThemeMode.light) {
      themeModeNotifier.value = ThemeMode.dark;
    } else {
      themeModeNotifier.value = ThemeMode.system;
    }
  }

  IconData _themeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      default:
        return Icons.brightness_auto;
    }
  }

  String _themeTooltip(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light Mode';
      case ThemeMode.dark:
        return 'Dark Mode';
      default:
        return 'System Default';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 700;
        final maxWidth = 900.0;
        final gridColumns = isWeb ? 3 : 1;
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar:
              isWeb
                  ? null // WebScaffold handles app bar
                  : AppBar(
                    title: const Text('Pet Adoption'),
                    backgroundColor: theme.appBarTheme.backgroundColor,
                    foregroundColor: theme.appBarTheme.foregroundColor,
                    elevation: theme.appBarTheme.elevation,
                    actions: [
                      AnimatedBuilder(
                        animation: _historyButtonAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _historyButtonAnimation.value,
                            child: IconButton(
                              icon: const Icon(Icons.history),
                              onPressed: _navigateToHistory,
                            ),
                          );
                        },
                      ),
                      AnimatedBuilder(
                        animation: _favoritesButtonAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _favoritesButtonAnimation.value,
                            child: IconButton(
                              icon: const Icon(Icons.favorite),
                              onPressed: _navigateToFavorites,
                            ),
                          );
                        },
                      ),
                      // Theme toggle button for mobile
                      IconButton(
                        icon: Icon(_themeIcon(themeModeNotifier.value)),
                        tooltip: _themeTooltip(themeModeNotifier.value),
                        onPressed: _toggleThemeMode,
                      ),
                    ],
                  ),
          body: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWeb ? maxWidth : double.infinity,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWeb ? 24 : 16,
                      vertical: 18,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? theme.scaffoldBackgroundColor
                                : const Color(0xFFF3EFFF),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.07),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: PetSearchBar(
                        onChanged: (query) {
                          setState(() => searchQuery = query);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWeb ? 24 : 8,
                      vertical: isWeb ? 16 : 4,
                    ),
                    child: SizedBox(
                      height: isWeb ? 200 : 180,
                      child: const BannerSlider(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(isWeb ? 32 : 24, 8, 0, 8),
                    child: Text(
                      'Available Pets',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: isWeb ? 26 : 22,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ValueListenableBuilder<Set<String>>(
                      valueListenable: adoptedPetsNotifier,
                      builder: (context, adoptedIds, _) {
                        return BlocBuilder<HomeBloc, HomeState>(
                          builder: (context, state) {
                            List<Pet> pets = [];
                            if (state is HomeLoaded) {
                              pets = state.filteredPets;
                            } else if (state is HomeError) {
                              pets = fallbackPets;
                            }
                            final filtered =
                                pets.where((pet) {
                                  final q = searchQuery.toLowerCase();
                                  return pet.name.toLowerCase().contains(q) ||
                                      pet.type.toLowerCase().contains(q) ||
                                      pet.age.toString().contains(q);
                                }).toList();
                            final displayPets = filtered.take(12).toList();
                            if (state is HomeLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (filtered.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.pets,
                                      size: 120,
                                      color: theme.colorScheme.secondary,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No pets found! Try another search.',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(color: Colors.deepPurple),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return RefreshIndicator(
                              onRefresh: _handleRefresh,
                              child:
                                  gridColumns > 1
                                      ? GridView.builder(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 8,
                                        ),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              mainAxisSpacing: 24,
                                              crossAxisSpacing: 24,
                                              childAspectRatio: 0.95,
                                            ),
                                        itemCount: displayPets.length,
                                        itemBuilder: (context, index) {
                                          final pet = displayPets[index];
                                          final isAdopted = adoptedIds.contains(
                                            pet.id,
                                          );
                                          final isFavorite = favoriteIds
                                              .contains(pet.id);
                                          return _WebPetCard(
                                            pet: pet,
                                            isAdopted: isAdopted,
                                            isFavorite: isFavorite,
                                            onTap: () async {
                                              final result =
                                                  await Navigator.pushNamed(
                                                    context,
                                                    '/details',
                                                    arguments: pet,
                                                  );
                                              if (result == true) {
                                                await _loadAdoptedAndFavorites();
                                                setState(
                                                  () {},
                                                ); // Immediate update
                                              }
                                            },
                                            onFavorite: () => _onFavorite(pet),
                                          );
                                        },
                                      )
                                      : ListView.builder(
                                        padding: const EdgeInsets.only(
                                          bottom: 24,
                                        ),
                                        itemCount: displayPets.length,
                                        itemBuilder: (context, index) {
                                          final pet = displayPets[index];
                                          final isAdopted = adoptedIds.contains(
                                            pet.id,
                                          );
                                          final isFavorite = favoriteIds
                                              .contains(pet.id);
                                          return PetListItem(
                                            pet: pet,
                                            isAdopted: isAdopted,
                                            isFavorite: isFavorite,
                                            onTap: () async {
                                              final result =
                                                  await Navigator.pushNamed(
                                                    context,
                                                    '/details',
                                                    arguments: pet,
                                                  );
                                              if (result == true) {
                                                await _loadAdoptedAndFavorites();
                                                setState(
                                                  () {},
                                                ); // Immediate update
                                              }
                                            },
                                            onFavorite: () => _onFavorite(pet),
                                          );
                                        },
                                      ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _WebNavButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _WebNavButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton.icon(
        style: TextButton.styleFrom(
          foregroundColor:
              selected ? Colors.deepPurple : theme.textTheme.titleMedium?.color,
          backgroundColor:
              selected ? Colors.deepPurple.withOpacity(0.08) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        onPressed: onTap,
        icon: Icon(icon, size: 20),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _WebPetCard extends StatefulWidget {
  final Pet pet;
  final bool isAdopted;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  const _WebPetCard({
    required this.pet,
    required this.isAdopted,
    required this.isFavorite,
    required this.onTap,
    required this.onFavorite,
  });
  @override
  State<_WebPetCard> createState() => _WebPetCardState();
}

class _WebPetCardState extends State<_WebPetCard> {
  bool _hovering = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow:
              _hovering
                  ? [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.13),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                  : [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.07),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          border: Border.all(
            color:
                _hovering
                    ? Colors.deepPurple.withOpacity(0.18)
                    : Colors.transparent,
            width: 2,
          ),
        ),
        margin: const EdgeInsets.all(2),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Hero(
                      tag: 'petImage_${widget.pet.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          widget.pet.imageUrl,
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: () {
                          widget.onFavorite();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 4),
                            ],
                          ),
                          padding: const EdgeInsets.all(7),
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
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        widget.pet.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.deepPurple,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.pet.type} • ${widget.pet.age} yrs',
                  style: const TextStyle(fontSize: 15, color: Colors.black54),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.attach_money,
                      color: Colors.amber[700],
                      size: 20,
                    ),
                    Text(
                      widget.pet.price.toStringAsFixed(0),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.amber,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
