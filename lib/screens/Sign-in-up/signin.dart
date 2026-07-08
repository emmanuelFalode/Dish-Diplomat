import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

import 'package:foodapp/providers/dish_api.dart';
import 'package:foodapp/screens/Sign-in-up/widget/custom_scaffold.dart';
import 'package:foodapp/screens/Sign-in-up/signup.dart';
// add this import for token storage
import 'package:foodapp/core/auth_storage.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formSignInKey = GlobalKey<FormBuilderState>();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  // Future<void> _handleSignIn() async {
  //   // Validate form
  //   if (!(_formSignInKey.currentState?.saveAndValidate() ?? false)) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Please fix the errors in the form')),
  //     );
  //     return;
  //   }

  //   // Hide keyboard
  //   FocusScope.of(context).unfocus();

  //   setState(() => _isLoading = true);

  //   try {
  //     final result = await ApiService.login({
  //       'email': emailcontroller.text.trim(),
  //       'password': passwordcontroller.text,
  //     });

  //     if (result['success'] == true) {
  //       final token = (result['token'] ?? '') as String;
  //       if (token.isEmpty) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('No token returned from server')),
  //         );
  //         setState(() => _isLoading = false);
  //         return;
  //       }

  //       // Save token (rememberMe could control persistence strategy if you want)
  //       await AuthStorage.saveToken(token);

  //       // Success message
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(result['message'] ?? 'Login successful')),
  //       );

  //       if (mounted) context.push('/location');
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(result['message'] ?? 'Login failed')),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('Login error: $e')));
  //   } finally {
  //     if (mounted) setState(() => _isLoading = false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Log In",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Please Sign In to your existing account",
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
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 30),

                      // Email
                      FormBuilderTextField(
                        name: "email",
                        controller: emailcontroller,
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

                      // Password
                      FormBuilderTextField(
                        name: "password",
                        controller: passwordcontroller,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Enter your password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.lock_outline),

                          // 👇 Toggle visibility icon
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: "This field is required",
                          ),
                          FormBuilderValidators.minLength(6),
                        ]),
                      ),

                      const SizedBox(height: 10),

                      // Remember Me & Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: FormBuilderCheckbox(
                                name: 'remember_me',
                                initialValue: _rememberMe,
                                title: const Text(
                                  "Remember me",
                                  style: TextStyle(fontSize: 15),
                                ),
                                activeColor: Colors.orange,
                                checkColor: Colors.white,
                                contentPadding: EdgeInsets.zero,
                                onChanged:
                                    (val) => setState(
                                      () => _rememberMe = val ?? false,
                                    ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.push("/forgot_password");
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Sign In Button
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
                          onPressed: _isLoading ? null : () => context.push('/location'),
                          child:
                              _isLoading
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                  : const Text(
                                    "Sign In",
                                    style: TextStyle(fontSize: 16),
                                  ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Divider
                      Row(
                        children: const [
                          Expanded(
                            child: Divider(thickness: 0.7, color: Colors.grey),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "Sign In with",
                              style: TextStyle(color: Colors.black45),
                            ),
                          ),
                          Expanded(
                            child: Divider(thickness: 0.7, color: Colors.grey),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // Social Icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Brand(Brands.facebook),
                          Brand(Brands.twitterx),
                          Brand(Brands.google),
                          Brand(Brands.apple_logo),
                        ],
                      ),

                      const SizedBox(height: 25),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(color: Colors.black45),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.push('/signup');
                            },
                            child: const Text(
                              " Sign Up",
                              style: TextStyle(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
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
