import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:todo/utils/email.dart';

class DatabaseService {
  Future addPersonalTask(
      Map<String, dynamic> userPersonalMap, String id) async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Get the user's email
        String email = removeDotFromEmail(user.email!);

        // Create a reference to the Realtime Database
        DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

        // Create a reference to the user's tasks
        DatabaseReference userTasksReference =
            databaseReference.child(email).child('personalTasks');

        // Add the task to the user's personal tasks
        await userTasksReference.child(id).set(userPersonalMap);

        print('Personal task added successfully!');
      } else {
        print('User not logged in.');
      }
    } catch (e) {
      print('Error adding personal task: $e');
    }
  }

  Future<void> addOfficeTask(
      Map<String, dynamic> userOfficeMap, String id) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String email = removeDotFromEmail(user.email!);

        DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
        DatabaseReference userTasksReference =
            databaseReference.child(email).child('officeTasks');
        await userTasksReference.child(id).set(userOfficeMap);

        print('Office task added successfully!');
      } else {
        print('User not logged in.');
      }
    } catch (e) {
      print('Error adding office task: $e');
    }
  }

  Future<void> addCollegeTask(
      Map<String, dynamic> userCollegeMap, String id) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String email = removeDotFromEmail(user.email!);

        DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
        DatabaseReference userTasksReference =
            databaseReference.child(email).child('collegeTasks');
        await userTasksReference.child(id).set(userCollegeMap);

        print('College task added successfully!');
      } else {
        print('User not logged in.');
      }
    } catch (e) {
      print('Error adding college task: $e');
    }
  }

  Future<List<Map<dynamic, dynamic>>> fetchTasks(String taskType) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String email = removeDotFromEmail(user.email!);
        DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
        DatabaseReference userTasksReference =
            databaseReference.child(email).child(taskType);

        // Use the once method to get the DatabaseEvent
        DatabaseEvent databaseEvent = await userTasksReference.once();

        // Explicitly cast the 'value' property to Map<String, dynamic>
        Map<dynamic, dynamic> tasksMap =
            (databaseEvent.snapshot.value as Map<dynamic, dynamic>) ?? {};

        List<Map<dynamic, dynamic>> tasks = tasksMap.entries.map((entry) {
          return {
            'taskId': entry.key,
            ...entry.value,
          };
        }).toList();

        // Explicitly cast the list to List<Map<String, dynamic>>
        print(tasks);
        return tasks;
      } else {
        print('User not logged in.');
        return [];
      }
    } catch (e) {
      print('Error fetching tasks: $e');
      return [];
    }
  }

  Future<void> toggleTaskCompletion(String id, String taskType) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String email = removeDotFromEmail(user.email!);
        DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
        DatabaseReference userTasksReference =
            databaseReference.child(email).child(taskType);

        // Get a reference to the specific task using the provided id
        DatabaseReference taskReference = userTasksReference.child(id);

        // Fetch the current task details
        DatabaseEvent databaseEvent = await taskReference.once();
        DataSnapshot dataSnapshot = databaseEvent.snapshot;

        if (dataSnapshot.value != null) {
          // Extract the 'Yes' field value
          Map<dynamic, dynamic> taskData =
              dataSnapshot.value as Map<dynamic, dynamic>;

          // Extract the 'Yes' field value
          bool currentStatus = taskData['Yes'] ?? false;

          // Toggle the 'Yes' field value
          await taskReference.update({'Yes': !currentStatus});

          print('Task status toggled successfully!');
        } else {
          print('Task not found.');
        }
      } else {
        print('User not logged in.');
      }
    } catch (e) {
      print('Error toggling task status: $e');
    }
  }

  Future<void> deleteTask(String id, String taskType) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String email = removeDotFromEmail(user.email!);
        DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
        DatabaseReference userTasksReference =
            databaseReference.child(email).child(taskType);

        // Get a reference to the specific task using the provided id
        DatabaseReference taskReference = userTasksReference.child(id);

        // Check if the task exists before attempting to delete
        DatabaseEvent databaseEvent = await taskReference.once();
        DataSnapshot dataSnapshot = databaseEvent.snapshot;

        if (dataSnapshot.value != null) {
          // Delete the task
          await taskReference.remove();

          print('Task deleted successfully!');
        } else {
          print('Task not found.');
        }
      } else {
        print('User not logged in.');
      }
    } catch (e) {
      print('Error deleting task: $e');
    }
  }
}
