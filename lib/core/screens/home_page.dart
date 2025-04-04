import 'package:easy_hire/core/screens/profile_page.dart';
import 'package:flutter/material.dart';
import '../constants/app_styles.dart';
import '../screens/profile_page.dart' as profile;
import '../screens/tasks_page.dart' as tasks;
import '../screens/balance_page.dart' as balance;
import '../screens/notification_page.dart' as notification;
import '../services/user_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    profile.ProfilePage(),
    tasks.TasksPage(),
    balance.BalancePage(),
    notification.NotificationsPage(),
  ];

  // Функція для зміни вкладки
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Профіль',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Завдання',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Баланс',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Сповіщення',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:
            AppStyles.primaryColor, // Залишив основний колір із констант
        unselectedItemColor: Colors.grey[600], // Трішки темніший сірий
        backgroundColor: Colors.white, // Фон білий для чистоти
        type: BottomNavigationBarType.fixed, // Постійне відображення тексту
        selectedFontSize: 14, // Розмір шрифту для вибраного
        unselectedFontSize: 12, // Розмір шрифту для невибраного
        elevation: 8, // Тінь для підняття над вмістом
        iconSize: 28, // Збільшив розмір іконок
        showUnselectedLabels: true, // Завжди показувати текст для невибраних
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold, // Жирний шрифт для вибраного
        ),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        onTap: _onItemTapped,
      ),
    );
  }
}
