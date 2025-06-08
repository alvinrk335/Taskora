import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/Assets/Font/app_font_style.dart';
import 'package:taskora/bloc/theme/theme_bloc.dart';
import 'package:taskora/bloc/theme/theme_events.dart';
import 'package:taskora/bloc/theme/theme_state.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: AppFontStyle.titleMedium(context)),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Theme", style: AppFontStyle.titleMedium(context)),
            const SizedBox(height: 12),

            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return Column(
                  children: [
                    RadioListTile(
                      title: const Text("Light Theme"),
                      value: "light",
                      groupValue: state.theme.brightness == Brightness.light ? "light" : "dark",
                      onChanged: (_) {
                        context.read<ThemeBloc>().add(SetLightTheme());
                      },
                    ),
                    RadioListTile(
                      title: const Text("Dark Theme"),
                      value: "dark",
                      groupValue: state.theme.brightness == Brightness.light ? "light" : "dark",
                      onChanged: (_) {
                        context.read<ThemeBloc>().add(SetDarkTheme());
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
