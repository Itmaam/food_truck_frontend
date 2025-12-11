import 'package:flutter/material.dart';
import 'package:food_truck_finder_user_app/api/app_api.dart';
import 'package:food_truck_finder_user_app/api/models/favorite.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:food_truck_finder_user_app/screens/food_truck/widgets/favorite_button.dart';
import 'package:go_router/go_router.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<Favorite>> _favoritesFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshFavorites();
  }

  Future<void> _refreshFavorites() async {
    setState(() => _isLoading = true);
    try {
      _favoritesFuture = AppApi.favoriteApi.list(take: 200);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(S.of(context).favorites),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshFavorites,
        child: FutureBuilder<List<Favorite>>(
          future: _favoritesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !_isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(child: Text(S.of(context).noFavorites));
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final foodTruck = snapshot.data![index].foodTruck;
                return ListTile(
                  leading:
                      foodTruck!.images?.isNotEmpty == true
                          ? Image.network(
                            foodTruck.images!.first.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                          : const Icon(Icons.fastfood),
                  title: Text(foodTruck.name),
                  subtitle: Text(foodTruck.description),
                  trailing: FavoriteButton(foodTruckId: foodTruck.id),
                  onTap: () => context.push('/view_activity/${foodTruck.id}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
