import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/task_preview/task_preview_bloc.dart';
import 'package:taskora/model/entity/schedule.dart';
import 'package:taskora/model/entity/task.dart';
import 'package:taskora/model/value%20object/card_type.dart';
import 'package:taskora/model/value%20object/summary_type.dart';
import 'package:taskora/repository/schedule_repository.dart';
import 'package:taskora/widgets/task%20list/task_card.dart';
import 'package:taskora/widgets/task%20list/task_info_dialog.dart';

class TaskPreviewList extends StatelessWidget {
  final repo = ScheduleRepository();
  TaskPreviewList({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<TaskPreviewBloc>().state;
    Schedule schedule = state.schedule;
    List<Task> tasks = schedule.getTasks;
    return Wrap(
      children: [
        for (Task task in tasks)
          TaskCard(
            task: task,
            cardType: CardType.button,
            summaryMode: SummaryType.compact,
            onTap: (task) {
              showDialog(
                context: context,
                builder:
                    (_) => TaskInfoDialog(
                      task: task,
                      summaryType: SummaryType.full,
                    ),
              );
            },
          ),
      ],
    );
  }
}
