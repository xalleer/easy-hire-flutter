import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../constants/app_styles.dart';
import '../services/task_api.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final TaskApi taskApi = TaskApi();
  List<dynamic>? tasks;
  dynamic acceptedTask; // To store the accepted task
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkForAcceptedTask();
  }

  // First check if there's an accepted task
  Future<void> _checkForAcceptedTask() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await taskApi.getAcceptedTask();

      // Debug output to verify response structure
      print("getAcceptedTask response: $response");

      if (response != null) {
        if (response is Map) {
          // Direct task object
          if (response.containsKey('title') || response.containsKey('_id')) {
            setState(() {
              acceptedTask = response;
              isLoading = false;
            });
            return;
          }
          // Task nested in response object
          else if (response.containsKey('task') && response['task'] != null) {
            setState(() {
              acceptedTask = response['task'];
              isLoading = false;
            });
            return;
          }
          // Empty response or errors
          else if (response['status'] == 'error' || response.isEmpty) {
            print("No accepted task found, fetching available tasks");
          }
        }
      }

      // If we reach here, no accepted task was found
      _fetchTasks();
    } catch (e) {
      print("Error in _checkForAcceptedTask: $e");
      _fetchTasks();
    }
  }

  Future<void> _fetchTasks() async {
    setState(() {
      isLoading = true;
      acceptedTask = null; // Clear any previous accepted task
    });

    try {
      final response = await taskApi.getAllTasks();
      print("getAllTasks response: $response");

      if (response != null) {
        if (response is List) {
          setState(() {
            tasks = response;
            isLoading = false;
          });
        } else if (response is Map && response['status'] != 'error') {
          setState(() {
            tasks = response.containsKey('tasks') ? response['tasks'] : [];
            isLoading = false;
          });
        } else {
          setState(() {
            tasks = [];
            isLoading = false;
          });
          _showErrorSnackBar(
            "❌ Не вдалося завантажити завдання: ${response['message'] ?? 'Помилка запиту'}",
          );
        }
      } else {
        setState(() {
          tasks = [];
          isLoading = false;
        });
        _showErrorSnackBar(
          "❌ Не вдалося завантажити завдання: відповідь пуста",
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        tasks = [];
      });
      _showErrorSnackBar("❌ Помилка: $e");
    }
  }

  // Function to display the accepted task
  Widget _buildAcceptedTaskView() {
    print("Building accepted task view for: ${acceptedTask['title']}");

    return Padding(
      padding: AppStyles.formPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              decoration: BoxDecoration(
                color: AppStyles.successColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "✅ Активне завдання",
                style: TextStyle(
                  color: AppStyles.successColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: AppStyles.verticalSpacing * 2),
          Card(
            color: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.task_alt,
                        color: AppStyles.primaryColor,
                        size: 28,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          acceptedTask['title'] ?? 'Без назви',
                          style: AppStyles.headingStyle.copyWith(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 30),
                  _buildInfoRow(
                    Icons.category,
                    "Категорія: ${acceptedTask['category'] ?? 'Не вказано'}",
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Опис:",
                    style: TextStyle(
                      color: AppStyles.textSecondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildInfoRow(
                    Icons.description,
                    acceptedTask['description'] ?? 'Опис відсутній',
                  ),
                  SizedBox(height: 15),
                  _buildInfoRow(
                    Icons.location_on,
                    "Місце: ${acceptedTask['location'] ?? 'Не вказано'}",
                  ),
                  SizedBox(height: 10),
                  _buildInfoRow(
                    Icons.attach_money,
                    "Оплата: ${acceptedTask['price'] ?? 'Не вказано'} грн",
                  ),
                  SizedBox(height: 10),
                  _buildInfoRow(
                    acceptedTask['paymentMethod'] == 'cash'
                        ? Icons.money
                        : Icons.credit_card,
                    "Тип оплати: ${acceptedTask['paymentMethod'] == 'cash'
                        ? 'Готівкою'
                        : acceptedTask['paymentMethod'] == 'online'
                        ? 'На карту'
                        : 'Не вказано'}",
                  ),
                  SizedBox(height: AppStyles.verticalSpacing * 2),
                  CustomButton(
                    text: "Відмінити завдання",
                    onPressed: () {
                      _cancelTask(acceptedTask['_id']);
                    },
                    // backgroundColor: AppStyles.errorColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppStyles.textSecondaryColor, size: 18),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: AppStyles.textSecondaryColor),
          ),
        ),
      ],
    );
  }

  Future<void> _cancelTask(String? taskId) async {
    if (taskId != null) {
      try {
        final response = await taskApi.cancelTask(taskId);
        if (response != null && response['status'] != 'error') {
          _showSuccessSnackBar("✅ Завдання скасовано");
          setState(() {
            acceptedTask = null;
          });
          _fetchTasks(); // Load available tasks after cancellation
        } else {
          _showErrorSnackBar(
            "❌ ${response?['message'] ?? 'Помилка скасування завдання'}",
          );
        }
      } catch (e) {
        _showErrorSnackBar("❌ Помилка: $e");
      }
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
                    Row(
                      children: [
                        Icon(Icons.task_alt, color: AppStyles.primaryColor),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            task['title'] ?? 'Без назви',
                            style: AppStyles.headingStyle,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.category,
                          color: AppStyles.textSecondaryColor,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Категорія: ${task['category'] ?? 'Без назви'}",
                          style: TextStyle(color: AppStyles.textSecondaryColor),
                        ),
                      ],
                    ),
                    SizedBox(height: AppStyles.verticalSpacing),
                    Text(
                      "Опис:",
                      style: TextStyle(
                        color: AppStyles.textSecondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.description,
                          color: AppStyles.textSecondaryColor,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            task['description'] ?? 'Опис відсутній',
                            style: TextStyle(
                              color: AppStyles.textSecondaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppStyles.verticalSpacing),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppStyles.textSecondaryColor,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Місце: ${task['location'] ?? 'Не вказано'}",
                          style: TextStyle(color: AppStyles.textSecondaryColor),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.attach_money,
                          color: AppStyles.textSecondaryColor,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Оплата: ${task['price'] ?? 'Не вказано'} грн",
                          style: TextStyle(color: AppStyles.textSecondaryColor),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          task['paymentMethod'] == 'cash'
                              ? Icons.money
                              : Icons.credit_card,
                          color: AppStyles.textSecondaryColor,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Тип оплати: ${task['paymentMethod'] == 'cash'
                              ? 'Готівкою'
                              : task['paymentMethod'] == 'online'
                              ? 'На карту'
                              : 'Не вказано'}",
                          style: TextStyle(color: AppStyles.textSecondaryColor),
                        ),
                      ],
                    ),
                    SizedBox(height: AppStyles.verticalSpacing * 2),
                    CustomButton(
                      text: "Прийняти завдання",
                      onPressed: () {
                        _acceptTask(task['_id']);
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
      try {
        final response = await taskApi.acceptTask(taskId);
        if (response != null && response['status'] != 'error') {
          _showSuccessSnackBar("✅ Завдання #$taskId прийнято");
          _checkForAcceptedTask(); // Refresh to show the accepted task
        } else {
          _showErrorSnackBar(
            "❌ ${response?['message'] ?? 'Помилка прийняття завдання'}",
          );
        }
      } catch (e) {
        _showErrorSnackBar("❌ Помилка: $e");
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
    // Debug output for the current state
    print(
      "Current state - isLoading: $isLoading, acceptedTask: ${acceptedTask != null}, tasks count: ${tasks?.length}",
    );

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
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: AppStyles.primaryColor),
            onPressed: () {
              _checkForAcceptedTask(); // Always check for accepted task first
            },
          ),
        ],
      ),
      body: SafeArea(
        child:
            isLoading
                ? Center(
                  child: CircularProgressIndicator(
                    color: AppStyles.primaryColor,
                  ),
                )
                : acceptedTask != null
                ? _buildAcceptedTaskView() // Show accepted task view
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
                        leading: Icon(
                          Icons.task,
                          color: AppStyles.primaryColor,
                        ),
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
                            Row(
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  size: 16,
                                  color: AppStyles.secondaryColor,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Оплата: ${task['price'] ?? 'Не вказано'} грн",
                                  style: TextStyle(
                                    color: AppStyles.secondaryColor,
                                  ),
                                ),
                              ],
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
