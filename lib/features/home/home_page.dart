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

// Mimi uses a new image: https://images.pexels.com/photos/45205/kitty-cat-kitten-pet-45205.jpeg
// The search bar background now adapts to dark mode using Theme.of(context).

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

class _HomeViewState extends State<HomeView> {
  String searchQuery = '';
  final LocalStorageService _localStorageService = LocalStorageService();
  List<String> adoptedIds = [];
  List<String> favoriteIds = [];
  final ScrollController _scrollController = ScrollController();
  int _currentMax = 10;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadAdoptedAndFavorites();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
    setState(() {
      adoptedIds = adopted.map((e) => e.id).toList();
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Pet Adoption'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: theme.appBarTheme.elevation,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, '/history'),
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.pushNamed(context, '/favorites'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeBloc>().add(RefreshPets());
          await _loadAdoptedAndFavorites();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: BannerSlider(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 0, 8),
              child: Text(
                'Available Pets',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 1.1,
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  List<Pet> pets = [];
                  if (state is HomeLoaded) {
                    pets = state.filteredPets;
                  } else if (state is HomeError) {
                    pets = fallbackPets;
                  }
                  // Enhanced search: filter by name, type, or age
                  final filtered =
                      pets.where((pet) {
                        final q = searchQuery.toLowerCase();
                        return pet.name.toLowerCase().contains(q) ||
                            pet.type.toLowerCase().contains(q) ||
                            pet.age.toString().contains(q);
                      }).toList();
                  final displayPets = filtered.take(_currentMax).toList();
                  if (state is HomeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/cute_cat.png', height: 120),
                          const SizedBox(height: 16),
                          Text(
                            'No pets found! Try another search.',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: ListView.builder(
                      key: ValueKey(displayPets.length),
                      controller: _scrollController,
                      padding: const EdgeInsets.only(bottom: 24),
                      itemCount:
                          displayPets.length +
                          (_currentMax < filtered.length ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == displayPets.length &&
                            _currentMax < filtered.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (index >= displayPets.length)
                          return const SizedBox.shrink();
                        final pet = displayPets[index];
                        final isAdopted = adoptedIds.contains(pet.id);
                        final isFavorite = favoriteIds.contains(pet.id);
                        return PetListItem(
                          pet: pet,
                          isAdopted: isAdopted,
                          isFavorite: isFavorite,
                          onTap: () async {
                            final result = await Navigator.pushNamed(
                              context,
                              '/details',
                              arguments: pet,
                            );
                            if (result == true) {
                              _loadAdoptedAndFavorites();
                            }
                          },
                          onFavorite: () => _onFavorite(pet),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
