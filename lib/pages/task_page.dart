import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/available_days/available_days_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_state.dart';
import 'package:taskora/bloc/edit_task_list/edit_task_list_bloc.dart';
import 'package:taskora/bloc/initial_task/task_add_bloc.dart';
import 'package:taskora/bloc/prompt_textfield/prompt_textfield_bloc.dart';
import 'package:taskora/bloc/task_edit/task_edit_bloc.dart';
import 'package:taskora/bloc/task_preview/task_preview_bloc.dart';
import 'package:taskora/model/entity/schedule.dart';
import 'package:taskora/model/value%20object/card_type.dart';
import 'package:taskora/model/value%20object/summary_type.dart';
import 'package:taskora/pages/add_days_page.dart';
import 'package:taskora/pages/edit_page.dart';
import 'package:taskora/widgets/task%20list/task_info_dialog.dart';
// import 'package:taskora/bloc/task_list/task_page_bloc.dart';
import 'package:taskora/widgets/task%20list/task_list.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<CalendarBloc>().state;

    Schedule? schedule;
    if (state is CalendarLoaded) {
      schedule = state.schedule;
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            schedule!.isEmpty()
                ? Align(
                  alignment: Alignment.topCenter,
                  child: ElevatedButton(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddDaysPage(),
                          ),
                        ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Icon(Icons.task), Text("create new schedule")],
                    ),
                  ),
                )
                : Align(
                  alignment: Alignment.topCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => MultiBlocProvider(
                                providers: [
                                  BlocProvider(create: (_) => TaskEditBloc()),
                                  BlocProvider(create: (_) => TaskAddBloc()),

                                  BlocProvider(
                                    create: (_) => PromptTextfieldBloc(),
                                  ),
                                  BlocProvider(
                                    create: (_) => EditTaskListBloc(),
                                  ),
                                  BlocProvider(
                                    create: (_) => TaskPreviewBloc(),
                                  ),
                                  BlocProvider.value(
                                    value: context.read<AvailableDaysBloc>(),
                                  ),
                                  BlocProvider.value(
                                    value: context.read<CalendarBloc>(),
                                  ),
                                ],
                                child: EditPage(),
                              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [Icon(Icons.settings), Text("Edit task")],
                    ),
                  ),
                ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TaskList(
                cardType: CardType.button,
                summaryType: SummaryType.compact,
                showAll: true,
                onTap: (task) {
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder:
                        (ctx) => TaskInfoDialog(
                          task: task,
                          summaryType: SummaryType.full,
                        ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
