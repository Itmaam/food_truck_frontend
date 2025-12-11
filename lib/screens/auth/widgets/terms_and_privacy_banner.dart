import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:go_router/go_router.dart';

class TermsAndPrivacyBanner extends StatelessWidget {
  const TermsAndPrivacyBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: S.of(context).I_aggree_to,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          TextSpan(
            text: S.of(context).termsconditions,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).primaryColor,
              decoration: TextDecoration.underline,
            ),
            recognizer:
                TapGestureRecognizer()..onTap = () => context.push('/tos'),
          ),
          TextSpan(
            text: S.of(context).and,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          TextSpan(
            text: S.of(context).privacy,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).primaryColor,
              decoration: TextDecoration.underline,
            ),
            recognizer:
                TapGestureRecognizer()..onTap = () => context.push('/tos'),
          ),
        ],
      ),
    );
  }
}
