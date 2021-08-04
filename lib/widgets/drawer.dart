import 'package:danaid/core/providers/bottomAppBarControllerProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:danaid/widgets/clippers.dart';
import 'package:danaid/widgets/function_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class DefaultDrawer extends StatelessWidget {

  final Function entraide, accueil, carnet, partenaire, famille;

  const DefaultDrawer({ Key key, this.entraide, this.accueil, this.carnet, this.partenaire, this.famille }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BottomAppBarControllerProvider navController = Provider.of<BottomAppBarControllerProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.transparent,
      ),
      child: Drawer(
        elevation: 0,
        child: ClipPath(
          clipper: DrawerClipper(),
          child: Container(
            color: kDeepTeal.withOpacity(0.7),
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Center(
              child: SingleChildScrollView(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: wv*55,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListTile(
                          leading: SvgPicture.asset("assets/icons/Two-tone/Category.svg", width: inch*4, color: whiteColor.withOpacity(0.5)),
                          title: Text(S.of(context).entraide, style: TextStyle(color: whiteColor.withOpacity(0.7), fontSize: 17, fontWeight: FontWeight.bold),),
                          onTap: (){
                            navController.setIndex(0);
                            entraide();
                          },
                        ),
                        ListTile(
                          leading: SvgPicture.asset("assets/icons/Two-tone/Home.svg", width: inch*4, color: whiteColor.withOpacity(0.5)),
                          title: Text(S.of(context).accueil, style: TextStyle(color: whiteColor.withOpacity(0.7), fontSize: 17, fontWeight: FontWeight.bold),),
                          onTap: (){
                            navController.setIndex(1);
                            accueil();
                          },
                        ),
                        ListTile(
                          leading: SvgPicture.asset("assets/icons/Two-tone/Paper.svg", width: inch*4, color: whiteColor.withOpacity(0.5)),
                          title: Text(S.of(context).carnet, style: TextStyle(color: whiteColor.withOpacity(0.7), fontSize: 17, fontWeight: FontWeight.bold),),
                          onTap: (){
                            navController.setIndex(2);
                            carnet();
                          },
                        ),
                        ListTile(
                          leading: SvgPicture.asset("assets/icons/Two-tone/Location.svg", width: inch*4, color: whiteColor.withOpacity(0.5)),
                          title: Text(S.of(context).partenaires, style: TextStyle(color: whiteColor.withOpacity(0.7), fontSize: 17, fontWeight: FontWeight.bold),),
                          onTap: (){
                            navController.setIndex(3);
                            partenaire();
                          },
                        ),
                        ListTile(
                          leading: SvgPicture.asset(userProvider.getProfileType == adherent ? "assets/icons/Two-tone/3User.svg" : "assets/icons/Two-tone/Profile.svg", width: inch*4, color: whiteColor.withOpacity(0.5)),
                          title: Text(userProvider.getProfileType == adherent ? S.of(context).famille : S.of(context).profile, style: TextStyle(color: whiteColor.withOpacity(0.7), fontSize: 17, fontWeight: FontWeight.bold),),
                          onTap: (){
                            navController.setIndex(4);
                            famille();
                          },
                        ),
                        ListTile(
                          leading: SvgPicture.asset("assets/icons/Bulk/HeartOutline.svg", width: inch*4, color: whiteColor.withOpacity(0.5)),
                          title: Text(S.of(context).demandesDamitis, style: TextStyle(color: whiteColor.withOpacity(0.7), fontSize: 17, fontWeight: FontWeight.bold),),
                          onTap: ()=>Navigator.pushNamed(context, '/friend-requests'),
                        ),
                        ListTile(
                          leading: SvgPicture.asset("assets/icons/Two-tone/InfoSquare.svg", width: inch*4, color: whiteColor.withOpacity(0.5)),
                          title: Text(S.of(context).conditionsndutilisation, style: TextStyle(color: whiteColor.withOpacity(0.7), fontSize: 17, fontWeight: FontWeight.bold),),
                          onTap: ()=>FunctionWidgets.termsAndConditionsDialog(context: context),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}