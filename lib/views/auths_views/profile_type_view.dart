import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/getPlatform.dart';
import 'package:danaid/core/services/hiveDatabase.dart';
import 'package:danaid/core/services/navigation_service.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/helpers/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:danaid/widgets/danAid_default_header.dart';

import '../../locator.dart';

class ProfileTypeView extends StatefulWidget {
  @override
  _ProfileTypeViewState createState() => _ProfileTypeViewState();
}

class _ProfileTypeViewState extends State<ProfileTypeView> {
  final NavigationService _navigationService = locator<NavigationService>();
  final List<String> descList = [Strings.USER_DESC, Strings.DOC_DESC, Strings.OTHER_DESC];
  final List<String> titleList = [S.current.utilisateur, S.current.mdcin, S.current.prestataireSant];
  final List<String> imageList = ['assets/images/User.svg', 'assets/images/Doctor.svg', 'assets/images/Health.svg'];
  final List<String> routeList = ['/profile-type-adherent', '/profile-type-doctor', ''];
  //final List<Function> actionList = [adherentAction(), doctorAction(), serviceProviderAction()];

  adherentAction(){
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    HiveDatabase.setProfileType(adherent);
    userProvider.setProfileType(adherent);
    _navigationService.navigateTo('/profile-type-adherent');
  }
  doctorAction(){
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    HiveDatabase.setProfileType(doctor);
    userProvider.setProfileType(doctor);
    _navigationService.navigateTo('/profile-type-doctor');
  }
  serviceProviderAction(){
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    HiveDatabase.setProfileType(serviceProvider);
    userProvider.setProfileType(serviceProvider);
    _navigationService.navigateTo('/profile-type-sprovider');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: Column(
          children: [
            DanAidDefaultHeader(showDanAidLogo: true,),
            Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: titleList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Container(
                    constraints: BoxConstraints(
                      maxWidth: Device.isSmartphone(context) ? width(size: 250) : 200,
                    ),
                    child: ProfileTypeCard(
                      title: titleList.elementAt(index),
                      description: descList.elementAt(index),
                      image: imageList.elementAt(index),
                      navigationService: _navigationService,
                      action: (){
                        if (index == 0){
                          setState(() {
                          });
                          adherentAction();
                        }
                        else if(index == 1){
                          doctorAction();
                        }
                        else {
                          serviceProviderAction();
                        }
                      },
                      //route: routeList.elementAt(index),
                    ),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileTypeCard extends StatelessWidget {
  const ProfileTypeCard({
    Key? key,
    @required NavigationService? navigationService,
    this.title, this.description, this.image, this.route, this.action
  }) : _navigationService = navigationService, super(key: key);

  final NavigationService? _navigationService;
  final String? title;
  final String? description;
  final String? image;
  final Function()? action;
  final String? route;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: Device.isSmartphone(context) ? height(size: 190) : 200,
        width: Device.isSmartphone(context) ? width(size: 250) : 200,
        padding: EdgeInsets.symmetric(horizontal: horizontal(size: Device.isSmartphone(context) ? 20 : 10), vertical: vertical(size: Device.isSmartphone(context) ? 10 : 25)),
        margin: EdgeInsets.symmetric(horizontal:  horizontal(size: 15), vertical: horizontal(size: 7.5)),
        decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 12.2,
                  spreadRadius: 2.2,
                  color: kBgColor.withOpacity(.1)
              )
            ]
        ),
        child: SizedBox(
          width: width(size: Device.isSmartphone(context) ?  250 : 200),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        title!,
                        softWrap: true,
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: fontSize(size: Device.isSmartphone(context) ? 24 : 10),
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      VerticalSpacing(of: Device.isSmartphone(context) ? 5 : 2),
                      Flexible(
                        child: Text(
                          description!,
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              color: kTextColor.withOpacity(0.7),
                              fontSize: fontSize(size: Device.isSmartphone(context) ? 17 : 8),
                              letterSpacing: .7,
                              height: 1.4,
                              fontWeight: FontWeight.w300
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SvgPicture.asset(image!, width: wv*30,)
            ],
          ),
        ),
      ),
      onTap: action,
    );
  }
}