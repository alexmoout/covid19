import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutteriu_covid19/model/data_detail_model.dart';
import 'package:flutteriu_covid19/widget/item.dart';

class DashBoardMain extends StatelessWidget {
  final DataDetailModel dataDetail;
  final List<String> listString;
  final List<int> listInt;
  DashBoardMain({this.dataDetail, this.listInt, this.listString});
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
          label: 'Total cases',
          valueColor: Color(0xFFffb259),
          value: dataDetail.totalCase,
          textColor: Colors.black,
          backgroundColor: Color(0xFF8fb9a8),
        ),
        ItemContainer(
          label: 'Total deaths',
          valueColor: Color(0xFFff5959),
          value: dataDetail.death,
          textColor: Colors.black,
        ),
        ItemContainer(
          label: 'Total recovered',
          valueColor: Color(0xFF4cd97b),
          value: dataDetail.recovered,
          textColor: Colors.black,
        ),
        ItemContainer(
          label: 'Total active',
          valueColor: Color(0xFF4cb5ff),
          value: dataDetail.active,
          textColor: Colors.black,
        ),
        ItemContainer(
          label: 'Total critical',
          valueColor: Color(0xFF9059ff),
          value: dataDetail.critical,
          textColor: Colors.black,
        ),
      ],
      staggeredTiles: [
        StaggeredTile.extent(
          1,
          130,
        ),
        StaggeredTile.extent(
          1,
          130,
        ),
        StaggeredTile.extent(
          2,
          130,
        ),
        StaggeredTile.extent(
          1,
          130,
        ),
        StaggeredTile.extent(
          1,
          130,
        ),
      ],
    );
  }
}
