import 'package:flutter/material.dart';
import 'package:favourite_places/models/place.dart';
import 'package:favourite_places/providers/user_places.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favourite_places/screens/places_detail.dart';

class PlacesList extends ConsumerWidget {
  const PlacesList({super.key, required this.places});
  final List<Place> places;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (places.isEmpty) {
      return Center(
        child: Text(
          "No places added yet",
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
      );
    }
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (ctx, index) {
        final place = places[index];
        return Dismissible(
          key: ValueKey(place.id),
          background: Container(
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            // Remove the place from the database
            ref.read(userPlacesProvider.notifier).removePlace(place.id);
            // Show a snackbar or any other feedback
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${place.title} dismissed'),
              ),
            );
          },
          child: ListTile(
            leading: CircleAvatar(
              radius: 26,
              backgroundImage: FileImage(place.image),
            ),
            title: Text(
              place.title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
            subtitle: Text(
              place.location.address,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => PlacesDetailScreen(place: place)));
            },
          ),
        );
      },
    );
  }
}