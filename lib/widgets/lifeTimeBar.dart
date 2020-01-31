import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LifeTimeBar extends StatefulWidget {
  final Icon icon;
  final double heightz;
  double factor;
  LifeTimeBar({this.heightz, this.icon, this.factor});

  @override
  _LifeTimeBarState createState() => _LifeTimeBarState();
}

class _LifeTimeBarState extends State<LifeTimeBar> {
  Color colorFactor;

  void _colorFactor() {
    if (widget.factor >= 0.3) {
      colorFactor = Colors.red;
      if (widget.factor >= 0.5) {
        colorFactor = Colors.yellow;
        if (widget.factor >= 0.8) {
          colorFactor = Colors.green;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _colorFactor();
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Container(
          height: widget.heightz,
          child: Column(
            children: <Widget>[
              Container(
                height: widget.heightz * 0.15,
                child: FittedBox(
                  child: widget.icon,
                ),
              ),
              SizedBox(
                height: widget.heightz * 0.05,
              ),
              Container(
                height: widget.heightz * 0.8,
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
                        heightFactor: widget.factor,
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
