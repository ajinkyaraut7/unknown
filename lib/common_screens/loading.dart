import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';


class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Container(
          height: 100,
          width: 100,
          color: Colors.white,
          child: LoadingIndicator(
            indicatorType: Indicator.orbit,
            color:  Color(0xff001242),
          )
        ),
      ),
    );
  }
}