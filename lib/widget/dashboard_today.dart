import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutteriu_covid19/model/data_detail_model.dart';
import 'package:flutteriu_covid19/widget/item.dart';

class DashBoardToDay extends StatelessWidget {
  final DataDetailModel dataDetail;

  DashBoardToDay({this.dataDetail});
  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      children: <Widget>[
        ItemContainer(
          label: 'Today cases',
          valueColor: Color(0xFFffb259),
          value: dataDetail.todayCase,
          textColor: Colors.black,
        ),
        ItemContainer(
          label: 'Today deaths',
          valueColor: Color(0xFFff5959),
          value: dataDetail.todayDeath,
          textColor: Colors.black,
        ),
        ItemContainer(
          label: 'Today recovered',
          valueColor: Color(0xFF4cd97b),
          value: dataDetail.todayRecovered,
          textColor: Colors.black,
        ),
      ],
      staggeredTiles: [
        StaggeredTile.extent(
          2,
          130,
        ),
        StaggeredTile.extent(
          2,
          130,
        ),
        StaggeredTile.extent(
          2,
          130,
        ),
      ],
    );
  }
}
