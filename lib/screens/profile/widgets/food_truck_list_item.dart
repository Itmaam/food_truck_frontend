import 'package:flutter/material.dart';
import 'package:food_truck_finder_user_app/api/models/food_truck.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:go_router/go_router.dart';

class FoodTruckListItem extends StatelessWidget {
  final FoodTruck foodTruck;
  final Function? onDelete;
  const FoodTruckListItem({super.key, required this.foodTruck, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 180,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                foodTruck.name,
                style: Theme.of(context).textTheme.titleLarge,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(foodTruck.description, overflow: TextOverflow.ellipsis, maxLines: 2),
              Text(
                foodTruck.isOpen ? S.of(context).openNow : S.of(context).closedNow,
                style: TextStyle(
                  color: foodTruck.isOpen ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.error,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Row(
                children: [
                  Icon(Icons.phone, size: 16),
                  const SizedBox(width: 4),
                  Flexible(child: Text(foodTruck.phone, overflow: TextOverflow.ellipsis, maxLines: 1)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.web, size: 16),
                  const SizedBox(width: 4),
                  Flexible(child: Text(foodTruck.website ?? '', overflow: TextOverflow.ellipsis, maxLines: 1)),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => context.push('/view_activity/${foodTruck.id}'),
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Theme.of(context).colorScheme.tertiary, // keep original color
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.push('/edit_activity/${foodTruck.id}'),
                    icon: Icon(
                      Icons.edit,
                      color: Theme.of(context).primaryColor, // keep original color
                    ),
                  ),
                  IconButton(
                    onPressed: () => onDelete?.call(),
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.error, // keep original color
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
