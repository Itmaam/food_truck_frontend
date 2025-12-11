// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:food_truck_finder_user_app/api/auth/auth.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:food_truck_finder_user_app/language_provider.dart';
import 'package:food_truck_finder_user_app/localization/widgets/switch_language.dart';
import 'package:food_truck_finder_user_app/ui_helpers/constants/app_spacing.dart';
import 'package:food_truck_finder_user_app/ui_helpers/theme/manager/theme_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

class ProfileMenu extends StatefulWidget {
  final Function? afterCangeLanguage;

  const ProfileMenu({super.key, required this.afterCangeLanguage});

  @override
  State<ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<ProfileMenu> {
  void _handleMenuAction(String action) async {
    switch (action) {
      case 'login':
        context.push('/auth/login');
        break;
      case 'signup':
        context.push('/auth/signup');
        break;
      case 'change_theme':
        ThemeManager.instance.changeTheme(ThemeManager.instance.isDark ? ThemeEnum.light : ThemeEnum.dark);
        break;
      case 'Profile':
        context.push('/profile');
        break;
      case 'Favorites':
        context.push('/favorites');
        break;
      case 'Notifications':
        context.push('/notifications');
        break;
      case 'Privacy':
        context.push('/privacy_policy');
        break;
      case 'Terms&Conditions':
        context.push('/tos');
        break;
      case 'ContactUs':
        context.push('/contact_us');
        break;
      case 'logout':
        await UserAuthManager.logout();
        context.push('/auth/login');
        break;
      case 'delete_account':
        _showDeleteAccountDialog();
        break;
      default:
    }
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).deleteAccount),
          content: Text(S.of(context).deleteAccountMessage),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteAccount();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              child: Text('Delete Account'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(children: [CircularProgressIndicator(), SizedBox(width: 20), Text('Deleting account...')]),
          );
        },
      );

      bool success = await UserAuthManager.deleteAccount();

      // Close loading dialog
      Navigator.of(context).pop();

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Account deleted successfully')));
        context.push('/auth/login');
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete account. Please try again.')));
      }
    } catch (e) {
      // Close loading dialog if still open
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting account: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);
    final primaryColor = Theme.of(context).primaryColor;

    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return PopupMenuButton<String>(
          offset: Offset(0, 50),
          child:
              UserAuthManager.isLoggedIn
                  ? CircleAvatar(backgroundImage: NetworkImage(UserAuthManager.currentUser!.image))
                  : Container(
                    padding: EdgeInsets.all(AppSpacing.small),
                    decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(20)),
                    child: badges.Badge(
                      position: badges.BadgePosition.topEnd(top: -20, end: -12),
                      badgeStyle: badges.BadgeStyle(shape: badges.BadgeShape.circle, badgeColor: Colors.red),
                      showBadge: !UserAuthManager.isLoggedIn,
                      badgeContent: Text('!', style: TextStyle(color: Colors.white)),
                      child: const Icon(Icons.person_2_rounded, color: Colors.white),
                    ),
                  ),
          itemBuilder:
              (BuildContext context) => <PopupMenuEntry<String>>[
                // Show Login/Signup for guests
                if (!UserAuthManager.isLoggedIn)
                  PopupMenuItem<String>(
                    value: 'login',
                    child: ListTile(
                      leading: Icon(Icons.login, color: primaryColor),
                      title: Text(lang.login, style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                    ),
                  ),
                if (!UserAuthManager.isLoggedIn)
                  PopupMenuItem<String>(
                    value: 'signup',
                    child: ListTile(
                      leading: Icon(Icons.person_add, color: primaryColor),
                      title: Text(lang.signup, style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                    ),
                  ),
                if (!UserAuthManager.isLoggedIn) PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'Profile',
                  child: ListTile(leading: Icon(Icons.person), title: Text(lang.profile)),
                ),
                PopupMenuItem<String>(
                  value: 'Favorites',
                  child: ListTile(leading: Icon(Icons.favorite), title: Text(lang.favorites)),
                ),
                PopupMenuItem<String>(
                  value: 'Notifications',
                  child: ListTile(leading: Icon(Icons.notifications), title: Text(lang.notifications)),
                ),
                PopupMenuItem<String>(
                  value: 'Privacy',
                  child: ListTile(leading: Icon(Icons.privacy_tip), title: Text(lang.privacy)),
                ),
                PopupMenuItem<String>(
                  value: 'Terms&Conditions',
                  child: ListTile(leading: Icon(Icons.privacy_tip_sharp), title: Text(lang.termsconditions)),
                ),
                PopupMenuItem<String>(
                  value: 'ContactUs',
                  child: ListTile(leading: Icon(Icons.contact_emergency), title: Text(lang.contactUs)),
                ),
                PopupMenuItem<String>(
                  value: 'change_theme',
                  child: ListTile(
                    leading: Icon(ThemeManager.instance.isDark ? Icons.light_mode : Icons.dark_mode),
                    title: Text(lang.changeThemeMsg(ThemeManager.instance.isDark ? lang.light : lang.dark)),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'changeLang',
                  child: ListTile(
                    leading: Icon(Icons.language),
                    title: SwitchLanguage(afterCange: () => widget.afterCangeLanguage?.call()),
                  ),
                ),
                if (UserAuthManager.isLoggedIn)
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: ListTile(leading: Icon(Icons.logout), title: Text(lang.logout)),
                  ),
                if (UserAuthManager.isLoggedIn)
                  PopupMenuItem<String>(
                    value: 'delete_account',
                    child: ListTile(
                      leading: Icon(Icons.delete_forever, color: Colors.red),
                      title: Text(S.of(context).deleteAccount, style: TextStyle(color: Colors.red)),
                    ),
                  ),
              ],
          onSelected: _handleMenuAction,
        );
      },
    );
  }
}
