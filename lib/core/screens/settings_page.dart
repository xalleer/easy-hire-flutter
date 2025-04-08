import 'package:flutter/material.dart';
import '../constants/app_styles.dart';
import '../widgets/custom_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true; // Toggle for notifications
  bool isDarkTheme = false; // Toggle for theme
  String selectedLanguage = 'Українська'; // Default language
  List<String> workLocations = ['Київ', 'Сушки']; // Example work locations

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: AppBar(
        title: Text("Налаштування", style: AppStyles.headingStyle),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppStyles.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // General Settings Section
                _buildSectionTitle("Загальні"),
                SizedBox(height: 12),
                _buildSettingsTile(
                  icon: Icons.notifications,
                  title: "Сповіщення",
                  trailing: Switch(
                    value: notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        notificationsEnabled = value;
                      });
                    },
                    activeColor: AppStyles.successColor,
                    inactiveThumbColor: AppStyles.errorColor,
                  ),
                ),
                _buildSettingsTile(
                  icon: Icons.language,
                  title: "Мова",
                  trailing: DropdownButton<String>(
                    value: selectedLanguage,
                    items:
                        ['Українська', 'English']
                            .map(
                              (lang) => DropdownMenuItem(
                                value: lang,
                                child: Text(lang),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedLanguage = value!;
                      });
                    },
                    underline: SizedBox(), // Remove default underline
                    style: TextStyle(
                      color: AppStyles.textSecondaryColor,
                      fontSize: 14,
                    ),
                  ),
                ),
                _buildSettingsTile(
                  icon: Icons.brightness_6,
                  title: "Темна тема",
                  trailing: Switch(
                    value: isDarkTheme,
                    onChanged: (value) {
                      setState(() {
                        isDarkTheme = value;
                      });
                      // Add theme change logic here if needed
                    },
                    activeColor: AppStyles.successColor,
                    inactiveThumbColor: AppStyles.errorColor,
                  ),
                ),
                SizedBox(height: 24),

                // Profile Settings Section
                _buildSectionTitle("Профіль"),
                SizedBox(height: 12),
                _buildSettingsTile(
                  icon: Icons.location_city,
                  title: "Міста роботи",
                  trailing: Icon(
                    Icons.edit,
                    color: AppStyles.primaryColor,
                    size: 20,
                  ),
                  onTap: () {
                    _showWorkLocationsDialog(context);
                  },
                ),
                SizedBox(height: 24),

                // Save Button
                Center(
                  child: CustomButton(
                    text: "Зберегти",
                    onPressed: () {
                      // Add save logic here (e.g., update SharedPreferences or API)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Налаштування збережено"),
                          backgroundColor: AppStyles.successColor,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ),
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

  // Helper method for settings tiles
  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: AppStyles.primaryColor, size: 24),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  // Dialog for editing work locations
  void _showWorkLocationsDialog(BuildContext context) {
    TextEditingController locationController = TextEditingController();
    List<String> tempLocations = List.from(workLocations);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text("Міста роботи", style: AppStyles.headingStyle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Current locations
                  Wrap(
                    spacing: 6.0,
                    runSpacing: 6.0,
                    children:
                        tempLocations
                            .map(
                              (location) => Chip(
                                label: Text(
                                  location,
                                  style: TextStyle(
                                    color: AppStyles.successColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                backgroundColor: AppStyles.successColor
                                    .withOpacity(0.1),
                                deleteIcon: Icon(Icons.close, size: 16),
                                onDeleted: () {
                                  setDialogState(() {
                                    tempLocations.remove(location);
                                  });
                                },
                              ),
                            )
                            .toList(),
                  ),
                  SizedBox(height: 12),
                  // Add new location
                  TextField(
                    controller: locationController,
                    decoration: InputDecoration(
                      hintText: "Додати місто",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (locationController.text.isNotEmpty) {
                      setDialogState(() {
                        tempLocations.add(locationController.text);
                        locationController.clear();
                      });
                    }
                  },
                  child: Text(
                    "Додати",
                    style: TextStyle(color: AppStyles.primaryColor),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      workLocations = tempLocations;
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Зберегти",
                    style: TextStyle(color: AppStyles.successColor),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
