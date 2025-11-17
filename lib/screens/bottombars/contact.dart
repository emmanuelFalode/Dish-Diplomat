import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerCarePage extends StatefulWidget {
  const CustomerCarePage({super.key});

  @override
  State<CustomerCarePage> createState() => _CustomerCarePageState();
}

class _CustomerCarePageState extends State<CustomerCarePage> {
  // Business contact (from your message)
  static const String supportPhone = '09136811948';
  static const String supportAddress = '23a Sylvia Crescent, Anthony, Lagos';

  final _formKey = GlobalKey<FormState>();
  final _orderIdCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  String? _issueType;

  bool _sending = false;

  @override
  void dispose() {
    _orderIdCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  // Helpers
  Future<void> _copy(String text, {String? toast}) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(toast ?? 'Copied')));
  }

  String _waNumber(String local) {
    // Convert Nigerian local (e.g., 0913...) to WhatsApp intl format (234913...)
    final digits = local.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('0')) {
      return '234${digits.substring(1)}';
    }
    if (digits.startsWith('234')) return digits;
    return digits; // fallback
  }

  Future<void> _launchUri(String raw) async {
    final uri = Uri.parse(raw);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open app')));
    }
  }

  Future<void> _send() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _sending = true);

    // TODO: call your backend here (e.g., POST /api/support)
    await Future.delayed(const Duration(milliseconds: 900));

    setState(() => _sending = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thanks! We’ll get back to you shortly.')),
    );
    _messageCtrl.clear();
    _orderIdCtrl.clear();
    _issueType = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Customer Care')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24), // was 16,12,16,16
        children: [
          // Header / Hotline Card
          // Container(
          //   padding: const EdgeInsets.all(18), // was 16
          //   decoration: BoxDecoration(
          //     color: Colors.orange.shade50,
          //     borderRadius: BorderRadius.circular(16),
          //     boxShadow: [
          //       BoxShadow(
          //         color: scheme.primary.withOpacity(0.12),
          //         blurRadius: 12,
          //         offset: const Offset(0, 6),
          //       ),
          //     ],
          //   ),
          //   child: Row(
          //     children: [
          //       CircleAvatar(
          //         radius: 28,
          //         backgroundColor: Colors.orange.shade50,
          //         child: const Icon(
          //           Icons.support_agent,
          //           color: Colors.black,
          //           size: 28,
          //         ),
          //       ),
          //       const SizedBox(width: 16), // was 14
          //       Expanded(
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               'We’re here to help',
          //               style: theme.textTheme.titleMedium?.copyWith(
          //                 color: Colors.black,
          //                 fontWeight: FontWeight.w800,
          //               ),
          //             ),
          //             const SizedBox(height: 8), // was 6
          //             Text(
          //               'Call or message us anytime. Typical response time: under 1 hour.',
          //               style: theme.textTheme.bodySmall?.copyWith(
          //                 color: Colors.black,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Builder(
            builder: (context) {
              final theme = Theme.of(context);
              final scheme = theme.colorScheme;

              return Container(
                padding: const EdgeInsets.all(18), // was 16
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: scheme.primary.withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header row
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.orange.shade50,
                          child: const Icon(
                            Icons.support_agent,
                            color: Colors.black,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Customer Hotline',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        // Copy button (subtle)
                        IconButton(
                          tooltip: 'Copy number',
                          onPressed:
                              () => _copy(supportPhone, toast: 'Number copied'),
                          icon: const Icon(Icons.copy, color: Colors.black),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16), // was 10
                    // Big phone number
                    SelectableText(
                      supportPhone,
                      textAlign: TextAlign.left,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 16), // was 12
                    // Action buttons (equal width)
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () => _launchUri('tel:$supportPhone'),
                            icon: const Icon(Icons.call),
                            label: const Text('Call'),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ), // was 12
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12), // was 10
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed:
                                () => _launchUri(
                                  'https://wa.me/${_waNumber(supportPhone)}',
                                ),
                            icon: const Icon(Icons.chat_outlined),
                            label: const Text('WhatsApp'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ), // was 12
                              side: const BorderSide(color: Colors.orange),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12), // was 8
                    // Tiny helper line
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 8), // was 6
                        Text(
                          'Available 24/7 • Typical response under 1 hour',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 20), // more air before address card

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16), // was 14
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Address', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 10), // was 8
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined),
                      const SizedBox(width: 10), // was 8
                      Expanded(
                        child: Text(
                          supportAddress,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                      const SizedBox(width: 10), // was 8
                      IconButton(
                        tooltip: 'Copy address',
                        onPressed:
                            () =>
                                _copy(supportAddress, toast: 'Address copied'),
                        icon: const Icon(Icons.copy),
                      ),
                      IconButton(
                        tooltip: 'Open in Maps',
                        onPressed:
                            () => _launchUri(
                              'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(supportAddress)}',
                            ),
                        icon: const Icon(Icons.map_outlined),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16), // was 8
          // Quick help
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10), // was 6
            child: Text('Quick help', style: theme.textTheme.titleMedium),
          ),
          Wrap(
            spacing: 10, // was 8
            runSpacing: 10, // was 8
            children: [
              _HelpChip(label: 'Track my order', onTap: () {}),
              _HelpChip(label: 'Cancel an order', onTap: () {}),
              _HelpChip(label: 'Refund policy', onTap: () {}),
              _HelpChip(label: 'Delivery times', onTap: () {}),
              _HelpChip(label: 'Account & profile', onTap: () {}),
            ],
          ),

          const SizedBox(height: 20), // was 16
          // Contact form
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16), // was 14
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Send us a message',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 14), // was 12
                    DropdownButtonFormField<String>(
                      decoration: _dec(context, label: 'Issue type'),
                      value: _issueType,
                      items: const [
                        DropdownMenuItem(
                          value: 'Order issue',
                          child: Text('Order issue'),
                        ),
                        DropdownMenuItem(
                          value: 'Payment',
                          child: Text('Payment'),
                        ),
                        DropdownMenuItem(
                          value: 'Delivery',
                          child: Text('Delivery'),
                        ),
                        DropdownMenuItem(
                          value: 'Account',
                          child: Text('Account'),
                        ),
                        DropdownMenuItem(value: 'Other', child: Text('Other')),
                      ],
                      onChanged: (v) => setState(() => _issueType = v),
                      validator:
                          (v) =>
                              (v == null || v.isEmpty)
                                  ? 'Select an issue'
                                  : null,
                    ),
                    const SizedBox(height: 14), // was 12
                    TextFormField(
                      controller: _orderIdCtrl,
                      decoration: _dec(
                        context,
                        label: 'Order ID (optional)',
                        hint: 'e.g., #DD-2025-0001',
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 14), // was 12
                    TextFormField(
                      controller: _messageCtrl,
                      decoration: _dec(
                        context,
                        label: 'Message',
                        hint:
                            'Describe your issue — add restaurant, items, time, etc.',
                      ),
                      maxLines: 5,
                      validator:
                          (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? 'Please enter a message'
                                  : null,
                    ),
                    const SizedBox(height: 16), // was 14
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.orange.shade50,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _sending ? null : _send,
                      child:
                          _sending
                              ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text('Send'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _dec(
    BuildContext context, {
    required String label,
    String? hint,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: scheme.surface.withOpacity(0.06),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 16, // was 14
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: scheme.primary, width: 1.6),
      ),
    );
  }
}

class _HelpChip extends StatelessWidget {
  const _HelpChip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ), // was 8
        decoration: BoxDecoration(
          color: scheme.surfaceVariant.withOpacity(.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label),
      ),
    );
  }
}
