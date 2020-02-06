import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LifeTimeBar extends StatelessWidget {
  final Icon icon;
  final double heightz;
  final double factor;
  Color colorFactor;

  void _colorFactor() {
    if (factor >= 0.3) {
      colorFactor = Colors.red;
      if (factor >= 0.5) {
        colorFactor = Colors.yellow;
        if (factor >= 0.8) {
          colorFactor = Colors.green;
        }
      }
    }
  }

  LifeTimeBar({this.heightz, this.icon, this.factor});
  @override
  Widget build(BuildContext context) {
    _colorFactor();
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Container(
          height: heightz,
          child: Column(
            children: <Widget>[
              Container(
                height: heightz * 0.15,
                child: FittedBox(
                  child: icon,
                ),
              ),
              SizedBox(
                height: heightz * 0.05,
              ),
              Container(
                height: heightz * 0.8,
                width: 10,
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black87,
                          width: 1.0,
                        ),
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        heightFactor: factor,
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorFactor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
