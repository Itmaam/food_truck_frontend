import 'package:flutter/material.dart';
import 'package:food_truck_finder_user_app/api/core/http_client.dart';
import 'package:food_truck_finder_user_app/app_url.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:food_truck_finder_user_app/language_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool isLoading = true;
  String privacyPolicy = '';
  String privacyPolicyAr = '';

  /// Loads the privacy policy from the API.
  Future<void> _loadPrivacyPolicy() async {
    HttpClient client = HttpClient();
    try {
      // Example API call to fetch privacy policy
      final response = await client.get('${AppUrl.apiUrl}/privacy-policy');
      setState(() {
        privacyPolicy = response['content'] ?? '';
        privacyPolicyAr = response['content_ar'] ?? '';
        isLoading = false;
      });
    } catch (e) {
      // Handle any exceptions
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _loadPrivacyPolicy();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(S.of(context).privacy),
        leading: IconButton(onPressed: () => context.pop(), icon: Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(S.of(context).privacy, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else
              // check if language ar or en
              Html(
                data:
                    privacyPolicy.isEmpty
                        ? 'No privacy policy available at the moment.'
                        : Provider.of<LanguageProvider>(context).locale.languageCode == 'ar'
                        ? privacyPolicyAr
                        : privacyPolicy,
                style: {
                  "body": Style(fontSize: FontSize(16.0)),
                  "h1": Style(fontSize: FontSize(24.0), fontWeight: FontWeight.bold),
                },
              ),
            // Add more policy points as needed
          ],
        ),
      ),
    );
  }
}
