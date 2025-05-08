import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/cubit/theme/theme_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return SwitchListTile(
              title: const Text('Dark Mode'),
              value: state.themeMode == ThemeMode.dark,
              onChanged: (value) {
                final newTheme = value ? ThemeMode.dark : ThemeMode.light;
                context.read<ThemeCubit>().changeTheme(newTheme);
              },
            );
          },
        ),
      ),
    );
  }
}
