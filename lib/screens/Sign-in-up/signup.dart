import 'package:flutter/material.dart';
import 'package:foodapp/models/dishmodel.dart';
import 'package:foodapp/providers/dish_api.dart';
import 'package:foodapp/reusables/form_text_fields.dart';
import 'package:foodapp/screens/Sign-in-up/widget/custom_scaffold.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'signin.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final email = TextEditingController();
  final phonenumber = TextEditingController();
  final password = TextEditingController();
  final address = TextEditingController();
  bool _isLoading = false; // Loader flag

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
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Please Sign Up to get started",
                  style: TextStyle(color: Colors.white70, fontSize: 15),
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
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: "First Name",
                        controller: firstname,
                        decoration: InputDecoration(
                          labelText: "First Name",
                          hintText: "John",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.person_outlined),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: "This field is required",
                          ),
                        ]),
                      ),
                      const SizedBox(height: 20),
                      CustomFormTextField(
                        name: "Last Name",
                        controller: lastname,
                        label: "Last Name",
                        hint: "Doe",
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 20),
                      FormBuilderTextField(
                        name: "Email",
                        controller: email,
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Enter Email",
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
                      CustomFormTextField(
                        name: "Phone Number",
                        controller: phonenumber,
                        label: "Phone Number",
                        hint: "09134711899",
                        icon: Icons.phone,
                      ),
                      const SizedBox(height: 20),
                      FormBuilderTextField(
                        name: "Address",
                        controller: address,
                        decoration: InputDecoration(
                          labelText: "Address",
                          hintText: "Enter your address",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.location_on_outlined),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: "This field is required",
                          ),
                        ]),
                      ),
                      const SizedBox(height: 20),
                      FormBuilderTextField(
                        name: "Password",
                        controller: password,
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Enter Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.password_outlined),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: "This field is required",
                          ),
                          FormBuilderValidators.minLength(5),
                        ]),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed:
                              _isLoading
                                  ? null
                                  : () async {
                                    setState(() => _isLoading = true);

                                    final user = Dishmodel(
                                      firstName: firstname.text,
                                      lastName: lastname.text,
                                      email: email.text,
                                      phoneNumber: phonenumber.text,
                                      address: address.text,
                                      password: password.text,
                                    );

                                    final result = await ApiService.register(
                                      user.toMap(),
                                    );

                                    setState(() => _isLoading = false);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          result['message'] ??
                                              'An error Occurred',
                                        ),
                                      ),
                                    );

                                    if (result['success'] == true) {
                                      Future.delayed(
                                        const Duration(milliseconds: 500),
                                        () {
                                          context.push(
                                            '/verify_email',
                                            extra: {'email': email.text},
                                          );
                                        },
                                      );
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
                                    "Sign Up",
                                    style: TextStyle(fontSize: 16),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: const [
                          Expanded(
                            child: Divider(thickness: 0.7, color: Colors.grey),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "Sign Up with",
                              style: TextStyle(color: Colors.black45),
                            ),
                          ),
                          Expanded(
                            child: Divider(thickness: 0.7, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
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
                              context.push('/signin');
                            },
                            child: const Text(
                              "Log In",
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
