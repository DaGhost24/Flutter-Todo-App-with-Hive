import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/data/database.dart';
import 'package:todo_app/widgets/todo_items.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin  {

  final _mybox = Hive.box('mybox');
  db_todo db = db_todo();


  TextEditingController _todoController = TextEditingController();
  String _searchQuery = '';
  late AnimationController _controller;

  @override
  void initState() {
    if (_mybox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
    final TickerProvider tickerProvider = this;
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // Set the duration as per your requirement
      vsync: tickerProvider,
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Properly dispose the controller when it's no longer needed
    super.dispose();
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoTasks[index][1] = !db.toDoTasks[index][1];
    });
    db.updateDataBase();
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoTasks.removeAt(index);
    });
    db.updateDataBase();
  }

  void _addToDoItem() {
    setState(() {
      db.toDoTasks.add([_todoController.text, false]);
    });
    db.updateDataBase();
    _todoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tbBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: db.toDoTasks.length,
                    itemBuilder: (context, index) {
                      final taskName = db.toDoTasks[index][0];
                      final taskCompleted = db.toDoTasks[index][1];

                      if (_searchQuery.isEmpty ||
                          taskName.toLowerCase().contains(_searchQuery.toLowerCase())) {
                        return ToDoItems(
                          taskName: taskName,
                          taskCompleted: taskCompleted,
                          onChanged: (value) => checkBoxChanged(value, index),
                          deleteFunction: (context) => deleteTask(index),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),

                    child: TextFormField(
                      controller: _todoController,
                      decoration: const InputDecoration(
                        hintText: 'Add a new item to your list',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20, right: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_todoController.text.isNotEmpty) {
                        _addToDoItem();
                      } else {
                        final snackBar = SnackBar(
                          content: const Text('Please enter a to-do item.'),
                          backgroundColor: Colors.teal,
                          behavior: SnackBarBehavior.floating,
                          action: SnackBarAction(
                            label: 'Dismiss',
                            disabledTextColor: Colors.white,
                            textColor: Colors.yellow,
                            onPressed: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            },
                          ),
                          animation: Tween<double>(
                            begin: 0,
                            end: 1,
                          ).animate(
                            CurvedAnimation(
                              curve: Curves.easeIn,
                              reverseCurve: Curves.easeOut,
                              parent: _controller,
                            ),
                          ),
                          onVisible: () {
                            // Your code goes here
                          },
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      elevation: 10,
                    ),
                    child: const Text(
                      '+',
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (query) {
          setState(() {
            _searchQuery = query;
          });
        },
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tbBlack,
            size: 22,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 25,
            minWidth: 30,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tbGrey),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      toolbarHeight: 80,

      backgroundColor: tbBGColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.menu,
            color: tbBlack,
            size: 40,
          ),
          const Text('T O D O L I S T',
            style: TextStyle(fontSize: 17,
              fontWeight: FontWeight.bold,
              color: tbBlack,
            ),
          ),
          SizedBox(
            height: 50,
            width: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset('assets/images/avater.jpg', fit: BoxFit.cover,),
            ),
          ),
        ],
      ),
    );
  }
}