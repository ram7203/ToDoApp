// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:todo/services/database.dart';
import 'package:vibration/vibration.dart';

class HomeScreen extends StatefulWidget {
  String email;
  HomeScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool Personal = true, College = false, Office = false;
  bool suggest = false;
  TextEditingController task = TextEditingController();
  List<Map<dynamic, dynamic>> tasks = [];

  getOnTheLoad() async {
    setState(() {
      tasks = [];
    });
    tasks = await DatabaseService().fetchTasks(Personal
        ? 'personalTasks'
        : College
            ? 'collegeTasks'
            : 'officeTasks');
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOnTheLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          try {
            Vibration.vibrate(duration: 100);
          } catch (e) {
            print("Vibrator error");
          }
          openBox();
        },
        backgroundColor: Colors.greenAccent.shade400,
        child: const Icon(
          Icons.add,
          size: 35,
          color: Colors.white,
        ),
      ),
      body: Container(
          padding: const EdgeInsets.only(top: 70, left: 20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.white38,
                Colors.white12,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: const Text("Hello,",
                    style: TextStyle(fontSize: 30, color: Colors.black)),
              ),
              const SizedBox(height: 10),
              Container(
                child: Text(widget.email,
                    style: const TextStyle(fontSize: 15, color: Colors.black)),
              ),
              const SizedBox(height: 10),
              Container(
                child: const Text("Welcome to the Todo App!",
                    style: TextStyle(fontSize: 18, color: Colors.black38)),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Personal
                      ? Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.greenAccent.shade200,
                                borderRadius: BorderRadius.circular(20)),
                            child: const Text(
                              "Personal",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            try {
                              Vibration.vibrate(duration: 100);
                            } catch (e) {
                              print("Vibrator error");
                            }
                            setState(() async {
                              Personal = true;
                              College = false;
                              Office = false;
                              await getOnTheLoad();
                            });
                          },
                          child: const Text(
                            "Personal",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                  College
                      ? Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.greenAccent.shade200,
                                borderRadius: BorderRadius.circular(20)),
                            child: const Text(
                              "College",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            try {
                              Vibration.vibrate(duration: 100);
                            } catch (e) {
                              print("Vibrator error");
                            }
                            setState(() async {
                              Personal = false;
                              College = true;
                              Office = false;
                              await getOnTheLoad();
                            });
                          },
                          child: const Text(
                            "College",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                  Office
                      ? Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.greenAccent.shade200,
                                borderRadius: BorderRadius.circular(20)),
                            child: const Text(
                              "Office",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            try {
                              Vibration.vibrate(duration: 100);
                            } catch (e) {
                              print("Vibrator error");
                            }
                            setState(() async {
                              Personal = false;
                              College = false;
                              Office = true;
                              await getOnTheLoad();
                            });
                          },
                          child: const Text(
                            "Office",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: (tasks.isNotEmpty)
                    ? ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          String title = tasks[index]['task'];
                          bool ticked = tasks[index]['Yes'];

                          return CheckboxListTile(
                            activeColor: Colors.greenAccent.shade400,
                            title: Text(title),
                            secondary: GestureDetector(
                              onTap: () async {
                                try {
                                  Vibration.vibrate(duration: 100);
                                } catch (e) {
                                  print("Vibrator error");
                                }
                                setState(() {
                                  tasks.removeAt(index);
                                });
                                await DatabaseService().deleteTask(
                                    tasks[index]['id'],
                                    Personal
                                        ? 'personalTasks'
                                        : College
                                            ? 'collegeTasks'
                                            : 'officeTasks');
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                            value: ticked,
                            onChanged: (newValue) async {
                              try {
                                Vibration.vibrate(duration: 100);
                              } catch (e) {
                                print("Vibrator error");
                              }
                              setState(() {
                                tasks[index]['Yes'] = newValue;
                              });
                              await DatabaseService().toggleTaskCompletion(
                                  tasks[index]['id'],
                                  Personal
                                      ? 'personalTasks'
                                      : College
                                          ? 'collegeTasks'
                                          : 'officeTasks');
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          );
                        },
                      )
                    : const Center(child: CircularProgressIndicator()),
              )
            ],
          )),
    );
  }

  openBox() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: SingleChildScrollView(
                child: Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                try {
                                  Vibration.vibrate(duration: 100);
                                } catch (e) {
                                  print("Vibrator error");
                                }
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.cancel),
                            ),
                            const SizedBox(width: 60),
                            const Text(
                              "Add ToDo Task",
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text("Add Text"),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: TextField(
                              controller: task,
                              decoration: const InputDecoration(
                                hintText: "Enter your task",
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(10),
                              )),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.greenAccent.shade400,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                try {
                                  Vibration.vibrate(duration: 100);
                                } catch (e) {
                                  print("Vibrator error");
                                }
                                String id = randomAlphaNumeric(10);
                                Map<String, dynamic> taskMap = {
                                  "task": task.text,
                                  "id": id,
                                  "Yes": false
                                };
                                Personal
                                    ? DatabaseService()
                                        .addPersonalTask(taskMap, id)
                                    : College
                                        ? DatabaseService()
                                            .addCollegeTask(taskMap, id)
                                        : DatabaseService()
                                            .addOfficeTask(taskMap, id);
                                task.clear();
                                await getOnTheLoad();

                                Navigator.pop(context);
                              },
                              child: const Center(
                                child: Text(
                                  "Add Task",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        )
                      ]),
                ),
              ),
            ));
  }
}
