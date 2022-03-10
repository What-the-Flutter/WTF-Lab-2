import 'package:flutter/material.dart';
import 'data/icon_data.dart';
import 'inherited_main.dart';
import 'task.dart';

class NewTask extends StatefulWidget {
  Task? taskEditable;
  int? indexTask;

  NewTask({Key? key}) : super(key: key);

  NewTask.edit({Key? key, required this.indexTask, required this.taskEditable})
      : super(key: key);

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  TextEditingController enterController = TextEditingController();
  final GlobalKey _scaffoldKey = GlobalKey();

  bool creationMode = true;

  bool _chosenAvatar = false;
  int selectedIndexAvatar = -1;

  Function floatButton = () {};

  void saveTask() {
    setState(
      () {
        if (enterController.text.isNotEmpty && _chosenAvatar == true) {
          var task = Task.all(
            enterController.value.text,
            'No Events. Click to create one.',
            IconResource.icons[selectedIndexAvatar],
            DateTime.now(),
          );
          InheritedMain.of(context)!.tasks.add(task);
        } else if (enterController.text.isNotEmpty && _chosenAvatar == false) {
          var task = Task.all(
            enterController.value.text,
            'No Events. Click to create one.',
            IconResource.icons[0],
            DateTime.now(),
          );
          InheritedMain.of(context)!.tasks.add(task);
        }
        Navigator.pop(context);
      },
    );
  }

  void editTask() {
    setState(() {
      InheritedMain.of(context)!.tasks[widget.indexTask!].header =
          enterController.text;
      InheritedMain.of(context)!.tasks[widget.indexTask!].leadingIcon =
          IconResource.icons[selectedIndexAvatar];
      InheritedMain.of(context)!.tasks[widget.indexTask!].isEdited = true;
      InheritedMain.of(context)!.tasks[widget.indexTask!].dataTimeLastUpdate =
          DateTime.now();
      returnToPreviousPage();
    });
  }

  void returnToPreviousPage() => Navigator.pop(context);

  Icon _iconChange() {
    if ((_chosenAvatar == true || enterController.text.isNotEmpty) &&
        creationMode == true) {
      floatButton = saveTask;
      return const Icon(Icons.check);
    } else if ((_chosenAvatar == true || enterController.text.isNotEmpty) &&
        creationMode == false) {
      floatButton = editTask;
      return const Icon(Icons.check);
    } else {
      floatButton = returnToPreviousPage;
      return const Icon(Icons.cancel);
    }
  }

  void checkingMode() {
    if (widget.indexTask != null) {
      enterController.text = widget.taskEditable!.header;
      setState(() {
        creationMode = false;
      });
    } else {
      setState(() {
        creationMode = true;
      });
    }
  }

  @override
  void initState() {
    checkingMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldKey,
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
        child: Column(
          children: [
            Text(
              creationMode ? 'Create a new Page' : 'Edit Page',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal),
              ),
              child: Column(
                children: [
                  const Text(
                    'Name of the Page',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  TextField(
                    controller: enterController,
                    autofocus: true,
                    onChanged: (value) async {
                      setState(() {});
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: IconResource.icons.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 80,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(
                        () {
                          _chosenAvatar = true;
                          selectedIndexAvatar = index;
                        },
                      );
                    },
                    child: Stack(
                      children: [
                        CircleAvatar(
                          child: IconResource.icons[index],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            Theme.of(context).floatingActionButtonTheme.backgroundColor,
        onPressed: () async {
          await floatButton();
        },
        child: _iconChange(),
      ),
    );
  }
}
