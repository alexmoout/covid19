import 'package:flutter/material.dart';
import 'package:flutteriu_covid19/model/data_detail_model.dart';

class TotalCaseWidget extends StatelessWidget {
  final DataDetailModel dataDetail;

  TotalCaseWidget({this.dataDetail});
  @override
  Widget build(BuildContext context) {
    double percent = dataDetail.todayCase / dataDetail.totalCase * 100;
    print(percent.toString());
    double value = double.parse(percent.toString().substring(0, 4));
    print(value.toString());
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(5),
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Total Case',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '${value.toString()} % so với hôm qua',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFFDEDEDE),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
