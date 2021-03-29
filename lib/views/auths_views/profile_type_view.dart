import 'package:danaid/core/services/navigation_service.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/helpers/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../locator.dart';

class ProfileTypeView extends StatefulWidget {
  @override
  _ProfileTypeViewState createState() => _ProfileTypeViewState();
}

class _ProfileTypeViewState extends State<ProfileTypeView> {
  final NavigationService _navigationService = locator<NavigationService>();
  final List<String> descList = [Strings.USER_DESC, Strings.DOC_DESC, Strings.OTHER_DESC];
  final List<String> titleList = ['utilisateur', 'médécin', 'prestataire santé'];
  final List<String> imageList = ['assets/images/User.svg', 'assets/images/Doctor.svg', 'assets/images/Health.svg'];
  final List<String> routeList = ['/profile-type-adherent', '/profile-type-doctor', ''];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(defSize * 15),
          child: Container(
            child: Stack(
              children: [
                SvgPicture.asset('assets/images/headImage.svg',
                  width: SizeConfig.screenWidth,
                  fit: BoxFit.cover,),
                AppBar(
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white,),
                      onPressed: (){}),
                )
              ],
            ),
          ),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Container(
              child: ListView.builder(
                itemCount: titleList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => ProfileTypeCard(
                  title: titleList.elementAt(index),
                  description: descList.elementAt(index),
                  image: imageList.elementAt(index),
                  navigationService: _navigationService,
                  route: routeList.elementAt(index),
                ),
              )
          ),
        ),
      ),
    );
  }
}

class ProfileTypeCard extends StatelessWidget {
  const ProfileTypeCard({
    Key key,
    @required NavigationService navigationService,
    this.title, this.description, this.image, this.route,
  }) : _navigationService = navigationService, super(key: key);

  final NavigationService _navigationService;
  final String title;
  final String description;
  final String image;
  final String route;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: height(size: 180),
        width: width(size: 250),
        padding: EdgeInsets.symmetric(horizontal: horizontal(size: 20)),
        margin: EdgeInsets.symmetric(
            horizontal: horizontal(size: 15),
            vertical: vertical(size: 15)
        ),
        decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 4.2,
                  spreadRadius: .2,
                  color: kBgColor.withOpacity(.3)
              )
            ]
        ),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: width(size: defSize * 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title.toUpperCase(),
                      softWrap: true,
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: fontSize(size: 18),
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    VerticalSpacing(of: 20),
                    Flexible(
                      child: Text(
                        description,
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: kTextColor,
                            fontSize: fontSize(size: 14),
                            letterSpacing: .7,
                            height: 1.4,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SvgPicture.asset(image)
            ],
          ),
        ),
      ),
      onTap: () => _navigationService.navigateTo(route),
    );
  }
}