import 'package:flutter/material.dart';

class TaskoraBoxDecorationTheme
    extends ThemeExtension<TaskoraBoxDecorationTheme> {
  final BoxDecoration card;
  final BoxDecoration input;
  final BoxDecoration dialog;

  const TaskoraBoxDecorationTheme({
    required this.card,
    required this.input,
    required this.dialog,
  });

  @override
  TaskoraBoxDecorationTheme copyWith({
    BoxDecoration? card,
    BoxDecoration? input,
    BoxDecoration? dialog,
  }) {
    return TaskoraBoxDecorationTheme(
      card: card ?? this.card,
      input: input ?? this.input,
      dialog: dialog ?? this.dialog,
    );
  }

  @override
  TaskoraBoxDecorationTheme lerp(
    ThemeExtension<TaskoraBoxDecorationTheme>? other,
    double t,
  ) {
    if (other is! TaskoraBoxDecorationTheme) return this;
    return TaskoraBoxDecorationTheme(
      card: BoxDecoration.lerp(card, other.card, t) ?? card,
      input: BoxDecoration.lerp(input, other.input, t) ?? input,
      dialog: BoxDecoration.lerp(dialog, other.dialog, t) ?? dialog,
    );
  }
}
