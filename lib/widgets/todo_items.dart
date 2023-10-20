import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/constants/colors.dart';

class ToDoItems extends StatelessWidget {
  ToDoItems({super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction
  });

  // variables
  final String taskName;
  final bool taskCompleted;
  Function(bool?)? onChanged;
  Function (BuildContext)? deleteFunction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only( // This will give us spaces between our listview
          bottom: 20
      ),
      //this is for the ability to side the list-tile
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: tbRed,
              borderRadius: BorderRadius.circular(20),
              foregroundColor: Colors.white,
            ),
          ],
        ),


        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),

                child: Row(
                  children: [
                    Checkbox(
                      value: taskCompleted,
                      onChanged: onChanged,
                      activeColor: tbBlue,
                    ),
                    Flexible(
                      child: Text(
                        taskName,
                        style: TextStyle(
                          fontSize: 16,
                          color: tbBlack,
                          decoration: taskCompleted //this will check if checkbox is selected then will put line across
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,// if checkbox is not selected then there is no line
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
