import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/available_days/available_days_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_bloc.dart';
import 'package:taskora/bloc/calendar/calendar_state.dart';
import 'package:taskora/bloc/edit_task_list/edit_task_list_bloc.dart';
import 'package:taskora/bloc/edit_task_list/edit_task_list_state.dart';
import 'package:taskora/bloc/initial_task/task_add_bloc.dart';
import 'package:taskora/bloc/prompt_textfield/prompt_textfield_bloc.dart';
import 'package:taskora/bloc/prompt_textfield/prompt_textfield_event.dart';
import 'package:taskora/bloc/prompt_textfield/prompt_textfield_state.dart';
import 'package:taskora/bloc/task_edit/task_edit_bloc.dart';
import 'package:taskora/bloc/task_edit/task_edit_event.dart';
import 'package:taskora/bloc/task_preview/task_preview_bloc.dart';
import 'package:taskora/bloc/task_preview/task_preview_event.dart';
import 'package:taskora/bloc/task_priority/task_priority_bloc.dart';
import 'package:taskora/bloc/task_type/task_type_bloc.dart';
import 'package:taskora/model/entity/initial_task.dart';
import 'package:taskora/model/entity/schedule.dart';
import 'package:taskora/model/entity/task.dart';
import 'package:taskora/model/value object/card_type.dart';
import 'package:taskora/model/value%20object/summary_type.dart';
import 'package:taskora/pages/task_preview.dart';
import 'package:taskora/services/optimizer.dart';
import 'package:taskora/widgets/add schedule/initial_task_list.dart';
import 'package:taskora/widgets/add%20schedule/add_task_body.dart';
import 'package:taskora/widgets/task list/task_edit_dialog.dart';
import 'package:taskora/widgets/task%20list/edit_task_list.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final TextEditingController promptController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadExistingTask(context);
    });
  }

  @override
  void dispose() {
    promptController.dispose();
    super.dispose();
  }

  Widget buildPromptField(
    BuildContext promptContext,
    PromptTextfieldState promptState,
  ) {
    if (promptState is PromptTextFieldClosed) {
      return ElevatedButton(
        onPressed:
            () => promptContext.read<PromptTextfieldBloc>().add(
              OpenPromptTextfield(),
            ),
        child: Text("use ai to edit"),
      );
    } else if (promptState is PromptTextfieldOpened) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: promptController,
              maxLines: null,
              minLines: 5,
              decoration: InputDecoration(
                hintText: "e.g. i cannot do tasks in monday next week",
                filled: true,
                fillColor: Colors.black87,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.black87),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
              ),
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    promptContext.read<PromptTextfieldBloc>().add(
                      SavePromptTextfield(prompt: promptController.text),
                    );
                  },
                  child: Text("submit"),
                ),
              ],
            ),
          ],
        ),
      );
    } else if (promptState is PromptTextfieldSaved) {
      return Column(
        children: [
          ElevatedButton(
            onPressed:
                () => promptContext.read<PromptTextfieldBloc>().add(
                  OpenPromptTextfield(),
                ),
            child: Text("edit prompt"),
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                promptState.prompt,
                style: TextStyle(
                  color:
                      promptState.prompt != ""
                          ? Colors.blueGrey[400]
                          : Colors.black,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Future<Schedule> reOptimize(BuildContext context) async {
    List<InitialTask> listOfTask = [];
    final editedTasks = context.read<TaskEditBloc>().state.tasks;
    final List<InitialTask> newTasks = context.read<TaskAddBloc>().state.tasks;
    final requestPromptState = context.read<PromptTextfieldBloc>().state;
    final scheduleState = context.read<CalendarBloc>().state;
    String scheduleId = "";
    if (scheduleState is CalendarLoaded) {
      scheduleId = scheduleState.schedule.getScheduleId;
    }

    String requestPrompt;
    if (requestPromptState is PromptTextfieldSaved) {
      requestPrompt = requestPromptState.prompt;
    } else {
      requestPrompt = "";
    }

    for (Task task in editedTasks) {
      listOfTask.add(
        InitialTask(
          task.taskId,
          task.taskName,
          task.description,
          task.priority,
          task.type,
          deadline: task.deadline,
        ),
      );
    }

    for (InitialTask task in newTasks) {
      listOfTask.add(task);
    }
    final availableDaysState = context.read<AvailableDaysBloc>().state;
    final Map<String, double> workingHours = availableDaysState.weeklyWorkHours;
    final List<DateTime> excludedDates = availableDaysState.dates;
    final optimizer = Optimizer(
      tasks: listOfTask,
      workingHours: workingHours,
      excludedDates: excludedDates,
      request: requestPrompt,
      newSchedule: false,
      scheduleId: scheduleId,
    );

    Schedule schedule = await optimizer.optimize();
    return schedule;
  }

  Future<void> reOptimizeAndAdd(BuildContext context) async {
    Schedule schedule = await reOptimize(context);
    if (!context.mounted) return;
    context.read<TaskPreviewBloc>().add(AddTaskToPreview(schedule: schedule));
  }

  void loadExistingTask(BuildContext context) {
    final state = context.read<CalendarBloc>().state;
    if (state is CalendarLoaded) {
      List<Task> tasks = state.schedule.getTasks;

      for (Task task in tasks) {
        context.read<TaskEditBloc>().add(NewTaskAdded(task: task));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top controls (AI prompt + Add task)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: BlocBuilder<PromptTextfieldBloc, PromptTextfieldState>(
                    builder: (promptContext, promptState) {
                      return buildPromptField(promptContext, promptState);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (dialogContext) => MultiBlocProvider(
                            providers: [
                              BlocProvider(create: (_) => TaskTypeBloc()),
                              BlocProvider(create: (_) => TaskPriorityBloc()),
                              BlocProvider.value(
                                value: context.read<TaskAddBloc>(),
                              ),
                              BlocProvider.value(
                                value: context.read<TaskEditBloc>(),
                              ),
                            ],
                            child: AddOrEditTaskDialog(),
                          ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 4),
                      Text("add new task"),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Task List
            Text(
              "Existing Tasks",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            BlocBuilder<EditTaskListBloc, EditTaskListState>(
              builder: (editTaskListContext, editTaskListState) {
                return EditTaskList(
                  showAll: true,
                  cardType: CardType.button,
                  summaryType: SummaryType.compact,
                  onTap: (task) {
                    showDialog(
                      context: context,
                      builder:
                          (_) => MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                value: context.read<TaskEditBloc>(),
                              ),
                              BlocProvider.value(
                                value: context.read<EditTaskListBloc>(),
                              ),
                            ],
                            child: TaskEditDialog(task: task),
                          ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 32),
            Text("New Tasks", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            InitialTaskList(),

            const SizedBox(height: 40),

            // Re-optimize button
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => Center(child: CircularProgressIndicator()),
                  );
                  await reOptimizeAndAdd(context);
                  if (context.mounted) {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => BlocProvider.value(
                              value: context.read<TaskPreviewBloc>(),
                              child: TaskPreview(),
                            ),
                      ),
                    );
                  }
                },
                child: Text("re-optimize"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
