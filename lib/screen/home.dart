import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutteriu_covid19/api/api.dart';
import 'package:flutteriu_covid19/helper/helper.dart';
import 'package:flutteriu_covid19/model/data_date_line_chart_model.dart';
import 'package:flutteriu_covid19/model/data_detail_model.dart';
import 'package:flutteriu_covid19/model/date_line_chart_model.dart';
import 'package:flutteriu_covid19/widget/animated_toggle_button.dart';
import 'package:flutteriu_covid19/widget/custom_chart.dart';
import 'package:flutteriu_covid19/widget/dashboard.dart';
import 'package:flutteriu_covid19/widget/dashboard_today.dart';
import 'package:flutteriu_covid19/widget/indicator.dart' as _;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AfterLayoutMixin<HomeScreen> {
  DataDetailModel dataDetail;
  List<LineChartModel> listCases = List();
  List<String> labelString;
  List<int> values;
  bool _isLoading;
  RefreshController _refreshController;
  bool isActive;
  List<DateLineChartModel> listDataCases = List();
  List<DateLineChartModel> listDataDeaths = List();
  List<DateLineChartModel> listRecovered = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = true;
    _refreshController = RefreshController();
    dataDetail = null;
    isActive = true;
    labelString = [];
    values = [];
  }

  @override
  void afterFirstLayout(BuildContext context) {
    loadDaily();
    loadTotalData();
  }

  void loadTotalData() async {
    DataDetailModel dataDetailModel = await Api().getTotal();

    if (dataDetailModel != null) {
      setState(() {
        dataDetail = dataDetailModel;
      });
    } else {
      print('Error Internet');
    }
  }

  void loadDaily() async {
    var data = await Api().getDaily();

    if (data != null) {
      setState(() {
        _isLoading = false;
        _refreshController.refreshCompleted();

        for (var item in data['cases'].entries) {
          var time = Helper.convertTimeStamp('${item.key}');
          int value = item.value;
          var setValue = value != null ? value : 0;
          listDataCases.add(DateLineChartModel(
              timeStamp: DateTime.fromMicrosecondsSinceEpoch(time),
              value: setValue));
        }
        for (var item in data['deaths'].entries) {
          var time = Helper.convertTimeStamp('${item.key}');
          int value = item.value;
          var setValue = value != null ? value : 0;

          listDataDeaths.add(DateLineChartModel(
              timeStamp: DateTime.fromMicrosecondsSinceEpoch(time),
              value: setValue));
        }
        for (var item in data['recovered'].entries) {
          var time = Helper.convertTimeStamp('${item.key}');
          int value = item.value;
          var setValue = value != null ? value : 0;
          listRecovered.add(DateLineChartModel(
              timeStamp: DateTime.fromMicrosecondsSinceEpoch(time),
              value: setValue));
        }
        for (var item in data['cases'].entries) {
          String text = item.key;

          labelString.add(text);
          values.add(item.value);
        }
        _refreshController.loadComplete();
      });
    } else {
      _refreshController.refreshFailed();
      setState(() {
        _isLoading = false;
      });
      print('Error Internet');
    }
  }

  Widget _buildBody() {
    Widget renderBody;
    if (listCases != null && dataDetail != null) {
      renderBody = SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              width: MediaQuery.of(context).size.width,
              height: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: CustomCasesChart(
                      lineCases: listDataCases,
                      animate: false,
                      lineDeath: listDataDeaths,
                      lineRecovered: listRecovered,
                    ),
                  ),
                  Text(
                    'Update at ${Helper.timestampFormatLong(dataDetail.timeUpdate)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedToggle(
              values: ['Total', 'Today'],
              onToggleCallback: (index) {
                setState(() {
                  isActive = !isActive;
                });
              },
            ),
            isActive
                ? DashBoardMain(
                    dataDetail: dataDetail,
                    listInt: values,
                    listString: labelString,
                  )
                : DashBoardToDay(
                    dataDetail: dataDetail,
                  ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      );
    } else {
      renderBody = Container();
    }
    return renderBody;
  }

  void _onRefresh() {
    setState(() {
      listCases = [];
      values = [];
      labelString = [];
      _isLoading = false;
      dataDetail = null;
      _refreshController.resetNoData();
      listDataCases = [];
      listDataDeaths = [];
      listRecovered = [];
      loadDaily();
      loadTotalData();
    });
  }

  void _onLoading() {
    setState(() {
      loadDaily();
      loadTotalData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF272936),
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.dark,
        backgroundColor: Color(0xFF272936),
        title: Text(
          'COVID-19 statistics in the world',
          style: TextStyle(
              color: Color(
            0xFFbebfc3,
          )),
        ),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        header: WaterDropMaterialHeader(
          backgroundColor: Color(0xFF272936),
          color: Color(0xFFffffff),
        ),
        child: _isLoading ? _.Indicator() : _buildBody(),
      ),
    );
  }
}
