import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme_controller.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final bool showHome;

  const AppScaffold({
    super.key,
    required this.title,
    required this.child,
    this.showHome = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: showHome
            ? IconButton(
                tooltip: 'На главную',
                icon: const Icon(Icons.home),
                onPressed: () => context.go('/'),
              )
            : null,
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeController,
            builder: (context, mode, _) => IconButton(
              tooltip: themeController.isDark ? 'Светлая тема' : 'Тёмная тема',
              icon: Icon(
                themeController.isDark ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: themeController.toggle,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
