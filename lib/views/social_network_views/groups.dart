import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:flutter/material.dart';
import 'package:danaid/views/social_network_views/favourite_groups.dart';
import 'package:danaid/views/social_network_views/discover_groups.dart';

class Groups extends StatefulWidget {
  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> with SingleTickerProviderStateMixin {
  TabController groupsController;

  @override
  void initState() {
    super.initState();
    groupsController = TabController(
      length: 2,
      vsync: this,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TabBar(
            labelPadding: EdgeInsets.only(top: hv*1, right: wv*3, left: wv*3),
            indicatorColor: Colors.transparent,
            indicatorWeight: 0.1,
            isScrollable: true,
            labelColor:kDeepTeal,
            unselectedLabelColor: Colors.grey[300],
            labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 25),
            tabs: <Widget>[
              Tab(text: "Favoris"),
              Tab(text: "Découvrir")
            ],
            controller: groupsController,
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: groupsController,
            children: <Widget>[
              Center(child: FavouriteGroups()),
              Center(child: DiscoverGroups())
            ],
          ),
        )

      ],),
    );
  }
}