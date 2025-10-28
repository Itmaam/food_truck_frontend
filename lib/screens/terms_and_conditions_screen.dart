import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:food_truck_finder_user_app/api/core/http_client.dart';
import 'package:food_truck_finder_user_app/app_url.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:food_truck_finder_user_app/language_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  bool isLoading = true;
  String termsAndConditions = '';
  String termsAndConditionsAR = '';

  /// Loads the terms and conditions from the API.
  Future<void> _loadTermsAndConditions() async {
    HttpClient client = HttpClient();
    try {
      // Example API call to fetch terms and conditions
      final response = await client.get('${AppUrl.apiUrl}/terms-and-conditions');
      setState(() {
        termsAndConditions = response['content'] ?? '';
        termsAndConditionsAR = response['content_ar'] ?? '';
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
    _loadTermsAndConditions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(S.of(context).termsconditions),
        leading: IconButton(onPressed: () => context.pop(), icon: Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(S.of(context).termsconditions, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else
              Html(
                data:
                    Provider.of<LanguageProvider>(context).locale.languageCode == 'ar'
                        ? termsAndConditionsAR
                        : termsAndConditions,
                style: {"body": Style(fontSize: FontSize(16.0), lineHeight: LineHeight(1.5))},
              ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
