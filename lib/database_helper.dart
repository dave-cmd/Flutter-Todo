// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/models/todo.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)',
        );
        await db.execute(
          'CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, isDone INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<int?> insertTask(Task task) async {
    Database _db = await database();
    int taskId = 0;
    await _db
        .insert('tasks', task.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      taskId = value;
    });
    return taskId;
  }

  Future<void> insertTodo(Todo todo) async {
    Database _db = await database();
    await _db.insert('todo', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateTaskTitle(int id, String title) async {
    Database _db = await database();
    _db.rawQuery("UPDATE tasks SET title = '$title' WHERE id = '$id'");
  }

  Future<void> updateTaskDescription(int id, String description) async {
    Database _db = await database();
    _db.rawUpdate(
        "UPDATE tasks SET description = '$description' WHERE id = '$id'");
  }

  Future<void> updateTodoIsDone(int id, int isDone) async {
    Database _db = await database();
    _db.rawQuery("UPDATE todo SET isDone = '$isDone' WHERE id = '$id'");
  }

  Future<List<Task>> getTasks() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');
    return List.generate(taskMap.length, (index) {
      return Task(
        id: taskMap[index]['id'],
        title: taskMap[index]['title'],
        description: taskMap[index]['desctiption'],
      );
    });
  }

  Future<void> deleteTask(int taskId) async {
    Database _db = await database();

    await _db.rawDelete("DELETE FROM tasks WHERE id = '$taskId'");
    await _db.rawDelete("DELETE FROM todo WHERE taskId = '$taskId'");
  }

  Future<List<Todo>> getTodos(int taskId) async {
    Database _db = await database();
    List<Map<String, dynamic>> todoMap =
        await _db.rawQuery("SELECT * FROM todo WHERE taskId = $taskId");
    return List.generate(todoMap.length, (index) {
      return Todo(
        id: todoMap[index]['id'],
        isDone: todoMap[index]['isDone'],
        title: todoMap[index]['title'],
        taskId: todoMap[index]['taskId'],
      );
    });
  }
}
