import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:todoapp/database_helper.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/models/todo.dart';
import 'package:todoapp/widgets.dart';

class TaskPage extends StatefulWidget {
  final Task? task;
  const TaskPage({super.key, required this.task});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  String? _taskTitle;
  String? _taskDescription;
  int? _taskId;
  FocusNode? _titleFocus;
  FocusNode? _descriptionFocus;
  FocusNode? _taskFocus;

  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    if (widget.task != null) {
      _taskTitle = widget.task?.title;
      _taskDescription = widget.task?.description;
      _taskId = widget.task?.id;
      _titleFocus = FocusNode();
      _descriptionFocus = FocusNode();
      _taskFocus = FocusNode();
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleFocus?.dispose();
    _descriptionFocus?.dispose();
    _taskFocus?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 24.0,
                      bottom: 6.0,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Padding(
                              padding: EdgeInsets.all(22),
                              child: Icon(Icons.arrow_back)),
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: _titleFocus,
                            onSubmitted: (value) async {
                              if (value != "") {
                                if (widget.task == null) {
                                  DatabaseHelper _dbHelper = DatabaseHelper();
                                  Task _newtTask = Task(title: value);

                                  _taskId =
                                      await _dbHelper.insertTask(_newtTask);
                                  print(
                                      'New task created successfully...$_taskId......');
                                } else {
                                  await _dbHelper.updateTaskTitle(
                                      _taskId!, value);

                                  print('Task title updated ...');
                                }

                                _descriptionFocus?.requestFocus();
                              }
                            },
                            controller: TextEditingController()
                              ..text = _taskTitle ?? "",
                            decoration: InputDecoration(
                              hintText: 'Enter your task...',
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0XFF211511),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 12.0,
                    ),
                    child: TextField(
                      focusNode: _descriptionFocus,
                      onSubmitted: (value) async {
                        if (value != "") {
                          if (_taskId != null) {
                            await _dbHelper.updateTaskDescription(
                                _taskId!, value);

                            print("Task.description updated with $value ");
                          }
                        }
                        _taskFocus?.requestFocus();
                      },
                      controller: TextEditingController()
                        ..text = _taskDescription ?? "",
                      decoration: InputDecoration(
                        hintText: 'Enter the task description...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: _dbHelper.getTodos(_taskId ?? -1),
                    builder: (context, snapshot) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                if (snapshot.data?[index].isDone == 1) {
                                  await _dbHelper.updateTodoIsDone(
                                    snapshot.data![index].id!,
                                    0,
                                  );
                                } else {
                                  await _dbHelper.updateTodoIsDone(
                                    snapshot.data![index].id!,
                                    1,
                                  );
                                }
                                setState(() {});
                              },
                              child: TodoWidget(todo: snapshot.data?[index]),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  Container(
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
                            color: Color.fromARGB(240, 214, 9, 197),
                            border: Border.all(
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
                        Expanded(
                          child: TextField(
                            focusNode: _taskFocus,
                            onSubmitted: (value) async {
                              if (value != '') {
                                Todo _newTodo = Todo(
                                  taskId: _taskId,
                                  title: value,
                                  isDone: 0,
                                );

                                await _dbHelper.insertTodo(_newTodo);
                                setState(() {});
                                print('Todo record created...');
                              }
                            },
                            controller: TextEditingController()..text = "",
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Todo title...'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 24.0,
                child: InkWell(
                  onTap: () async {
                    await _dbHelper.deleteTask(_taskId!);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
