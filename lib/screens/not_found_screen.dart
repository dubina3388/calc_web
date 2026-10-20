import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_scaffold.dart';

class NotFoundScreen extends StatelessWidget {
  final String location;

  const NotFoundScreen({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppScaffold(
      title: 'Страница не найдена',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('404', style: theme.textTheme.displayLarge),
          const SizedBox(height: 8),
          Text(
            'Адрес «$location» не существует',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.home),
            label: const Text('На главную'),
          ),
        ],
      ),
    );
  }
}
