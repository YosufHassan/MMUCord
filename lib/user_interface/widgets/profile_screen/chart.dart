//@dart = 2.9
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

Card buildCardMessages(context,total,username,sentcount,recvcount,unreadstate) {
    return  Card(
          elevation: 5.0,
          child: Column(
            children: [
             Container(
        width: MediaQuery.of(context).size.width * 0.65,
        height: MediaQuery.of(context).size.width * 0.65 * 0.65,
        child: ChartMessages(sentcount, recvcount, unreadstate)),
              ButtonBar(
                children: [
                   const Text('Key',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                   SizedBox(width: 145.0),
                   const Text('Unread',style: TextStyle(color: Color(0xff13d38e),fontWeight: FontWeight.bold),),
                   SizedBox(height: 5.0),
                   const Text('Sent',style: TextStyle(color: Color(0xff0293ee),fontWeight: FontWeight.bold),),
                   SizedBox(height: 5.0),
                   const Text('Recieved',style: TextStyle(color: Color(0xfff8b250),fontWeight: FontWeight.bold),),
                   SizedBox(height: 5.0),
                ],
              )
            ],
          ),);
  }

class ChartMessages extends StatelessWidget {
  final sentstate;
  final recvstate;
  final unreadstate;

  const ChartMessages(this.sentstate, this.recvstate, this.unreadstate);
  @override
  Widget build(BuildContext context) {

    final total = int.parse(this.sentstate)+int.parse(this.recvstate);
    final percentSent = (int.parse(this.sentstate)/total)*100;
    final percentRecv = (int.parse(this.recvstate)/total)*100;
    final percentUnread = (int.parse(this.unreadstate)/total)*100;

    return PieChart(PieChartData(
      centerSpaceRadius: 45,
      sections: [
    PieChartSectionData(
      value: percentSent.round().toDouble(),
      color: Color(0xff0293ee),
    ),
    PieChartSectionData(
      value: percentRecv.round().toDouble(),
      color: Color(0xfff8b250),
    ),
    PieChartSectionData(
      value: percentUnread.round().toDouble(),
      color: Color(0xff13d38e),
    ),
]
    ));    
}
  }

  class ActiveChart extends StatelessWidget {
  final active;
  final notActive;

  const ActiveChart(this.active, this.notActive);
  @override
  Widget build(BuildContext context) {
    final nonActive = int.parse(this.notActive)-int.parse(this.active);
    final percentNonActive = nonActive/int.parse(notActive)*100;
    final percentActive = (int.parse(this.active)/int.parse(this.notActive))*100;
    
    return PieChart(PieChartData(
      centerSpaceRadius: 45,
      sections: [
    PieChartSectionData(
      value: percentActive.round().toDouble(),
      color: Color(0xff0293ee),
    ),
    PieChartSectionData(
      value: percentNonActive.round().toDouble(),
      color: Color(0xff13d38e),
    ),
]
    ));    
}
  }


Card buildCardChats(context,active,nonactive) {
    return  Card(
          elevation: 5.0,
          child: Column(
            children: [
             Container(
        width: MediaQuery.of(context).size.width * 0.65,
        height: MediaQuery.of(context).size.width * 0.65 * 0.65,
        child: ActiveChart(active, nonactive)),
              ButtonBar(
                children: [
                   const Text('Key',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                   SizedBox(width: 210),
                   const Text('seen',style: TextStyle(color: Color(0xff13d38e),fontWeight: FontWeight.bold),),
                   SizedBox(height: 5.0),
                   const Text('un-seen',style: TextStyle(color: Color(0xff0293ee),fontWeight: FontWeight.bold),),
                   SizedBox(height: 5.0),
                ],
              )
            ],
          ),);
  }