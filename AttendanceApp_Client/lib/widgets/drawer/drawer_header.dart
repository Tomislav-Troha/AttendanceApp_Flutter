import 'package:flutter/material.dart';

class HeaderDrawer extends StatelessWidget {
  const HeaderDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Theme.of(context).colorScheme.primaryContainer,
        Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8),
      ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
      child: Row(
        children: [
          Icon(Icons.sports_gymnastics,
              size: 48, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 18),
          Text(
            "Filter trainings",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.primary),
          )
        ],
      ),
    );
  }
}
