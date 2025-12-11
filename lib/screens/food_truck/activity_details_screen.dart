// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:food_truck_finder_user_app/api/app_api.dart';
import 'package:food_truck_finder_user_app/api/auth/user_auth_manager.dart';
import 'package:food_truck_finder_user_app/api/models/food_truck.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:food_truck_finder_user_app/language_provider.dart';
import 'package:food_truck_finder_user_app/screens/food_truck/widgets/favorite_button.dart';
import 'package:food_truck_finder_user_app/screens/food_truck/widgets/tab_view/address_tab_view.dart';
import 'package:food_truck_finder_user_app/screens/food_truck/widgets/tab_view/food_menu_tab_view.dart';
import 'package:food_truck_finder_user_app/screens/food_truck/widgets/tab_view/review_tab_view.dart';
import 'package:food_truck_finder_user_app/ui_helpers/constants/app_spacing.dart';
import 'package:food_truck_finder_user_app/ui_helpers/theme/theme_context_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ActivityDetailsScreen extends StatefulWidget {
  final String foodTruckId;
  const ActivityDetailsScreen({super.key, required this.foodTruckId});

  @override
  State<ActivityDetailsScreen> createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  FoodTruck? _foodTruck;
  bool _isLoading = true;

  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadFoodTruckData();
  }

  Future<void> _loadFoodTruckData() async {
    try {
      final foodTruck = await AppApi.foodTruckApi.getById(int.parse(widget.foodTruckId));

      setState(() {
        _foodTruck = foodTruck;
        _isLoading = false;
      });
    } catch (e, s) {
      print(e);
      print(s);
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).failedLoadFoodTruck)));
    }
  }

  Widget _buildImageCarousel() {
    if (_foodTruck?.images == null || _foodTruck!.images!.isEmpty) {
      return Image.network(
        'https://picsum.photos/id/371/800/400',
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      );
    }

    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: _foodTruck!.images!.length,
            onPageChanged: (index) => setState(() => _currentImageIndex = index),
            itemBuilder:
                (context, index) =>
                    Image.network(_foodTruck!.images![index].imageUrl, width: double.infinity, fit: BoxFit.cover),
          ),
          if (_foodTruck!.images!.length > 1)
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _foodTruck!.images!.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentImageIndex == index ? Colors.white : Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _foodTruck = null;
    _isLoading = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(lang.details),
        leading: IconButton(onPressed: () => context.pop(), icon: Icon(Icons.arrow_back)),
      ),
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView(
                children: <Widget>[
                  // Cover photo
                  _buildImageCarousel(),
                  // Info
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _foodTruck!.name,
                              style: context.theme.textTheme.titleLarge!.copyWith(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (UserAuthManager.isLoggedIn) FavoriteButton(foodTruckId: _foodTruck!.id),
                          ],
                        ),
                        SizedBox(height: AppSpacing.small),
                        Text(_foodTruck!.description),
                        SizedBox(height: AppSpacing.small),
                        Text(
                          _foodTruck!.isOpen ? lang.openNow : lang.closedNow,
                          style: context.theme.textTheme.labelMedium!.copyWith(
                            color: _foodTruck!.isOpen ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: AppSpacing.small),
                        Wrap(
                          direction: Axis.horizontal,
                          children:
                              _foodTruck!.categories!
                                  .map(
                                    (category) => Container(
                                      margin: EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
                                      padding: EdgeInsets.all(AppSpacing.small),
                                      decoration: BoxDecoration(
                                        color: context.theme.colorScheme.tertiaryContainer.withValues(alpha: 0.8),
                                        borderRadius: BorderRadius.circular(AppSpacing.large),
                                        border: Border.all(color: Colors.transparent),
                                        boxShadow: [BoxShadow(color: context.theme.shadowColor)],
                                      ),
                                      child: Text(
                                        Provider.of<LanguageProvider>(context).locale.languageCode == 'ar'
                                            ? category.arLang
                                            : category.name,
                                        style: context.theme.textTheme.labelSmall!.copyWith(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                        SizedBox(height: AppSpacing.small),

                        Wrap(
                          direction: Axis.horizontal,
                          children:
                              _foodTruck!.subCategories!
                                  .map(
                                    (category) => Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: AppSpacing.xxs,
                                        vertical: AppSpacing.xxs,
                                      ),
                                      padding: EdgeInsets.all(AppSpacing.xs),
                                      decoration: BoxDecoration(
                                        color: context.theme.colorScheme.inverseSurface.withValues(alpha: 0.6),
                                        borderRadius: BorderRadius.circular(AppSpacing.large),
                                        border: Border.all(color: Colors.transparent),
                                        boxShadow: [BoxShadow(color: context.theme.shadowColor)],
                                      ),
                                      child: Text(
                                        Provider.of<LanguageProvider>(context).locale.languageCode == 'ar'
                                            ? category.arLang
                                            : category.name,
                                        style: context.theme.textTheme.labelSmall!.copyWith(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DefaultTabController(
                      length: 3,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.medium),
                            decoration: BoxDecoration(
                              color: Theme.of(context).dialogTheme.backgroundColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TabBar(
                              isScrollable: false,
                              padding: EdgeInsets.zero,
                              controller: _tabController,
                              dividerColor: Colors.transparent,
                              enableFeedback: true,
                              indicatorColor: Theme.of(context).colorScheme.primary,
                              labelColor: Theme.of(context).colorScheme.secondary,

                              unselectedLabelColor: Theme.of(context).colorScheme.primary,
                              onTap: (int value) {
                                if (_tabController.indexIsChanging) {}
                              },
                              tabs: <Widget>[
                                Tab(text: lang.addressTab, icon: Icon(Icons.location_city)),
                                Tab(text: lang.foodMenu, icon: Icon(Icons.restaurant_menu)),
                                Tab(text: lang.review, icon: Icon(Icons.star)),
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(top: AppSpacing.small),
                            child: TabBarView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: _tabController,
                              children: <Widget>[
                                AddressTabView(foodTruck: _foodTruck!),
                                FoodMenuTabView(foodTruck: _foodTruck!),
                                ReviewTabView(
                                  foodTruckId: _foodTruck!.id,
                                  myTruck:
                                      (UserAuthManager.currentUser != null && UserAuthManager.isLoggedIn)
                                          ? UserAuthManager.currentUser!.id == _foodTruck!.userId
                                          : false,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
