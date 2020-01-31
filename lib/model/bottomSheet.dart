import '../screens/report_overview_screen.dart';
import 'package:flutter/material.dart';
import '../screens/Parkability.dart';
import '../screens/view_history_screen.dart';

class Modal {
  mainBottomSheet(BuildContext context, String s) {
    String name = s;
    DateTime now = DateTime.now();

    bool _isEnable = (now.hour >= 7 && now.hour <= 23) ? true : false;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              spacing: 3,
              children: <Widget>[
                ListTile(
                  enabled: _isEnable,
                  leading: Icon(Icons.queue),
                  subtitle: _isEnable
                      ? Text("Report time 7am - 6pm")
                      : Text("You can submit reports again next morning"),
                  title: Text('Report C-Parking'),
                  onTap: () => Navigator.of(context).pushReplacementNamed(
                    Parkability.routeName,
                    arguments: name,
                  ),
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  leading: Icon(Icons.show_chart),
                  subtitle: Text("See what happaned"),
                  title: Text('Parkability'),
                  onTap: () => Navigator.of(context).pushReplacementNamed(
                    ViewHistoryScreen.routeName,
                    arguments: name,
                  ),
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
}
