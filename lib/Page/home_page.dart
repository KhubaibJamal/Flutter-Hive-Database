import 'package:flutter/material.dart';
import 'package:flutter_hive/Box/box.dart';
import 'package:flutter_hive/Models/notes_model.dart';
import 'package:hive_flutter/adapters.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hive Database"),
        centerTitle: true,
        elevation: 0,
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: ((context, box, _) {
          var data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: ((context, index) {
              return Center(
                child: Card(
                  elevation: 1,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    height: 120,
                    width: MediaQuery.of(context).size.width - 30,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              data[index].title.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                delete(data[index]);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                editDialog(
                                    data[index],
                                    data[index].title.toString(),
                                    data[index].description.toString());
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          data[index].description.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialogBox();
        },
        backgroundColor: Theme.of(context).primaryColorLight,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  // delete notes
  void delete(NotesModel notesModel) {
    notesModel.delete();
  }

  // edit notes
  Future<void> editDialog(
      NotesModel notesModel, String title, String description) async {
    titleController.text = title;
    descriptionController.text = description;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Edit Memo"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "Enter Title",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "Enter Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                  size: 30,
                ),
              ),
              TextButton(
                onPressed: () {
                  notesModel.title = titleController.text.toString();
                  notesModel.description =
                      descriptionController.text.toString();
                  notesModel.save();
                  titleController.clear();
                  descriptionController.clear();
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.done,
                  color: Colors.green,
                  size: 30,
                ),
              ),
            ],
          );
        });
  }

  Future<void> _showDialogBox() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Adding Memo"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "Enter Title",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "Enter Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                  size: 30,
                ),
              ),
              TextButton(
                onPressed: () {
                  final data = NotesModel(
                      title: titleController.text,
                      description: descriptionController.text);
                  final box = Boxes.getData();
                  // add data into box
                  box.add(data);
                  data.save();
                  titleController.clear();
                  descriptionController.clear();
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.done,
                  color: Colors.green,
                  size: 30,
                ),
              ),
            ],
          );
        });
  }
}
