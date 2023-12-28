import 'package:flutter/material.dart';

import 'drawer_header.dart';
import 'drawer_list.dart';

class DrawerMain extends StatelessWidget {
  const DrawerMain({super.key, required this.onSelectedScreen});

  final void Function(String identifier) onSelectedScreen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const HeaderDrawer(),
          DrawerList(onSelectedScreen: onSelectedScreen)
        ],
      ),
    );
  }
}
