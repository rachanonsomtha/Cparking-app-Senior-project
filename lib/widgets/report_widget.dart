import 'package:flutter/material.dart';

class ReportItem extends StatelessWidget {
  // final report = Provider.of<ReportsProvider>(context, listen: false);

  final _imageUrlController = TextEditingController();

  final String userName;
  final double lifeTime;
  final String dateTime;
  final String imageUrl;
  final int availability;

  ReportItem(
    this.userName,
    this.lifeTime,
    this.dateTime,
    this.imageUrl,
    this.availability,
  );
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Container(
              height: 100,
              width: 100,
              margin: EdgeInsets.only(
                top: 10,
                right: 10,
              ),
              child: FittedBox(
                child: Image.network(
                  imageUrl.toString(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                leading: Text(
                  userName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                trailing: Text(dateTime),
                title: Text(availability.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
