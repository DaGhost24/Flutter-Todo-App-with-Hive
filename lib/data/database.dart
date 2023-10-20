import 'package:hive/hive.dart';
import 'package:todo_app/widgets/todo_items.dart';

class db_todo {

  List toDoTasks = [];

  final _myBox = Hive.box('mybox');


  //Methods for the app on database run

  //This will run when it is the first ever time running the app
  void createInitialData() {
    toDoTasks= [
      ["Study for programming test", false],
      ["Clean the car", false]
    ];
  }



  // load data from database for
  void loadData() {
    toDoTasks = _myBox.get("TODOLIST");
  }
  //This will update the the database
  void updateDataBase(){
    _myBox.put("TODOLIST", toDoTasks);
  }

}