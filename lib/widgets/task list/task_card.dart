import 'package:flutter/material.dart';
import 'package:taskora/model/entity/task.dart';
import 'package:taskora/model/value%20object/card_type.dart';
import 'package:taskora/model/value%20object/summary_type.dart';

class TaskCard extends StatelessWidget {
  final void Function(Task task)? onTap;
  final Task task;
  final CardType cardType;
  final SummaryType? summaryMode;
  const TaskCard({
    super.key,
    required this.task,
    required this.cardType,
    this.onTap,
    this.summaryMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final cardBg = theme.cardColor; // ambil warna card dari theme
    final titleStyle =
        theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold) ??
        TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        );

    final textStyle =
        theme.textTheme.bodyMedium?.copyWith(height: 1.4) ??
        TextStyle(
          fontSize: 14,
          color: theme.textTheme.bodyMedium?.color ?? Colors.grey,
          height: 1.4,
        );

    Widget buildEditButton() {
      return Container(
        height: 20,
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              if (onTap != null) {
                onTap!(task);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.edit_outlined,
                    size: 14,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'view details',
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (cardType == CardType.regular) {
      return SizedBox(
        width: 400,
        height: 200,
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.dividerColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            task.taskName.toString(),
                            style: titleStyle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: theme.colorScheme.primary.withOpacity(0.1),
                          ),
                          child: Text(
                            task.type.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  buildEditButton(),
                ],
              ),
              Divider(color: theme.dividerColor, thickness: 1, height: 24),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            task.deadline?.toString().split(' ')[0] ??
                                'No deadline',
                            style: textStyle,
                            overflow: TextOverflow.fade,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.flag,
                            size: 16,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                          const SizedBox(width: 8),
                          Text('Priority: ${task.priority}', style: textStyle),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (task.description.value.isNotEmpty) ...[
                        Text(
                          task.description.value,
                          style: textStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (cardType == CardType.button) {
      return SizedBox(
        width: 400,
        height: 200,
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.dividerColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                if (onTap != null) {
                  onTap!(task);
                }
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                task.taskName.toString(),
                                style: titleStyle,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.15,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                task.type.toString(),
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      buildEditButton(),
                    ],
                  ),
                  Divider(color: theme.dividerColor, thickness: 1, height: 24),
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: theme.textTheme.bodySmall?.color,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                task.deadline?.toString().split(' ')[0] ??
                                    'No deadline',
                                style: textStyle,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.flag,
                                size: 16,
                                color: theme.textTheme.bodySmall?.color,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Priority: ${task.priority}',
                                style: textStyle,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (task.description.value.isNotEmpty) ...[
                            Text(
                              task.description.value,
                              style: textStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Text("invalid card type");
    }
  }
}
