import 'package:flutter/material.dart';
import 'phone_signin_screen.dart';
import 'groups_list_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock: always show GroupsListScreen
    return GroupsListScreen();
  }
}
      return const PhoneSignInScreen();
    }
    return GroupsListScreen();
  }
}
