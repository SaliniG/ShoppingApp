import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/data/cart.dart';
import 'package:shopping_app/resource/provider/auth_provider.dart';
import 'package:shopping_app/resource/provider/order_history_provider.dart';
import 'package:shopping_app/resource/provider/profile_provider.dart';
import 'package:shopping_app/resource/provider/wishlist_provider.dart';
import 'package:shopping_app/utils/colors.dart';
import 'package:shopping_app/utils/styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    final profile = Provider.of<ProfileProvider>(context, listen: false);
    _nameController = TextEditingController(text: profile.name);
    _emailController = TextEditingController(text: profile.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _save() {
    Provider.of<ProfileProvider>(context, listen: false).save(
      newName: _nameController.text,
      newEmail: _emailController.text,
    );
    setState(() => _editing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: headlineTextStyleSemiBold),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(_editing ? Icons.check : Icons.edit_outlined),
            tooltip: _editing ? 'Save' : 'Edit',
            onPressed: () {
              if (_editing) {
                _save();
              } else {
                setState(() => _editing = true);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () => Provider.of<AuthProvider>(context, listen: false).signOut(),
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<ProfileProvider>(
          builder: (context, profile, _) {
            final initials = _initials(profile.name);
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: brandColor,
                    child: Text(
                      initials,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Name & email fields
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _editing
                              ? TextField(
                                  controller: _nameController,
                                  style: headlineTextStyleSemiBold,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    labelText: 'Name',
                                    border: OutlineInputBorder(),
                                  ),
                                )
                              : Text(
                                  profile.name.isEmpty ? 'Your Name' : profile.name,
                                  style: headlineTextStyleSemiBold,
                                ),
                          const SizedBox(height: 8),
                          _editing
                              ? TextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    border: OutlineInputBorder(),
                                  ),
                                )
                              : Text(
                                  profile.email.isEmpty ? 'your@email.com' : profile.email,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Stats
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('My Stats', style: headlineTextStyleSemiBold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Consumer<OrderHistoryProvider>(
                          builder: (_, orders, __) => _StatCard(
                            icon: Icons.receipt_long_outlined,
                            label: 'Orders',
                            value: '${orders.orders.length}',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Consumer<WishlistProvider>(
                          builder: (_, wishlist, __) => _StatCard(
                            icon: Icons.favorite_border,
                            label: 'Wishlist',
                            value: '${wishlist.items.length}',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.shopping_cart_outlined,
                          label: 'In Cart',
                          value: '${Cart().itemsMap.values.fold(0, (s, v) => s + v)}',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _initials(String name) {
    if (name.trim().isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: brandColor, size: 28),
            const SizedBox(height: 6),
            Text(value, style: headlineTextStyleBold),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
