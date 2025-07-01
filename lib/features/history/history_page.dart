import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/local_storage_service.dart';
import 'bloc/history_bloc.dart';
import 'bloc/history_event.dart';
import 'bloc/history_state.dart';
import '../../core/models/pet.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create:
          (_) =>
              HistoryBloc(localStorageService: LocalStorageService())
                ..add(LoadHistory()),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWeb = constraints.maxWidth > 700;
          final gridColumns = isWeb ? 3 : 1;
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar:
                isWeb
                    ? null
                    : AppBar(
                      title: const Text('Adoption History'),
                      backgroundColor: theme.appBarTheme.backgroundColor,
                      foregroundColor: theme.appBarTheme.foregroundColor,
                      elevation: theme.appBarTheme.elevation,
                    ),
            body: BlocBuilder<HistoryBloc, HistoryState>(
              builder: (context, state) {
                if (state is HistoryLoaded) {
                  if (state.adoptedPets.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 80,
                            color: theme.colorScheme.secondary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No pets adopted yet!',
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    );
                  }
                  if (gridColumns > 1) {
                    // Web: grid of cards
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 24,
                            crossAxisSpacing: 24,
                            childAspectRatio: 1.1,
                          ),
                      itemCount: state.adoptedPets.length,
                      itemBuilder: (context, index) {
                        final pet = state.adoptedPets[index];
                        return _WebPetCard(pet: pet);
                      },
                    );
                  } else {
                    // Mobile: list of cards with slide animation
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 8,
                      ),
                      itemCount: state.adoptedPets.length,
                      itemBuilder: (context, index) {
                        final pet = state.adoptedPets[index];
                        return TweenAnimationBuilder<Offset>(
                          tween: Tween(
                            begin: const Offset(1, 0),
                            end: Offset.zero,
                          ),
                          duration: Duration(milliseconds: 400 + index * 50),
                          curve: Curves.easeOutCubic,
                          builder: (context, offset, child) {
                            return Transform.translate(
                              offset: Offset(offset.dx * 40, 0),
                              child: child,
                            );
                          },
                          child: Card(
                            color: theme.cardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 6,
                            margin: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 8,
                            ),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  pet.imageUrl,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                pet.name,
                                style: theme.textTheme.headlineSmall,
                              ),
                              subtitle: Text(
                                '${pet.type} • ${pet.age} yrs • \$${pet.price}',
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          );
        },
      ),
    );
  }
}

class _WebPetCard extends StatelessWidget {
  final Pet pet;
  const _WebPetCard({required this.pet});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 6,
      margin: const EdgeInsets.all(2),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                pet.imageUrl,
                width: 110,
                height: 110,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              pet.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.deepPurple,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              '${pet.type} • ${pet.age} yrs',
              style: const TextStyle(fontSize: 15, color: Colors.black54),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.attach_money, color: Colors.amber[700], size: 20),
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
    );
  }
}
