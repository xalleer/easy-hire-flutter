import 'package:easy_hire/core/services/user_api.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../constants/app_styles.dart';
import '../services/task_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final TaskApi taskApi = TaskApi();
  List<dynamic>? tasks;
  dynamic acceptedTask;
  bool isLoading = true;
  bool isOnline = false;

  @override
  void initState() {
    super.initState();
    _initializeStatusAndTasks();
  }

  Future<void> _initializeStatusAndTasks() async {
    setState(() {
      isLoading = true;
    });

    // Отримуємо статус користувача
    String? userStatus = await getUserStatus();
    setState(() {
      isOnline = userStatus == 'online';
    });

    // Перевіряємо прийняте завдання
    await _checkForAcceptedTask();
  }

  Future<void> _checkForAcceptedTask() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await taskApi.getAcceptedTask();
      print("getAcceptedTask response: $response");

      if (response != null) {
        if (response is Map) {
          if (response.containsKey('title') || response.containsKey('_id')) {
            setState(() {
              acceptedTask = response;
              isLoading = false;
            });
            return;
          } else if (response.containsKey('task') && response['task'] != null) {
            setState(() {
              acceptedTask = response['task'];
              isLoading = false;
            });
            return;
          } else if (response['status'] == 'error' || response.isEmpty) {
            print("No accepted task found, fetching available tasks");
          }
        }
      }
      _fetchTasks();
    } catch (e) {
      print("Error in _checkForAcceptedTask: $e");
      _fetchTasks();
    }
  }

  Future<void> _fetchTasks() async {
    setState(() {
      isLoading = true;
      acceptedTask = null;
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
          _fetchTasks();
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
          _checkForAcceptedTask();
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

  Future<void> _changeStatus(String? status) async {
    try {
      final response = await UserApi().changeStatus(status);
      // Оновлюємо локальне сховище
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userInfoJson = prefs.getString('userInfo');
      if (userInfoJson != null) {
        Map<String, dynamic> userInfo = jsonDecode(userInfoJson);
        userInfo['status'] = status;
        await prefs.setString('userInfo', jsonEncode(userInfo));
      }
    } catch (e) {
      _showErrorSnackBar("❌ Помилка: $e");
    }
  }

  Future<String?> getUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInfoJson = prefs.getString('userInfo');

    if (userInfoJson == null) return null;

    Map<String, dynamic> userInfo = jsonDecode(userInfoJson);
    return userInfo['status'];
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

  Widget _buildCustomToggle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color:
            isOnline
                ? AppStyles.successColor.withOpacity(0.1)
                : AppStyles.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOnline ? AppStyles.successColor : AppStyles.errorColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOnline ? Icons.wifi : Icons.wifi_off,
            size: 16,
            color: isOnline ? AppStyles.successColor : AppStyles.errorColor,
          ),
          SizedBox(width: 4),
          Text(
            isOnline ? 'Онлайн' : 'Офлайн',
            style: TextStyle(
              color: isOnline ? AppStyles.successColor : AppStyles.errorColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 4),
          GestureDetector(
            onTap: () async {
              setState(() {
                isOnline = !isOnline;
              });
              String newStatus = isOnline ? 'online' : 'offline';
              await _changeStatus(newStatus);
              if (isOnline) {
                _checkForAcceptedTask();
              }
            },
            child: Container(
              width: 36,
              height: 20,
              decoration: BoxDecoration(
                color: isOnline ? AppStyles.successColor : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    left: isOnline ? 18 : 2,
                    top: 2,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(
      "Current state - isLoading: $isLoading, acceptedTask: ${acceptedTask != null}, tasks count: ${tasks?.length}, isOnline: $isOnline",
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
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Row(
              children: [
                _buildCustomToggle(),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.refresh, color: AppStyles.primaryColor),
                  onPressed:
                      isOnline
                          ? () {
                            _checkForAcceptedTask();
                          }
                          : null,
                ),
              ],
            ),
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
                : !isOnline
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_off,
                        size: 64,
                        color: AppStyles.textSecondaryColor,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Ви в офлайн режимі",
                        style: TextStyle(
                          color: AppStyles.textSecondaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Перейдіть в онлайн щоб переглядати завдання",
                        style: TextStyle(color: AppStyles.textSecondaryColor),
                      ),
                    ],
                  ),
                )
                : acceptedTask != null
                ? _buildAcceptedTaskView()
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
