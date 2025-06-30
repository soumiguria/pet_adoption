import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/local_storage_service.dart';
import 'bloc/history_bloc.dart';
import 'bloc/history_event.dart';
import 'bloc/history_state.dart';

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
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(title: const Text('Adoption History')),
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
              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
                itemCount: state.adoptedPets.length,
                itemBuilder: (context, index) {
                  final pet = state.adoptedPets[index];
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 400 + index * 50),
                    curve: Curves.easeInOut,
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
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
