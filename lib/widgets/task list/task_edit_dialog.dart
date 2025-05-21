import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskora/bloc/edit_task_list/edit_task_list_bloc.dart';
import 'package:taskora/bloc/edit_task_list/edit_task_list_event.dart';
import 'package:taskora/bloc/task_edit/task_edit_bloc.dart';
import 'package:taskora/bloc/task_edit/task_edit_event.dart';
import 'package:taskora/model/entity/task.dart';
import 'package:taskora/model/value%20object/description.dart';
import 'package:taskora/model/value%20object/duration.dart';
import 'package:taskora/model/value%20object/name.dart';
import 'package:taskora/model/value%20object/tasktype.dart';

class TaskEditDialog extends StatefulWidget {
  final Task task;

  const TaskEditDialog({super.key, required this.task});

  @override
  State<TaskEditDialog> createState() => _TaskEditDialogState();
}

class _TaskEditDialogState extends State<TaskEditDialog> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController weightController;
  late TextEditingController estimatedDurationController;
  late TextEditingController workloadController;

  late int selectedPriority;
  late TaskType selectedType;
  late DateTime? selectedDeadline;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.task.taskName.toString(),
    );
    descriptionController = TextEditingController(
      text: widget.task.description.value,
    );
    weightController = TextEditingController(
      text: widget.task.weight.toString(),
    );
    estimatedDurationController = TextEditingController(
      text: widget.task.estimatedDuration.toString(),
    );
    workloadController = TextEditingController(
      text: widget.task.workload.toString(),
    );

    selectedPriority = widget.task.priority;
    selectedType = widget.task.type;
    selectedDeadline = widget.task.deadline;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    weightController.dispose();
    estimatedDurationController.dispose();
    workloadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "View Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Task Name"),
              ),

              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
              ),

              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: selectedPriority,
                items: const [
                  DropdownMenuItem(value: 1, child: Text("Low")),
                  DropdownMenuItem(value: 2, child: Text("Medium")),
                  DropdownMenuItem(value: 3, child: Text("High")),
                ],
                onChanged: (val) => setState(() => selectedPriority = val!),
                decoration: const InputDecoration(labelText: "Priority"),
              ),

              const SizedBox(height: 8),
              DropdownButtonFormField<TaskType>(
                value: selectedType,
                items:
                    TaskType.values.map((t) {
                      return DropdownMenuItem(
                        value: t,
                        child: Text(t.toString()),
                      );
                    }).toList(),
                onChanged: (val) => setState(() => selectedType = val!),
                decoration: const InputDecoration(labelText: "Task Type"),
              ),

              const SizedBox(height: 8),
              ListTile(
                title: Text(
                  "Deadline: ${selectedDeadline != null ? selectedDeadline!.toLocal().toString().split(' ')[0] : 'No deadline'}",
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final now = DateTime.now();
                  final safeInitialDate =
                      (selectedDeadline != null &&
                              selectedDeadline!.isAfter(now))
                          ? selectedDeadline!
                          : now;

                  final picked = await showDatePicker(
                    context: context,
                    initialDate: safeInitialDate,
                    firstDate: now.subtract(const Duration(days: 365)),
                    lastDate: now.add(const Duration(days: 365 * 5)),
                  );
                  if (picked != null) {
                    setState(() => selectedDeadline = picked);
                  }
                },
              ),

              const SizedBox(height: 8),
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Weight"),
              ),

              const SizedBox(height: 8),
              TextField(
                controller: estimatedDurationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Estimated Duration (hours)",
                ),
              ),

              const SizedBox(height: 8),
              TextField(
                controller: workloadController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Workload"),
              ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      context.read<TaskEditBloc>().add(
                        RemoveTaskRequest(taskId: widget.task.taskId),
                      );
                      context.read<EditTaskListBloc>().add(
                        RemoveFromTaskList(taskId: widget.task.taskId),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text("remove"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final editedTask = Task(
                        taskId: widget.task.taskId,
                        taskName: Name.fromString(nameController.text),
                        description: Description.fromString(
                          descriptionController.text,
                        ),
                        priority: selectedPriority,
                        type: selectedType,
                        deadline: selectedDeadline,
                        weight: double.tryParse(weightController.text) ?? 1.0,
                        createdAt: widget.task.createdAt,
                        updatedAt: Timestamp.now(),
                        estimatedDuration: DurationValue.fromNumber(
                          double.tryParse(estimatedDurationController.text) ??
                              1.0,
                        ),
                        workload: {
                          DateTime.now(): DurationValue.fromNumber(
                            double.tryParse(workloadController.text) ?? 1.0,
                          ),
                        },
                      );
                      context.read<TaskEditBloc>().add(
                        NewTaskAdded(task: editedTask),
                      );
                      if (!context.mounted) return;
                      Navigator.of(context).pop(editedTask);
                    },
                    child: const Text("Save"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
