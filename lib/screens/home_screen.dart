import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Главная',
      showHome: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Калькулятор и конвертер валют',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () => context.go('/calculator'),
            icon: const Icon(Icons.calculate),
            label: const Text('Калькулятор'),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => context.go('/converter'),
            icon: const Icon(Icons.currency_exchange),
            label: const Text('Конвертер валют'),
          ),
        ],
      ),
    );
  }
}
