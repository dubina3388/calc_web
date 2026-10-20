import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../logic/result.dart';
import '../widgets/app_scaffold.dart';

class ResultScreen extends StatelessWidget {
  final String title;
  final OpResult result;
  final Map<String, String> rawQuery;
  final String backPath;

  const ResultScreen({
    super.key,
    required this.title,
    required this.result,
    required this.rawQuery,
    required this.backPath,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final params = rawQuery.isEmpty
        ? 'нет'
        : rawQuery.entries.map((e) => '${e.key}=${e.value}').join(', ');
    return AppScaffold(
      title: title,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...switch (result) {
                OpSuccess(:final expression, :final value) => [
                  Icon(Icons.check_circle, color: scheme.primary, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    expression,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    '= $value',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium,
                  ),
                ],
                OpFailure(:final message) => [
                  Icon(Icons.error, color: scheme.error, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Ошибка',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: scheme.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(message, textAlign: TextAlign.center),
                ],
              },
              const SizedBox(height: 16),
              Text(
                'Параметры адреса: $params',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => context.go(backPath),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Вернуться к форме'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
