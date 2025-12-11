import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:food_truck_finder_user_app/ui_helpers/constants/app_spacing.dart';

class SigninWithGoogle extends StatelessWidget {
  final Function onClick;
  final String? label;
  const SigninWithGoogle({super.key, required this.onClick, this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick.call(),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium, vertical: AppSpacing.small),
        decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: Theme.of(context).disabledColor),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset('assets/svgs/google-icon-logo.svg', width: 24),
            const SizedBox(width: AppSpacing.small),
            Text(label ?? S.of(context).loginGoogle, style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}
