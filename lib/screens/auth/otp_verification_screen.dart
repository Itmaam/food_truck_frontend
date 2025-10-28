import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:food_truck_finder_user_app/api/app_api.dart';
import 'package:food_truck_finder_user_app/generated/l10n.dart';
import 'package:food_truck_finder_user_app/layouts/auth_layout.dart';
import 'package:food_truck_finder_user_app/ui_helpers/constants/app_spacing.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);

    return AuthLayout(
      child: FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  lang.verifyOtpTitle,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.large),
            Text(
              lang.otpSentMessage(widget.email),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.large),
            FormBuilderTextField(
              name: 'otp',
              decoration: InputDecoration(prefixIcon: const Icon(Icons.lock_outline), hintText: lang.otpCodeHint),
              keyboardType: TextInputType.number,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(6),
                FormBuilderValidators.maxLength(6),
              ]),
            ),
            const SizedBox(height: AppSpacing.medium),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.medium),
                child: Text(_errorMessage!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red)),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _verifyOtp,
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                          lang.verifyOtpButton,
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white),
                        ),
              ),
            ),
            const SizedBox(height: AppSpacing.medium),
            TextButton(
              onPressed: _isLoading ? null : () => context.push('/auth/login'),
              child: Text(lang.cancelButton, style: Theme.of(context).textTheme.labelLarge),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _verifyOtp() async {
    if (_formKey.currentState!.saveAndValidate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final otp = _formKey.currentState!.fields['otp']!.value as String;
        final response = await AppApi.passwordResetApi.verifyOtp(widget.email, otp);

        debugPrint('OTP Verification Response: $response');

        if (response['reset_token'] == null) {
          throw Exception('No token received from server');
        }

        if (mounted) {
          context.push('/auth/reset-password?email=${widget.email}&&token=${response['reset_token']}');
        }
      } catch (e) {
        setState(() {
          final lang = S.of(context);
          _errorMessage = e.toString().contains('No token') ? lang.invalidOtpResponse : lang.genericError;
        });
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }
}
