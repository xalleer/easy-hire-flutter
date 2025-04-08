import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_styles.dart';
import '../widgets/custom_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? name;
  String? email;
  String? phone;
  String? avatarUrl;
  double? rating;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInfoJson = prefs.getString('userInfo');
    print("userInfoJson: $userInfoJson");

    if (userInfoJson != null) {
      Map<String, dynamic> userInfo = jsonDecode(userInfoJson);
      print("Parsed userInfo: $userInfo");

      setState(() {
        name = userInfo['name'] as String?;
        email = userInfo['email'] as String? ?? 'example@mail.com';
        phone = userInfo['phone'] as String? ?? '+380123456789';
        avatarUrl =
            userInfo['avatarUrl'] as String? ??
            'https://cactusthemes.com/blog/wp-content/uploads/2018/01/tt_avatar_small.jpg';
        rating = (userInfo['rating'] as num?)?.toDouble() ?? 4.9;
        print("Loaded: name=$name, email=$email, phone=$phone, rating=$rating");
      });
    } else {
      setState(() {
        name = null;
        email = 'example@mail.com';
        phone = '+380123456789';
        avatarUrl = 'https://www.example.com/avatar.png';
        rating = 4.9;
      });
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print("❌ Помилка при виході: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: AppBar(
        title: Text("Профіль", style: AppStyles.headingStyle),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: AppStyles.textSecondaryColor),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(avatarUrl ?? ''),
                          backgroundColor: Colors.grey[200],
                        ),
                        SizedBox(height: 16),
                        // Name
                        Text(
                          name ?? "Ім'я користувача",
                          style: AppStyles.headingStyle.copyWith(fontSize: 22),
                        ),
                        SizedBox(height: 8),
                        // Email and Phone
                        Text(
                          email ?? "example@mail.com",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppStyles.textSecondaryColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          phone ?? "+380123456789",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppStyles.textSecondaryColor,
                          ),
                        ),
                        SizedBox(height: 20),
                        // Work Categories
                        _buildSectionTitle("Категорії роботи"),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildChip("Фізична праця", AppStyles.primaryColor),
                            _buildChip("Водіння", AppStyles.primaryColor),
                            _buildChip("Будівництво", AppStyles.primaryColor),
                          ],
                        ),
                        SizedBox(height: 20),
                        // Work Locations
                        _buildSectionTitle("Міста/села"),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildChip("Київ", AppStyles.successColor),
                            _buildChip("Сушки", AppStyles.successColor),
                          ],
                        ),
                        SizedBox(height: 20),
                        // Edit Button
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppStyles.primaryColor,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            "Редагувати",
                            style: TextStyle(
                              color: AppStyles.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Rating Section
                _buildSectionTitle("Рейтинг та відгуки"),
                SizedBox(height: 12),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Rating Stars
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            if (index < rating!.floor()) {
                              return Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 24,
                              );
                            } else if (index < rating!) {
                              return Icon(
                                Icons.star_half,
                                color: Colors.amber,
                                size: 24,
                              );
                            } else {
                              return Icon(
                                Icons.star_border,
                                color: Colors.amber,
                                size: 24,
                              );
                            }
                          }),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "${rating?.toStringAsFixed(1)} / 5.0",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppStyles.textSecondaryColor,
                          ),
                        ),
                        SizedBox(height: 16),
                        // Reviews
                        _buildReview(
                          "Чудовий виконавець!",
                          "Олена, 25.03.2025",
                          5,
                        ),
                        _buildReview("Швидко і якісно", "Петро, 24.03.2025", 4),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32),

                // Logout Button
                CustomButton(text: "Вийти", onPressed: () => logout(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for section titles
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppStyles.textSecondaryColor.withOpacity(0.9),
      ),
    );
  }

  // Helper method for chips
  Widget _buildChip(String label, Color color) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
      backgroundColor: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    );
  }

  // Helper method for reviews
  Widget _buildReview(String text, String author, int stars) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                SizedBox(height: 4),
                Text(
                  author,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppStyles.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < stars ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 16,
              );
            }),
          ),
        ],
      ),
    );
  }
}
