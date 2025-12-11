// ignore_for_file: use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_truck_finder_user_app/api/core/http_client.dart';
import 'package:food_truck_finder_user_app/app_url.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:food_truck_finder_user_app/ui_helpers/constants/app_spacing.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  bool isLoading = true; // Simulating loading state

  final formKey = GlobalKey<FormBuilderState>();

  String contactEmail = '';
  String contactPhone = '';
  String contactAddress = '';

  Future<void> _openUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _fetchContactDetails() async {
    try {
      HttpClient client = HttpClient();
      setState(() {
        isLoading = true; // Update loading state
      });

      // Example API call to fetch contact details
      final response = await client.get('${AppUrl.apiUrl}/contact-us');
      if (response != null) {
        contactEmail = response['email'] ?? '';
        contactPhone = response['phone'] ?? '';
        contactAddress = response['address'] ?? '';
      }
    } catch (e) {
      // Handle any exceptions
    } finally {
      setState(() {
        isLoading = false; // Update loading state
      });
    }
  }

  @override
  void initState() {
    _fetchContactDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(S.of(context).contactUs),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FormBuilder(
                key: formKey,
                child: ListView(
                  children: [
                    Text(
                      S.of(context).contactUsTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    FormBuilderTextField(
                      name: 'name',
                      decoration: InputDecoration(
                        labelText: S.of(context).name,
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty ? S.of(context).required : null,
                    ),
                    const SizedBox(height: 12),
                    FormBuilderTextField(
                      name: 'email',
                      decoration: InputDecoration(
                        labelText: S.of(context).email,
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty ? S.of(context).required : null,
                    ),
                    const SizedBox(height: 12),
                    FormBuilderTextField(
                      name: 'message',
                      decoration: InputDecoration(
                        labelText: S.of(context).message,
                      ),
                      maxLines: 5,
                      validator:
                          (value) =>
                              value!.isEmpty ? S.of(context).required : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.send),
                      label: Text(S.of(context).send),
                      onPressed: () async {
                        print('object');
                        if (formKey.currentState?.saveAndValidate() ?? false) {
                          final formData = formKey.currentState!.value;
                          print('Form Data: $formData');

                          HttpClient client = HttpClient();
                          await client.post(
                            '${AppUrl.apiUrl}/contact-us',
                            body: {
                              'name': formData['name'],
                              'email': formData['email'],
                              'message': formData['message'],
                            },
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(S.of(context).messageSent)),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: AppSpacing.medium),
            if (!isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.medium,
                  horizontal: AppSpacing.small,
                ),
                child: Column(
                  children: [
                    RichText(
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      strutStyle: StrutStyle(height: 1, leading: 0.5),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      text: TextSpan(
                        text: S.of(context).contactUsFooter,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' $contactEmail',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    _openUrl(
                                      Uri(scheme: 'mailto', path: contactEmail),
                                    );
                                  },
                          ),
                          TextSpan(
                            text: ' | ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextSpan(
                            text: ' $contactPhone',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () async {
                                    await _openUrl(
                                      Uri(scheme: 'tel', path: contactPhone),
                                    );
                                  },
                          ),
                          TextSpan(
                            text: ' ${S.of(context).address}: $contactAddress',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        final phone = contactPhone.replaceAll(
                          RegExp(r'\D'),
                          '',
                        );
                        final whatsappUrl = Uri.parse('https://wa.me/$phone');
                        await _openUrl(whatsappUrl);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/svgs/whatsapp-svgrepo-com.svg',
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            contactPhone,
                            style: TextStyle(
                              color: Colors.green[800],
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
