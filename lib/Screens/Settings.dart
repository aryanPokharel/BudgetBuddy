import 'package:budget_buddy/Constants/Constants.dart';
import 'package:budget_buddy/Constants/DrawerColorButton.dart';
import 'package:budget_buddy/AdWidgets/MyAdWidget.dart';
import 'package:budget_buddy/StateManagement/states.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedLanguage = 'English';
  bool getNotifications = true;
  late bool showMonthlyData;
  late bool darkModeEnabled;

  @override
  Widget build(BuildContext context) {
    getNotifications = Provider.of<StateProvider>(context).getNotifcations;
    showMonthlyData = Provider.of<StateProvider>(context).showMonthlyData;
    dynamic appTheme = Provider.of<StateProvider>(context).appTheme;

    var currency = Provider.of<StateProvider>(context).currency;

    List<DrawerColorButton> firstRow = [];
    List<DrawerColorButton> secondRow = [];
    darkModeEnabled = Provider.of<StateProvider>(context).darkTheme;
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
            leading: const Icon(
              Icons.notifications,
              color: Color.fromARGB(255, 227, 214, 72),
            ),
            title: const Text('Notifications'),
            trailing: Switch(
              value: getNotifications,
              onChanged: (value) {
                setState(() {
                  context.read<StateProvider>().setGetNotifications(value);
                });
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.calendar_month,
            ),
            title: const Text('Show Monthly Data'),
            trailing: Switch(
              value: showMonthlyData,
              onChanged: (value) {
                setState(() {
                  context.read<StateProvider>().setShowMonthlyData(value);
                });
              },
            ),
          ),
          const Divider(),
          ExpansionTile(
            leading: const Icon(
              Icons.language,
              color: Colors.blue,
            ),
            title: const Text('Language'),
            children: [
              buildLanguageDropdownItem('gb', 'English', true),
            ],
          ),
          const Divider(),
          ExpansionTile(
            leading: Icon(
              currency == "USD"
                  ? Icons.currency_exchange
                  : Icons.currency_rupee,
              color: Colors.green,
            ),
            title: const Text('Currency'),
            children: [
              buildCurrencyDropdownItem('NP', 'NRS'),
              buildCurrencyDropdownItem('US', 'USD'),
              buildCurrencyDropdownItem('IN', 'INR'),
            ],
          ),
          const Divider(),
          ListTile(
            leading: darkModeEnabled
                ? Icon(Icons.dark_mode)
                : Icon(
                    Icons.light_mode,
                    color: Color.fromARGB(255, 218, 202, 51),
                  ),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: darkModeEnabled,
              onChanged: (value) {
                setState(() {
                  darkModeEnabled = value;
                  if (darkModeEnabled) {
                    context
                        .read<StateProvider>()
                        .updateAppTheme("Dark", Colors.blueGrey);
                  } else {
                    context.read<StateProvider>().setAppColor();
                  }
                });
              },
            ),
          ),
          if (!darkModeEnabled) const Divider(),
          if (!darkModeEnabled)
            ExpansionTile(
              leading: Icon(
                Icons.color_lens,
                color: appTheme,
              ),
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
          MyAdWidget(),
        ],
      ),
    );
  }

  DropdownMenuItem<String> buildLanguageDropdownItem(
      String country, String value, bool selected) {
    return DropdownMenuItem<String>(
      value: value,
      child: ListTile(
        leading: CountryFlag.fromCountryCode(
          country,
          height: 38,
          width: 32,
          borderRadius: 8,
        ),
        title: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: selected ? Icon(Icons.check, color: Colors.green) : null,
        onTap: () {},
      ),
    );
  }

  DropdownMenuItem<String> buildCurrencyDropdownItem(
    String country,
    String value,
  ) {
    bool selected = value == context.watch<StateProvider>().currency;
    return DropdownMenuItem<String>(
      value: value,
      child: ListTile(
        leading: CountryFlag.fromCountryCode(
          country,
          height: 38,
          width: 32,
          borderRadius: 8,
        ),
        title: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: selected ? Icon(Icons.check, color: Colors.green) : null,
        onTap: () {
          context.read<StateProvider>().updateCurrency(value);
        },
      ),
    );
  }
}
