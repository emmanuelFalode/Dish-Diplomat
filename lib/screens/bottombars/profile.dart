import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodapp/core/auth_storage.dart';
import 'package:foodapp/providers/dish_api.dart';
import 'package:foodapp/providers/me_provider.dart';
import 'package:foodapp/providers/theme_provider.dart';
import 'package:go_router/go_router.dart';

import 'package:foodapp/providers/profile_provider.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  bool _pushNotifications = true;
  bool _emailUpdates = false;

  @override
  Widget build(BuildContext context) {
    final profiler = ref.watch(profileProvider);
    final meAsync = ref.watch(meProvider);
    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), elevation: 0.5),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: meAsync.when(
                data: (me) {
                  final first = (me['first_name'] ?? '').toString().trim();
                  final last = (me['last_name'] ?? '').toString().trim();
                  final name = [
                    first,
                    last,
                  ].where((s) => s.isNotEmpty).join(' ');
                  final email = (me['email'] ?? '').toString();

                  return _ProfileHeader(
                    name: name.isEmpty ? 'User' : name,
                    email: email.isEmpty ? '—' : email,
                    avatarAsset: 'assets/images/avi.avif',
                    onEdit: () async {
                      await context.push("/edit_profile");
                      ref.invalidate(meProvider);
                    },
                  );
                },
                loading:
                    () => _ProfileHeader(
                      name: 'Loading…',
                      email: 'Fetching profile',
                      avatarAsset: 'assets/images/avi.avif',
                      onEdit: () {},
                    ),
                error:
                    (e, _) => _ProfileHeader(
                      name: '—',
                      email: e.toString(),
                      avatarAsset: 'assets/images/avi.avif',
                      onEdit: () {},
                    ),
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const _SectionTitle('Account'),
                  _SettingTile(
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    subtitle: 'Name, phone number, address',
                    onTap: () {
                      context.push("/edit_profile");
                    },
                  ),
                  _SettingTile(
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    subtitle: 'Update your password',
                    onTap: () {
                      context.push('/change_password');
                    },
                  ),
                  _SettingTile(
                    icon: Icons.credit_card_outlined,
                    title: 'Payment Methods',
                    subtitle: 'Cards, wallets',
                    onTap: () {},
                  ),

                  const SizedBox(height: 12),
                  const _SectionTitle('Preferences'),
                  SwitchListTile.adaptive(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    secondary: const Icon(Icons.notifications_outlined),
                    title: const Text('Push Notifications'),
                    subtitle: const Text('Order status, promotions'),
                    value: _pushNotifications,
                    onChanged:
                        (val) => setState(() => _pushNotifications = val),
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    secondary: const Icon(Icons.email_outlined),
                    title: const Text('Email Updates'),
                    subtitle: const Text('News, deals, and tips'),
                    value: _emailUpdates,
                    onChanged: (val) => setState(() => _emailUpdates = val),
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    secondary: const Icon(Icons.dark_mode_outlined),
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Reduce eye strain'),
                    value: ref.watch(themeNotifierProvider),
                    onChanged:
                        (val) => ref
                            .read(themeNotifierProvider.notifier)
                            .toggle(val),
                  ),

                  const SizedBox(height: 12),
                  const _SectionTitle('Support'),
                  _SettingTile(
                    icon: Icons.help_outline,
                    title: 'Help Center',
                    subtitle: 'FAQs and support',
                    onTap: () {},
                  ),
                  _SettingTile(
                    icon: Icons.info_outline,
                    title: 'About DishDiplomat',
                    subtitle: 'Version, licenses',
                    onTap: () {
                      // context.go('/about');
                    },
                  ),

                  const SizedBox(height: 16),
                  // Danger zone
                  _DangerTile(
                    title: 'Log Out',
                    onTap: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder:
                            (_) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                      );

                      try {
                        final token = await AuthStorage.readToken();
                        if (token == null || token.isEmpty) {
                          if (context.mounted) {
                            Navigator.of(context).pop(); // close loader
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No session token found'),
                              ),
                            );
                            context.go('/signin');
                          }
                          return;
                        }

                        final res = await ApiService.logout(token);

                        await AuthStorage.clearToken();

                        if (context.mounted) {
                          Navigator.of(context).pop(); // close loader
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(res['message'] ?? 'Logged out'),
                            ),
                          );
                          context.go('/signin');
                        }
                      } catch (e) {
                        if (context.mounted) {
                          Navigator.of(context).pop(); // close loader
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Logout error: $e')),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.avatarAsset,
    required this.onEdit,
  });

  final String name;
  final String email;
  final String avatarAsset;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundImage: AssetImage(avatarAsset),
            onBackgroundImageError: (_, __) {},
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(color: Colors.black, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 6),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.orange),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: subtitle == null ? null : Text(subtitle!),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _DangerTile extends StatelessWidget {
  const _DangerTile({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.logout, color: Colors.red.shade700),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.red.shade700,
            fontWeight: FontWeight.w700,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
