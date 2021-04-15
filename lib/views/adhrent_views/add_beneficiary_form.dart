import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/views/adhrent_views/health_book_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddBeneficiaryForm extends StatefulWidget {
  @override
  _AddBeneficiaryFormState createState() => _AddBeneficiaryFormState();
}

class _AddBeneficiaryFormState extends State<AddBeneficiaryForm> {
  PageController controller;
  int currentPageValue = 0;
  final List<Widget> introWidgetsList = <Widget>[
    formLayout(
      ListView(children: [
        //
      ],)
    ),
    formLayout(Text("2/3")),
    formLayout(Text("3/3"))
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: kPrimaryColor,), onPressed: (){}),
        title: Text("Ajouter un bénéficiaire  ", style: TextStyle(color: kPrimaryColor),),
        centerTitle: true,
        actions: [
          IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Search.svg', color: kSouthSeas,), onPressed: (){}),
          IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Drawer.svg', color: kSouthSeas), onPressed: (){})
        ],
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                child: Text(currentPageValue == 0 ? "1 / 3\n" : currentPageValue == 1 ? "2 / 3\n" : "3 / 3\n", style: TextStyle(fontWeight: FontWeight.w700,color: kBlueDeep),),
              ),
              Expanded(
                child: PageView.builder(
                  pageSnapping: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: introWidgetsList.length,
                  onPageChanged: (int page) {
                    getChangedPageAndMoveBar(page);
                  },
                  controller: controller,
                  itemBuilder: (context, index) {
                    return introWidgetsList[index];
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: hv*5, top: hv*3),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (int i = 0; i < introWidgetsList.length; i++)
                      if (i == currentPageValue) ...[circleBar(true)] else
                        circleBar(false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
  }

  static Widget formLayout(Widget content){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: wv*3, vertical: hv*2),
      margin: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*1),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 3.0, spreadRadius: 1.0)]
      ),
      child: content,
    );
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 10 : 6,
      width: isActive ? 10 : 6,
      decoration: BoxDecoration(
          color: isActive ? kDeepTeal : Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }
}