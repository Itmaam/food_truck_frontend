import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_truck_finder_user_app/api/models/food_truck.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:food_truck_finder_user_app/ui_helpers/constants/app_spacing.dart';
import 'package:food_truck_finder_user_app/ui_helpers/theme/theme_context_extension.dart';

class FoodMenuTabView extends StatelessWidget {
  final FoodTruck foodTruck;

  const FoodMenuTabView({super.key, required this.foodTruck});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: Theme.of(context).dialogTheme.backgroundColor,

        borderRadius: BorderRadius.circular(10),
      ), // Map
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).foodMenuTab, style: context.theme.textTheme.labelLarge),
          SizedBox(height: AppSpacing.small),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: ListView.builder(
              itemCount: foodTruck.menu_items!.length,
              itemBuilder:
                  (context, index) => Card(
                    child: Padding(
                      padding: AppSpacing.allMedium,
                      child: ListTile(
                        leading:
                            foodTruck.menu_items![index].imageUrl != null
                                ? Image.network(foodTruck.menu_items![index].imageUrl ?? '')
                                : SvgPicture.asset('assets/svgs/cutlery-fork.svg', height: 20),
                        title: Text(foodTruck.menu_items![index].name),
                        subtitle: Text(foodTruck.menu_items![index].description ?? ''),
                      ),
                      // child: Row(
                      //   children: [
                      //     ,
                      //     SizedBox(width: AppSpacing.small),
                      //     Text(foodTruck.menu_items![index].name),
                      //   ],
                      // ),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
