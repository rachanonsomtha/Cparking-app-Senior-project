import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LifeTimeBar extends StatelessWidget {
  final Icon icon;
  final double heightz;
  double factor;

  LifeTimeBar({this.heightz, this.icon, this.factor});
  @override
  Widget build(BuildContext context) {
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
                            color: Colors.grey,
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
