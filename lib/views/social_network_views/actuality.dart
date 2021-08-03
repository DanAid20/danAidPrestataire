import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:danaid/views/social_network_views/discussions.dart';
import 'package:danaid/views/social_network_views/posts.dart';
import 'package:danaid/views/social_network_views/crowd_funding.dart';
import 'package:danaid/views/social_network_views/questions.dart';

class ActualityPage extends StatefulWidget {
  ActualityPage({Key key}) : super(key: key);

  @override
  _ActualityPageState createState() => _ActualityPageState();
}

class _ActualityPageState extends State<ActualityPage> with SingleTickerProviderStateMixin {
  TabController actualityController;

  @override
  void initState() {
    super.initState();
    actualityController = TabController(
      length: 4,
      vsync: this,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        TabBar(
          labelPadding: EdgeInsets.only(top: hv*1, right: wv*3, left: wv*3),
          indicatorColor: Colors.transparent,
          indicatorWeight: 0.1,
          isScrollable: true,
          labelColor:kDeepTeal,
          unselectedLabelColor: Colors.grey[300],
          labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 25),
          tabs: <Widget>[
            Tab(text: S.of(context).posts),
            Tab(text: S.of(context).qr),
            Tab(text: S.of(context).entraide),
            Tab(text:S.of(context).discussions)
          ],
          controller: actualityController,
        ),
        Expanded(
          child: TabBarView(
            controller: actualityController,
            children: <Widget>[
              Posts(),
              Questions(),
              CrowdFunding(),
              Discussions(),
            ],
          ),
        )

      ],),
    );
  }
}