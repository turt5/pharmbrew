import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Terms_Policy extends StatelessWidget {
  const Terms_Policy({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double dWidth = MediaQuery.of(context).size.width;
    return Container(
      // color: Colors.red,
      height: 120,
      child:  Column(
      mainAxisAlignment:MainAxisAlignment.center,
      children: [
        //first row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (dWidth>600)?Text("By proceeding, you agree to the"):Text("By proceeding, you agree to the"),
            SizedBox(
              width: 5,
            ),
            
          ],
        ),
        SizedBox(
          height: 10,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Terms",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
            SizedBox(
              width: 5,
            ),
            Text("and"),
            SizedBox(
              width: 5,
            ),
            Text(
              "Privacy Policies",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            )
          ],
        ),

        //second row
      ]),
    );
  }
}
