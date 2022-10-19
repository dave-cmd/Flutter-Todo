import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:todoapp/database_helper.dart';
import 'package:todoapp/screens/taskpage.dart';
import 'package:todoapp/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TodoApp'),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Color.fromARGB(255, 241, 237, 241),
          padding: EdgeInsets.symmetric(horizontal: 22, vertical: 32),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Icon(Icons.icecream_rounded),
                    margin: EdgeInsets.only(bottom: 24),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: _dbHelper.getTasks(),
                      builder: (context, snapshot) {
                        return ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) {
                                    return TaskPage(
                                      task: snapshot.data?[index],
                                    );
                                  }),
                                ),
                              ).then((value) => setState(
                                    () {},
                                  ));
                            },
                            child: TaskCardWidget(
                              title: snapshot.data?[index].title,
                              description: snapshot.data?[index].description,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
              Positioned(
                right: 0.0,
                bottom: 0.0,
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskPage(
                                task: null,
                              )),
                    ).then((value) => setState(() {})),
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.purple, Colors.purpleAccent],
                        begin: Alignment(1, 0),
                        end: Alignment(-1, 0),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text('+',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          )),
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
}
