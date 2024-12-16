import 'package:flutter/material.dart';
import 'package:mashro3/db.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: StudentApp()));
}

class StudentApp extends StatefulWidget {
  const StudentApp({super.key});

  @override
  _StudentAppState createState() => _StudentAppState();
}

class _StudentAppState extends State<StudentApp> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> students = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshStudents();
  }

  void refreshStudents() async {
    final data = await dbHelper.getStudents();
    setState(() {
      students = data;
    });
  }

  void showStudentDialog({int? id, String? name, String? age}) {
    nameController.text = name ?? '';
    ageController.text = age ?? '';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(id == null ? 'Add Student' : 'Edit Student'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name')),
            TextField(
                controller: ageController,
                decoration: const InputDecoration(labelText: 'Age')),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(ctx),
          ),
          TextButton(
            child: Text(id == null ? 'Add' : 'Update'),
            onPressed: () {
              if (id == null) {
                dbHelper.insertStudent(
                    {'name': nameController.text, 'age': ageController.text});
              } else {
                dbHelper.updateStudent(id,
                    {'name': nameController.text, 'age': ageController.text});
              }
              Navigator.pop(ctx);
              refreshStudents();
            },
          ),
        ],
      ),
    );
  }

  void deleteStudent(int id) {
    dbHelper.deleteStudent(id);
    refreshStudents();
  }

  @override
  Widget build(BuildContext context) {
    //خلفيه الصفحه
    return Container(
      height: 300,
      width: 300,
      //حط الصورة بتاعتك

      // decoration: const BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage(),
      //     // fit: BoxFit.cover,
      //   ),
      // ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Patient Record List',
            style: TextStyle(color: Colors.white, fontFamily: "Lora"),
          ),
          backgroundColor: Colors.cyan,
        ),
        body: ListView.builder(
          itemCount: students.length,
          itemBuilder: (ctx, index) {
            final student = students[index];
            return ListTile(
              title: Text(
                student['name'],
                style: TextStyle(fontFamily: "Lora"),
              ),
              subtitle: Text(
                'Age: ${student['age']}',
                style: TextStyle(fontFamily: "Lora"),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => showStudentDialog(
                      id: student['id'],
                      name: student['name'],
                      age: student['age'],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteStudent(student['id']),
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 150, bottom: 20),
          child: FloatingActionButton(
            //لون الزرار
            backgroundColor: Colors.cyan,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () => showStudentDialog(),
          ),
        ),
      ),
    );
  }
}
