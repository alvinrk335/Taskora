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
    if (cardType == CardType.regular) {
      return SizedBox(
        width: 200,
        height: 200,
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Colors.black),
          ),
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                width: 150,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    task.taskName.toString(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              Divider(),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    width: 150,
                    child: Text(
                      summaryMode == SummaryType.compact
                          ? task.toShortSummaryStringS()
                          : task.toSummaryString(),
                      style: TextStyle(fontSize: 14),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    // button card
    else if (cardType == CardType.button) {
      return SizedBox(
        width: 200,
        height: 200,
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Colors.black),
          ),
          color: Colors.white,
          child: InkWell(
            onTap: () {
              if (onTap != null) {
                onTap!(task);
              }
            },
            child: Column(
              children: [
                SizedBox(
                  width: 150,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      task.taskName.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
                Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Text(
                        summaryMode == SummaryType.compact
                            ? task.toShortSummaryStringS()
                            : task.toSummaryString(),
                        style: TextStyle(fontSize: 14),
                        softWrap: true,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    //else
    else {
      return Text("invalid card type");
    }
  }
}
