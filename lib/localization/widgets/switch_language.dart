import 'package:flutter/material.dart';
import 'package:food_truck_finder_user_app/language_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SwitchLanguage extends StatelessWidget {
  Function? afterCange;
  SwitchLanguage({super.key, this.afterCange});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return DropdownButton<Locale>(
          value: languageProvider.locale,
          underline: Container(), // Remove underline for cleaner look
          onChanged: (Locale? newLocale) async {
            if (newLocale != null && newLocale != languageProvider.locale) {
              // Use the async setLocale method to persist the language change
              await languageProvider.setLocale(newLocale);
            }
            afterCange?.call();
          },
          items: const [
            DropdownMenuItem(value: Locale('en'), child: Text('English')),
            DropdownMenuItem(value: Locale('ar'), child: Text('العربية')),
          ],
        );
      },
    );
  }
}
