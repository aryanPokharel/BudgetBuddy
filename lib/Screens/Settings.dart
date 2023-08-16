import 'package:budget_buddy/Constants/ConstantValues.dart';
import 'package:budget_buddy/Constants/DrawerColorButton.dart';
import 'package:budget_buddy/Screens/Constants.dart';
import 'package:budget_buddy/StateManagement/states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedLanguage = 'English';
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    List<DrawerColorButton> firstRow = [];
    List<DrawerColorButton> secondRow = [];

    for (var i = 0; i < 4; i++) {
      firstRow.add(DrawerColorButton(
        color: appThemeColors[i],
      ));
    }
    for (var i = 4; i < 8; i++) {
      secondRow.add(DrawerColorButton(
        color: appThemeColors[i],
      ));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            trailing: Switch(
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
          ),
          const Divider(),
          ExpansionTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            children: [
              buildDropdownItem('English'),
            ],
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: darkModeEnabled,
              onChanged: (value) {
                setState(() {
                  darkModeEnabled = value;
                  if (darkModeEnabled) {
                    context.read<StateProvider>().setAppTheme(Colors.blueGrey);
                    // context.read<StateProvider>().updateAppTheme({
                    //   "_id": 1,
                    //   "appTheme": "Dark",
                    //   "themeColor": "",
                    // });
                  } else {
                    context.read<StateProvider>().setAppTheme(defaultAppTheme);
                    // context.read<StateProvider>().getAppSettings();
                  }
                });
              },
            ),
          ),
          const Divider(),
          if (!darkModeEnabled)
            ExpansionTile(
              leading: const Icon(Icons.color_lens),
              title: const Text('Theme'),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: firstRow.toList(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: secondRow.toList(),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          const Divider(),
        ],
      ),
    );
  }

  DropdownMenuItem<String> buildDropdownItem(String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(80, 0, 0, 0),
        child: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
