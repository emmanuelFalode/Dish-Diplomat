import 'package:flutter/material.dart';
import 'package:foodapp/core/auth_storage.dart';
import 'package:foodapp/providers/dish_api.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final currentCtrl = TextEditingController();
  final newCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  bool _saving = false;
  bool _showCurrent = false, _showNew = false, _showConfirm = false;

  @override
  void dispose() {
    currentCtrl.dispose();
    newCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final token = await AuthStorage.readToken();
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No session token')));
      return;
    }

    setState(() => _saving = true);
    final res = await ApiService.changePassword(
      currentCtrl.text,
      newCtrl.text,
      token,
    );
    setState(() => _saving = false);

    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message'] ?? 'Password updated')),
      );
      if (mounted) Navigator.pop(context);
    } else {
      final msg = res['message'] ?? 'Update failed';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  InputDecoration _dec(
    BuildContext context,
    String label, {
    bool togglable = false,
    bool visible = false,
    VoidCallback? onToggle,
  }) {
    final theme = Theme.of(context);
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: theme.colorScheme.surface.withOpacity(0.06),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: theme.dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.6),
      ),
      suffixIcon:
          togglable
              ? IconButton(
                icon: Icon(visible ? Icons.visibility_off : Icons.visibility),
                onPressed: onToggle,
              )
              : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: currentCtrl,
                        obscureText: !_showCurrent,
                        decoration: _dec(
                          context,
                          'Current Password',
                          togglable: true,
                          visible: _showCurrent,
                          onToggle:
                              () =>
                                  setState(() => _showCurrent = !_showCurrent),
                        ),
                        validator:
                            (v) =>
                                (v == null || v.isEmpty)
                                    ? 'Enter your current password'
                                    : null,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: newCtrl,
                        obscureText: !_showNew,
                        decoration: _dec(
                          context,
                          'New Password',
                          togglable: true,
                          visible: _showNew,
                          onToggle: () => setState(() => _showNew = !_showNew),
                        ),
                        validator: (v) {
                          final s = v ?? '';
                          if (s.length < 8) return 'Minimum 8 characters';
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: confirmCtrl,
                        obscureText: !_showConfirm,
                        decoration: _dec(
                          context,
                          'Confirm New Password',
                          togglable: true,
                          visible: _showConfirm,
                          onToggle:
                              () =>
                                  setState(() => _showConfirm = !_showConfirm),
                        ),
                        validator:
                            (v) =>
                                (v ?? '') == newCtrl.text
                                    ? null
                                    : 'Passwords do not match',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _saving ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade50,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child:
                  _saving
                      ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Text(
                        'Update Password',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
