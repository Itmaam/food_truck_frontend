import 'package:clippy_flutter/triangle.dart';
import 'package:flutter/material.dart';
import 'package:food_truck_finder_user_app/api/models/food_truck.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:food_truck_finder_user_app/ui_helpers/constants/app_spacing.dart';
import 'package:food_truck_finder_user_app/ui_helpers/theme/theme_context_extension.dart';

class PopupWindow extends StatelessWidget {
  final FoodTruck foodTruck;
  const PopupWindow({super.key, required this.foodTruck});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(color: context.theme.cardColor, borderRadius: BorderRadius.circular(4)),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //add truck image if available
                if (foodTruck.images != null && foodTruck.images!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      child: Image.network(
                        foodTruck.images!.first.imageUrl,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value:
                                  loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ?? 1)
                                      : null,
                            ),
                          );
                        },
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.088,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(child: Icon(Icons.restaurant_menu, color: Colors.white));
                        },
                      ),
                    ),
                  ),
                SizedBox(height: AppSpacing.small),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.restaurant_menu, size: 20),
                    SizedBox(width: 8.0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.33,
                      child: Text(
                        foodTruck.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.small),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.timer, size: 15),
                    SizedBox(width: 8.0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.33,
                      child: Text(
                        foodTruck.isOpen ? S.of(context).openNow : S.of(context).closedNow,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: foodTruck.isOpen ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.small),
                // Display rating if available
                if (foodTruck.rating != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0),
                    child: Row(
                      children: [
                        Icon(Icons.star, size: 15, color: Colors.amber),
                        SizedBox(width: 8.0),
                        Text(foodTruck.rating!.toStringAsFixed(1), style: Theme.of(context).textTheme.labelMedium),
                      ],
                    ),
                  ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFF8984A),
                        foregroundColor: Colors.white,
                        minimumSize: Size(MediaQuery.of(context).size.width * 0.05, 22),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      onPressed: () {},
                      child: Text(S.of(context).viewDetails),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Triangle.isosceles(
          edge: Edge.BOTTOM,
          child: Container(color: context.theme.cardColor, width: 20.0, height: 10.0),
        ),
      ],
    );
  }
}
