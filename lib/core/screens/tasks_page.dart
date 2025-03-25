import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../constants/app_styles.dart';
import '../services/task_api.dart';

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final TaskApi taskApi = TaskApi();
  List<dynamic>? tasks;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    setState(() {
      isLoading = true;
    });
    final response = await taskApi.getAllTasks();
    if (response != null) {
      if (response is List) {
        // Якщо API повертає масив напряму
        setState(() {
          tasks = response;
          isLoading = false;
        });
      } else if (response is Map && response['status'] != 'error') {
        // Якщо API повертає об’єкт із полем 'tasks'
        setState(() {
          tasks = response['tasks'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        _showErrorSnackBar(
          "❌ Не вдалося завантажити завдання: ${response['message']}",
        );
      }
    } else {
      setState(() {
        isLoading = false;
      });
      _showErrorSnackBar("❌ Не вдалося завантажити завдання: відповідь пуста");
    }
  }

  void _showTaskDetails(BuildContext context, dynamic task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppStyles.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, controller) {
            return SingleChildScrollView(
              controller: controller,
              child: Padding(
                padding: AppStyles.formPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: AppStyles.secondaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Text(
                      task['title'] ?? 'Без назви',
                      style: AppStyles.headingStyle,
                    ),
                    SizedBox(height: AppStyles.verticalSpacing),
                    Text(
                      "Опис:",
                      style: TextStyle(
                        color: AppStyles.textSecondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      task['description'] ?? 'Опис відсутній',
                      style: TextStyle(color: AppStyles.textSecondaryColor),
                    ),
                    SizedBox(height: AppStyles.verticalSpacing),
                    Text(
                      "Місце: ${task['location'] ?? 'Не вказано'}",
                      style: TextStyle(color: AppStyles.textSecondaryColor),
                    ),
                    Text(
                      "Оплата: ${task['payment'] ?? 'Не вказано'} грн",
                      style: TextStyle(color: AppStyles.textSecondaryColor),
                    ),
                    SizedBox(height: AppStyles.verticalSpacing * 2),
                    CustomButton(
                      text: "Прийняти завдання",
                      onPressed: () {
                        _acceptTask(task['id']);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _acceptTask(String? taskId) async {
    if (taskId != null) {
      final response = await taskApi.acceptTask(taskId);
      if (response != null && response['status'] != 'error') {
        _showSuccessSnackBar("✅ Завдання #$taskId прийнято");
        _fetchTasks(); // Оновити список
      } else {
        _showErrorSnackBar("❌ ${response?['message']}");
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppStyles.successColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppStyles.errorColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: AppBar(
        title: Text("Завдання", style: AppStyles.headingStyle),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppStyles.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child:
            isLoading
                ? Center(
                  child: CircularProgressIndicator(
                    color: AppStyles.primaryColor,
                  ),
                )
                : tasks == null || tasks!.isEmpty
                ? Center(
                  child: Text(
                    "Немає доступних завдань",
                    style: TextStyle(color: AppStyles.textSecondaryColor),
                  ),
                )
                : ListView.builder(
                  padding: AppStyles.formPadding,
                  itemCount: tasks!.length,
                  itemBuilder: (context, index) {
                    final task = tasks![index];
                    return Card(
                      color: Colors.white,
                      elevation: 2,
                      margin: EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(15),
                        title: Text(
                          task['title'] ?? 'Без назви',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppStyles.primaryColor,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Text(
                              task['description'] ?? 'Опис відсутній',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppStyles.textSecondaryColor,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Оплата: ${task['payment'] ?? 'Не вказано'} грн",
                              style: TextStyle(color: AppStyles.secondaryColor),
                            ),
                          ],
                        ),
                        onTap: () => _showTaskDetails(context, task),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
