// lib/widgets/account_menu.dart
import 'package:flutter/material.dart';

class AccountMenu extends StatelessWidget {
  const AccountMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.account_circle_outlined),
      onSelected: (value) {
        if (value == 'logout') {
          Navigator.pushReplacementNamed(context, '/login/customer');
        } else if (value == 'profile') {
          Navigator.pushNamed(context, '/profile');
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'profile',
          child: ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('View Profile'),
          ),
        ),
        const PopupMenuItem(
          value: 'logout',
          child: ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Log out'),
          ),
        ),
      ],
    );
  }
}
