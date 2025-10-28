import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:food_truck_finder_user_app/api/models/sub_category.dart';
import 'package:food_truck_finder_user_app/language_provider.dart';
import 'package:food_truck_finder_user_app/ui_helpers/constants/app_spacing.dart';
import 'package:provider/provider.dart';

class SubCategorySelector extends StatelessWidget {
  final List<int> selected; // Use IDs instead of full objects
  final List<SubCategory> allSubCategories;
  final Function(List<int>) onChanged;

  const SubCategorySelector({
    super.key,
    required this.onChanged,
    required this.selected,
    required this.allSubCategories,
  });

  @override
  Widget build(BuildContext context) {
    return allSubCategories.isEmpty
        ? Center(
          child: Padding(padding: EdgeInsets.only(top: AppSpacing.large), child: CircularProgressIndicator.adaptive()),
        )
        : SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: AppSpacing.allMedium,
          child: ChipsChoice<int>.multiple(
            value: selected,
            onChanged: onChanged,
            choiceItems: C2Choice.listFrom<int, SubCategory>(
              source: allSubCategories,
              value: (i, v) => v.id, // IDs must be unique
              label: (i, v) => Provider.of<LanguageProvider>(context).locale.languageCode == 'ar' ? v.arLang : v.name,
            ),
            choiceCheckmark: true,
            choiceStyle: C2ChipStyle(
              backgroundColor: Colors.white,
              backgroundOpacity: 0.8,
              foregroundStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        );
  }
}
