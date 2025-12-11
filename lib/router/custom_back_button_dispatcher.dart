import 'package:flutter/material.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:go_router/go_router.dart';

class CustomBackButtonDispatcher extends RootBackButtonDispatcher {
  final GoRouter router;

  CustomBackButtonDispatcher(this.router);

  @override
  Future<bool> didPopRoute() async {
    // Check if the current route can be popped
    if (router.canPop()) {
      router.pop();
      return true; // Indicate that the pop was handled
    }
    bool? result = await showDialog<bool>(
      context: router.routerDelegate.navigatorKey.currentContext!,
      builder:
          (context) => AlertDialog(
            title: Text(S.of(context).areYouSureToExit),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(S.of(context).yes),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(S.of(context).no),
              ),
            ],
          ),
    );
    return result ?? false; // Indicate that the pop was not handled
  }
}
