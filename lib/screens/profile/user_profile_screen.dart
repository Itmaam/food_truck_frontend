import 'package:flutter/material.dart';
import 'package:food_truck_finder_user_app/api/app_api.dart';
import 'package:food_truck_finder_user_app/api/auth/user_auth_manager.dart';
import 'package:food_truck_finder_user_app/api/models/food_truck.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:food_truck_finder_user_app/screens/profile/widgets/food_truck_list_item.dart';
import 'package:food_truck_finder_user_app/ui_helpers/constants/app_spacing.dart';
import 'package:food_truck_finder_user_app/ui_helpers/theme/theme_context_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    if (!UserAuthManager.isLoggedIn) {
      // Use addPostFrameCallback to avoid navigation during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.push('/auth/login');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(S.of(context).profile),
        leading: IconButton(
          onPressed: () => context.push('/home'),
          icon: Icon(Icons.arrow_back),
        ),

        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child:
            !UserAuthManager.isLoggedIn
                ? Text('')
                : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.medium),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(AppSpacing.large),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              UserAuthManager.currentUser!.image,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // User Info
                        ListTile(
                          title: Text(
                            UserAuthManager.currentUser!.name ?? '',
                            style: context.theme.textTheme.titleLarge,
                          ),
                          subtitle: Text(
                            UserAuthManager.currentUser!.email ?? '',
                            style: context.theme.textTheme.labelLarge!.copyWith(
                              decoration: TextDecoration.underline,
                              color: context.theme.primaryColor,
                              decorationColor: context.theme.primaryColor,
                            ),
                          ),
                          // trailing: ElevatedButton.icon(
                          //   onPressed: () {
                          //     // Navigate to edit profile
                          //   },
                          //   icon: const Icon(Icons.edit),
                          //   label: Text(S.of(context).edit),
                          // ),
                        ),

                        Divider(color: Colors.grey.withValues(alpha: 0.5)),
                        Padding(
                          padding: EdgeInsets.all(AppSpacing.small),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                S.of(context).yourFoodTruck,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => context.push('/add_activity'),
                                child: Icon(Icons.add, color: Colors.white),
                              ),
                            ],
                          ),
                        ),

                        Divider(color: Colors.grey.withValues(alpha: 0.5)),

                        // Activity Info
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: FutureBuilder<List<FoodTruck>>(
                            future: AppApi.foodTruckApi.myTrucks(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              }
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Center(child: Text(''));
                              }
                              return RefreshIndicator(
                                onRefresh: () async {
                                  // Explicitly return Future<void>
                                  setState(() {}); // Trigger rebuild
                                  return; // Explicit return
                                },
                                child: ListView(
                                  scrollDirection: Axis.horizontal,

                                  children:
                                      snapshot.data!
                                          .map(
                                            (item) => FoodTruckListItem(
                                              foodTruck: item,
                                              onDelete: () async {
                                                await AppApi.foodTruckApi
                                                    .delete(item.id);
                                                setState(
                                                  () {},
                                                ); // Trigger rebuild
                                              },
                                            ),
                                          )
                                          .toList(),
                                ),
                              );
                            },
                          ),
                        ),

                        // Divider(color: Colors.grey.withValues(alpha: 0.5)),

                        // // Map Section
                        // SizedBox(
                        //   height: 200,
                        //   child: GoogleMap(
                        //     initialCameraPosition: CameraPosition(target: _activityLocation, zoom: 14),
                        //     markers: {Marker(markerId: MarkerId('activity'), position: _activityLocation)},
                        //     onMapCreated: (controller) {
                        //       setState(() {
                        //         mapController = controller;
                        //       });
                        //     },
                        //   ),
                        // ),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   children: [
                        //     ElevatedButton.icon(
                        //       onPressed: () {
                        //         // Refresh location logic here
                        //       },
                        //       icon: const Icon(Icons.my_location),
                        //       label: const Text('Refresh Location'),
                        //     ),
                        //     ElevatedButton.icon(
                        //       onPressed: () {
                        //         // Share location logic
                        //       },
                        //       icon: const Icon(Icons.share),
                        //       label: const Text('Share Location'),
                        //     ),
                        //   ],
                        // ),

                        // Divider(color: Colors.grey.withValues(alpha: 0.5)),

                        // // Reviews Section
                        // Padding(
                        //   padding: const EdgeInsets.all(16.0),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       const Text('Guest Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        //       const SizedBox(height: 8),
                        //       ListTile(
                        //         leading: const CircleAvatar(child: Icon(Icons.person)),
                        //         title: const Text('Ali'),
                        //         subtitle: const Text('Great taste and friendly staff!'),
                        //         trailing: const Icon(Icons.star, color: Colors.amber),
                        //       ),
                        //       ListTile(
                        //         leading: const CircleAvatar(child: Icon(Icons.person)),
                        //         title: const Text('Sara'),
                        //         subtitle: const Text('Loved the vegan burger!'),
                        //         trailing: const Icon(Icons.star, color: Colors.amber),
                        //       ),
                        //       ElevatedButton.icon(
                        //         onPressed: () {
                        //           // Add rating logic
                        //         },
                        //         icon: const Icon(Icons.rate_review),
                        //         label: const Text('Add Rating/Comment'),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
