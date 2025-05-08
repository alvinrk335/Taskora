import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:taskora/bloc/initial_task/task_add_bloc.dart';
import 'package:taskora/bloc/initial_task/task_add_event.dart';
import 'package:taskora/bloc/task_priority/task_priority_bloc.dart';
import 'package:taskora/bloc/task_priority/task_priority_event.dart';
import 'package:taskora/bloc/task_priority/task_priority_state.dart';
import 'package:taskora/bloc/task_type/task_type_bloc.dart';
import 'package:taskora/bloc/task_type/task_type_event.dart';
import 'package:taskora/bloc/task_type/task_type_state.dart';
import 'package:taskora/model/description.dart';
import 'package:taskora/model/initial_task.dart';
import 'package:taskora/model/name.dart';
import 'package:taskora/model/tasktype.dart';
import 'package:taskora/services/id_generator.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final dateController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    } else {
      dateController.clear();
    }
  }

  int prioToNumber(String str) {
    switch (str.toLowerCase()) {
      case "low":
        return 1;
      case "medium":
        return 2;
      case "high":
        return 3;
      default:
        return 0;
    }
  }

  String prioFromNumber(int x) {
    switch (x) {
      case 1:
        return "LOW";
      case 2:
        return "MEDIUM";
      case 3:
        return "HIGH";
      default:
        return "invalid";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(color: Colors.black.withAlpha(0)),
        ),
        AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          scrollable: true,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Enter task name"),
              TextField(controller: nameController),
              const SizedBox(height: 20),
              const Text("Enter deadline (optional)"),
              TextField(
                controller: dateController,
                readOnly: true,
                onTap: _selectDate,
                decoration: const InputDecoration(
                  labelText: "Deadline",
                  hintText: "Leave blank if no deadline",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Choose task type"),
              BlocBuilder<TaskTypeBloc, TaskTypeState>(
                builder: (context, state) {
                  return DropdownButton<TaskType>(
                    value: state.type,
                    items:
                        TaskType.values.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type.toString().split('.').last),
                          );
                        }).toList(),
                    onChanged: (newType) {
                      context.read<TaskTypeBloc>().add(
                        TypeChanged(type: newType),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text("Enter task description"),
              TextField(controller: descController),
              const SizedBox(height: 20),
              const Text("Enter Task Priority"),
              BlocBuilder<TaskPriorityBloc, TaskPriorityState>(
                builder: (context, state) {
                  return DropdownButton<String>(
                    value: prioFromNumber(state.priority),
                    items:
                        ["LOW", "MEDIUM", "HIGH"].map((priority) {
                          return DropdownMenuItem(
                            value: priority,
                            child: Text(priority),
                          );
                        }).toList(),
                    onChanged: (newPriority) {
                      context.read<TaskPriorityBloc>().add(
                        PriorityChanged(priority: prioToNumber(newPriority!)),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final priority =
                    context.read<TaskPriorityBloc>().state.priority;
                final type = context.read<TaskTypeBloc>().state.type;
                final id = await generateId("task");
                if (!mounted) return;
                final newTask = InitialTask(
                  id,
                  Name(nameController.text),
                  Description(descController.text),
                  priority,
                  type,
                  deadline: dateController.text.isEmpty ? null : DateTime.parse(dateController.text)
                );

                if (mounted) {
                  context.read<TaskAddBloc>().add(TaskAdded(task: newTask));
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        ),
      ],
    );
  }
}
