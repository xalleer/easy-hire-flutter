import 'package:flutter/material.dart';
import '../constants/app_styles.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Сповіщення", style: AppStyles.headingStyle),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    // Група: 25.03.2025
                    Text(
                      "25.03.2025",
                      style: TextStyle(
                        fontSize: 14, // Менший шрифт
                        fontWeight: FontWeight.normal, // Тонший (не жирний)
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 10),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.yellow[100],
                          child: Icon(Icons.task, color: Colors.yellow[800]),
                        ),
                        title: Text(
                          "Завдання прийнято",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "14:30",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                      ),
                    ),

                    // Група: 24.03.2025
                    SizedBox(height: 15),
                    Text(
                      "24.03.2025",
                      style: TextStyle(
                        fontSize: 14, // Менший шрифт
                        fontWeight: FontWeight.normal, // Тонший (не жирний)
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 10),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green[100],
                          child: Icon(Icons.payment, color: Colors.green[700]),
                        ),
                        title: Text(
                          "Оплата надійшла: +300 грн",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "18:00",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                      ),
                    ),

                    // Група: 23.03.2025
                    SizedBox(height: 15),
                    Text(
                      "23.03.2025",
                      style: TextStyle(
                        fontSize: 14, // Менший шрифт
                        fontWeight: FontWeight.normal, // Тонший (не жирний)
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 10),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue[100],
                          child: Icon(Icons.info, color: Colors.blue[700]),
                        ),
                        title: Text(
                          "Оновлення доступне",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "09:15",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
