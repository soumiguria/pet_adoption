import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:confetti/confetti.dart';
import '../../core/models/pet.dart';
import '../../core/services/local_storage_service.dart';
import 'bloc/details_bloc.dart';
import 'bloc/details_event.dart';
import 'bloc/details_state.dart';
import 'widgets/pet_image_viewer.dart';

class DetailsPage extends StatelessWidget {
  final Pet pet;
  const DetailsPage({Key? key, required this.pet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              DetailsBloc(localStorageService: LocalStorageService(), pet: pet),
      child: DetailsView(pet: pet),
    );
  }
}

class DetailsView extends StatefulWidget {
  final Pet pet;
  const DetailsView({Key? key, required this.pet}) : super(key: key);

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _showAdoptedDialog(String name) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Congratulations!'),
            content: Text("You've now adopted $name"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DetailsBloc, DetailsState>(
      listener: (context, state) {
        if (state is DetailsAdopted) {
          _confettiController.play();
          _showAdoptedDialog(state.pet.name);
        }
      },
      builder: (context, state) {
        final pet = widget.pet;
        bool isAdopted = false;
        bool isFavorite = false;
        if (state is DetailsLoaded) {
          isAdopted = state.isAdopted;
          isFavorite = state.isFavorite;
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(pet.name),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  context.read<DetailsBloc>().add(ToggleFavorite(pet));
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => PetImageViewer(imageUrl: pet.imageUrl),
                        ),
                      );
                    },
                    child: Hero(
                      tag: 'petImage_${pet.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          pet.imageUrl,
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    pet.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    '${pet.type} • ${pet.age} years',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${pet.price}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed:
                        isAdopted
                            ? null
                            : () {
                              context.read<DetailsBloc>().add(AdoptPet(pet));
                            },
                    child: Text(isAdopted ? 'Already Adopted' : 'Adopt Me'),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple,
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
