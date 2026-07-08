// import 'package:face_detector_plugin/face_detector_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:foodapp/providers/dish_api.dart';
import 'package:foodapp/screens/Sign-in-up/widget/custom_scaffold.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;
  String? _errorMessage;
  String? _passedEmail;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the email from navigation arguments if available
    final args = GoRouterState.of(context).extra;
    if (args is Map && args['email'] != null) {
      _passedEmail = args['email'] as String;
    } else {
      _passedEmail = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: IconButton(
                    alignment: Alignment.center,
                    onPressed: () {
                      context.pop();
                    },
                    icon: const Icon(Icons.arrow_back_ios_sharp),
                    color: Colors.black,
                    iconSize: 20,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Verify Email",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Enter the code sent to your email",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 50, 30, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 30),
                      FormBuilderTextField(
                        name: "Email",
                        initialValue: _passedEmail,
                        readOnly: _passedEmail != null,
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Enter your email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: "This field is required",
                          ),
                          FormBuilderValidators.email(),
                        ]),
                      ),
                      const SizedBox(height: 20),
                      FormBuilderTextField(
                        name: "OTP",
                        decoration: InputDecoration(
                          labelText: "Verification Code",
                          hintText: "Enter code",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.verified_outlined),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: "This field is required",
                          ),
                          FormBuilderValidators.minLength(4),
                        ]),
                      ),
                      const SizedBox(height: 20),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed:
                              _isLoading
                                  ? null
                                  : () async {
                                    if (_formKey.currentState
                                            ?.saveAndValidate() ??
                                        false) {
                                      setState(() {
                                        _isLoading = true;
                                        _errorMessage = null;
                                      });
                                      final email =
                                          _formKey
                                              .currentState
                                              ?.fields['Email']
                                              ?.value;
                                      final otp =
                                          _formKey
                                              .currentState
                                              ?.fields['OTP']
                                              ?.value;
                                      final result =
                                          await ApiService.verifyEmail(
                                            email,
                                            otp,
                                          );
                                      setState(() => _isLoading = false);

                                      if (result['success'] == true) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              result['message'] ??
                                                  'Email verified!',
                                            ),
                                          ),
                                        );
                                        Future.delayed(
                                          const Duration(milliseconds: 500),
                                          () {
                                            context.push('/signin');
                                          },
                                        );
                                      } else {
                                        setState(() {
                                          _errorMessage =
                                              result['message'] ??
                                              'Verification failed';
                                        });
                                      }
                                    }
                                  },
                          child:
                              _isLoading
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Text(
                                    "Verify",
                                    style: TextStyle(fontSize: 16),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
