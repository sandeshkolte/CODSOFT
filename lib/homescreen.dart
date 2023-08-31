import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  final bool isChecked = false;
  Function(bool?)? newValue;

  List<Map<String, dynamic>> _todoList = [];

  final _myBox = Hive.box('mybox');

  @override
  void initState() {
    super.initState();
    _refreshTask();
  }

  void _refreshTask() {
    final data = _myBox.keys.map((key) {
      final task = _myBox.get(key);
      return {
        "key": key,
        "title": task["title"],
        "desc": task["desc"],
        "boolean": task["boolean"] ?? false,
      };
    }).toList();

    setState(() {
      _todoList = data.reversed.toList();
    });
  }

  //Create new item
  Future<void> _createTask(Map<String, dynamic> newTask) async {
    newTask['boolean'] = !(newTask['boolean'] ?? false);
    await _myBox.add(newTask);
    _refreshTask();
  }

  Future<void> _updateTask(int itemKey, Map<String, dynamic> task) async {
    task['boolean'] = !(task['boolean'] ?? false);

    await _myBox.put(itemKey, task);
    _refreshTask();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('An item has been updated')),
    );
  }

  Future<void> _deleteTask(int itemKey) async {
    await _myBox.delete(itemKey);
    _refreshTask();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An item has been deleted')));
  }

  void _dialogBox(BuildContext context, int? itemKey) async {
    if (itemKey != null) {
      final existingTAsk =
          _todoList.firstWhere((element) => element['key'] == itemKey);
      _titleController.text = existingTAsk['title'];
      _descController.text = existingTAsk['desc'];
    }

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text("Add Task"),
              backgroundColor: Colors.yellow[300],
              content: SizedBox(
                  height: 160,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextField(
                        cursorColor: Colors.blue,
                        controller: _titleController,
                        decoration: const InputDecoration(hintText: "Title"),
                      ),
                      TextField(
                        cursorColor: Colors.blue,
                        controller: _descController,
                        decoration:
                            const InputDecoration(hintText: "Description"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () async {
                              if (itemKey == null) {
                                _createTask({
                                  "title": _titleController.text,
                                  "desc": _descController.text
                                });
                              }

                              if (itemKey != null) {
                                _updateTask(itemKey, {
                                  'title': _titleController.text.trim(),
                                  'desc': _descController.text.trim(),
                                });
                              }

                              _titleController.text = '';
                              _descController.text = '';

                              Navigator.of(context).pop();
                            },
                            child: Text(itemKey == null ? 'Create' : 'Update'),
                          )
                        ],
                      )
                    ],
                  )),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("TO DO"),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _dialogBox(context, null),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: (_, index) {
          final currentTask = _todoList[index];
          bool taskCompleted = currentTask['boolean'] ?? false;
          return Padding(
            padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
            child: InkWell(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Checkbox(
                    activeColor: Colors.black,
                    value: !taskCompleted,
                    onChanged: (bool? newValue) {
                      setState(() {
                        taskCompleted = newValue ?? false;
                      });
                      _updateTask(currentTask['key'], currentTask);
                    },
                  ),
                  title: Text(
                    currentTask['title'],
                    style: TextStyle(
                        fontSize: 17,
                        decoration: currentTask['boolean']
                            ? TextDecoration.none
                            : TextDecoration.lineThrough),
                  ),
                  subtitle: Text(
                    currentTask['desc'],
                    style: TextStyle(
                        fontSize: 14,
                        decoration: currentTask['boolean']
                            ? TextDecoration.none
                            : TextDecoration.lineThrough),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.red.shade300,
                    onPressed: () => _deleteTask(currentTask['key']),
                  ),
                ),
              ),
              onLongPress: () => _dialogBox(context, currentTask['key']),
            ),
          );
        },
      ),
    );
  }
}
