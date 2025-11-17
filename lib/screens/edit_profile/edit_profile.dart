import 'package:flutter/material.dart';
import 'package:foodapp/core/auth_storage.dart';
import 'package:foodapp/providers/dish_api.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final firstCtrl = TextEditingController();
  final lastCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addrCtrl = TextEditingController();

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadMe();
  }

  Future<void> _loadMe() async {
    final token = await AuthStorage.readToken();
    if (!mounted) return;
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No session token')));
      Navigator.pop(context);
      return;
    }

    setState(() => _loading = true);
    final res = await ApiService.me(token);
    setState(() => _loading = false);

    if (res['success'] == true) {
      final user = res['data'] as Map<String, dynamic>;
      firstCtrl.text = (user['first_name'] ?? '').toString();
      lastCtrl.text = (user['last_name'] ?? '').toString();
      emailCtrl.text = (user['email'] ?? '').toString();
      phoneCtrl.text = (user['phone_number'] ?? '').toString();
      addrCtrl.text = (user['address'] ?? '').toString();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message'] ?? 'Failed to load profile')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final token = await AuthStorage.readToken();
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No session token')));
      return;
    }

    final payload = {
      'first_name': firstCtrl.text.trim(),
      'last_name': lastCtrl.text.trim(),
      'email': emailCtrl.text.trim(),
      'phone_number': phoneCtrl.text.trim(),
      'address': addrCtrl.text.trim().isEmpty ? null : addrCtrl.text.trim(),
    }..removeWhere((k, v) => v == null || (v is String && v.isEmpty));

    setState(() => _saving = true);
    final res = await ApiService.updateProfile(payload, token);
    setState(() => _saving = false);

    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message'] ?? 'Profile updated')),
      );
      if (mounted) Navigator.pop(context, res['data']);
    } else {
      final msg = res['message'] ?? 'Update failed';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  void dispose() {
    firstCtrl.dispose();
    lastCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    addrCtrl.dispose();
    super.dispose();
  }

  InputDecoration _dec(
    BuildContext context, {
    required String label,
    String? hint,
    IconData? icon,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon == null ? null : Icon(icon),
      filled: true,
      fillColor: scheme.surface.withOpacity(0.06),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: theme.dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: theme.dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.primary, width: 1.6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        elevation: 0.4,
        surfaceTintColor: theme.scaffoldBackgroundColor,
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  // Scrollable content
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: scheme.primary.withOpacity(0.18),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 34,
                                backgroundColor: scheme.onPrimaryContainer
                                    .withOpacity(.08),
                                child: Text(
                                  _initials(firstCtrl.text, lastCtrl.text),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 22,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _displayName(
                                        firstCtrl.text,
                                        lastCtrl.text,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            color: Colors.black,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.email_outlined,
                                          size: 16,
                                          color: Colors.black,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            emailCtrl.text.isEmpty
                                                ? '—'
                                                : emailCtrl.text,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Form card
                        Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          surfaceTintColor: theme.scaffoldBackgroundColor,
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: firstCtrl,
                                    decoration: _dec(
                                      context,
                                      label: 'First Name',
                                      hint: 'John',
                                      icon: Icons.person_outline,
                                    ),
                                    validator:
                                        (v) =>
                                            (v == null || v.trim().isEmpty)
                                                ? 'First name is required'
                                                : null,
                                    textInputAction: TextInputAction.next,
                                  ),
                                  const SizedBox(height: 14),

                                  TextFormField(
                                    controller: lastCtrl,
                                    decoration: _dec(
                                      context,
                                      label: 'Last Name',
                                      hint: 'Doe',
                                      icon: Icons.person,
                                    ),
                                    validator:
                                        (v) =>
                                            (v == null || v.trim().isEmpty)
                                                ? 'Last name is required'
                                                : null,
                                    textInputAction: TextInputAction.next,
                                  ),
                                  const SizedBox(height: 14),

                                  TextFormField(
                                    controller: emailCtrl,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: _dec(
                                      context,
                                      label: 'Email',
                                      hint: 'you@example.com',
                                      icon: Icons.alternate_email,
                                    ),
                                    validator: (v) {
                                      final val = v?.trim() ?? '';
                                      if (val.isEmpty)
                                        return 'Email is required';
                                      final ok = RegExp(
                                        r'^[^@]+@[^@]+\.[^@]+$',
                                      ).hasMatch(val);
                                      return ok ? null : 'Enter a valid email';
                                    },
                                    textInputAction: TextInputAction.next,
                                  ),
                                  const SizedBox(height: 14),

                                  TextFormField(
                                    controller: phoneCtrl,
                                    keyboardType: TextInputType.phone,
                                    decoration: _dec(
                                      context,
                                      label: 'Phone Number',
                                      hint: '0913 471 1899',
                                      icon: Icons.phone_outlined,
                                    ),
                                    textInputAction: TextInputAction.next,
                                  ),
                                  const SizedBox(height: 14),

                                  TextFormField(
                                    controller: addrCtrl,
                                    decoration: _dec(
                                      context,
                                      label: 'Address',
                                      hint: 'Street, City',
                                      icon: Icons.location_on_outlined,
                                    ),
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),
                      ],
                    ),
                  ),

                  // Pinned Save button
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16 + MediaQuery.of(context).padding.bottom,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade50,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                      ),
                      child:
                          _saving
                              ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text(
                                'Save Changes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
    );
  }

  String _initials(String first, String last) {
    final f = first.trim().isNotEmpty ? first.trim()[0] : '';
    final l = last.trim().isNotEmpty ? last.trim()[0] : '';
    final s = (f + l).toUpperCase();
    return s.isEmpty ? 'U' : s;
  }

  String _displayName(String first, String last) {
    final fn = first.trim(), ln = last.trim();
    if (fn.isEmpty && ln.isEmpty) return 'Your name';
    if (fn.isEmpty) return ln;
    if (ln.isEmpty) return fn;
    return '$fn $ln';
  }
}
