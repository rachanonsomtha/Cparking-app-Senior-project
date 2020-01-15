import '../screens/report_overview_screen.dart';
import 'package:flutter/material.dart';
import '../screens/Parkability.dart';

class Modal {
  mainBottomSheet(BuildContext context, String s) {
    String name = s;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              spacing: 3,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.queue),
                  subtitle: Text("Shared your report with us"),
                  title: Text('Report C-Parking'),
                  onTap: () => {
                    Navigator.of(context).pushReplacementNamed(
                        Parkability.routeName,
                        arguments: name)
                  },
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  leading: Icon(Icons.show_chart),
                  subtitle: Text("See what happened"),
                  title: Text('Parkability'),
                  onTap: () => {},
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  leading: Icon(Icons.pageview),
                  subtitle: Text("Look back"),
                  title: Text('View history'),
                  onTap: () => Navigator.of(context).pushReplacementNamed(
                    ReportOverViewScreen.routeName,
                    arguments: name,
                  ),
                ),
              ],
            ),
          );
        });
  }

  navigateToPage(BuildContext context, String page) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(page, (Route<dynamic> route) => false);
  }

  ListTile _createTile(BuildContext context, String name, String subTitle,
      IconData icon, Function action) {
    return ListTile(
      leading: Icon(icon),
      subtitle: Text(subTitle),
      title: Text(name),
      onTap: () {
        action(context);
      },
    );
  }

  _action1(context) {
    // print('action 1');
  }

  _action2(context, name) {
    Navigator.of(context)
        .pushReplacementNamed(Parkability.routeName, arguments: name);
  }

  _action3(context) {
    Navigator.of(context).pushReplacementNamed(ReportOverViewScreen.routeName);
  }
}
