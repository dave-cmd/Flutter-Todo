import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/database_helper.dart';
import 'package:todoapp/models/todo.dart';

class TaskCardWidget extends StatelessWidget {
  final String? title;
  final String? description;
  const TaskCardWidget({super.key, this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 22,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 32,
        horizontal: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "(Default title)",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color.fromARGB(255, 82, 74, 71)),
          ),
          Padding(
              padding: EdgeInsets.only(
            top: 10,
          )),
          Text(
            description ?? '(Default description)',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Color.fromARGB(255, 73, 64, 60),
            ),
          )
        ],
      ),
    );
  }
}

class TodoWidget extends StatelessWidget {
  final Todo? todo;
  const TodoWidget({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 25,
            height: 25,
            margin: EdgeInsets.only(
              right: 16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: todo?.isDone == 1
                  ? Color.fromARGB(240, 214, 9, 197)
                  : Colors.transparent,
              border: todo?.isDone == 1
                  ? null
                  : Border.all(
                      color: Color.fromARGB(255, 117, 119, 121),
                    ),
            ),
            child: Center(
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
          Text(
            todo?.title ?? '(unnamed todo)',
            style: TextStyle(
              fontWeight: todo?.isDone == 1 ? FontWeight.bold : FontWeight.w500,
              color: todo?.isDone == 1
                  ? Color.fromARGB(255, 33, 20, 88)
                  : Colors.grey,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
