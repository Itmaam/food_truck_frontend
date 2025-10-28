import 'package:flutter/material.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:food_truck_finder_user_app/ui_helpers/constants/app_spacing.dart';

class SigninWithAppleButton extends StatelessWidget {
  final Function onClick;
  final String? label;
  const SigninWithAppleButton({super.key, required this.onClick, this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick.call(),
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(AppSpacing.medium),
        decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: Theme.of(context).disabledColor),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: <Widget>[
            Icon(Icons.apple, size: 40),
            const SizedBox(width: AppSpacing.small),
            Text(label ?? S.of(context).signinWithApple, style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}
