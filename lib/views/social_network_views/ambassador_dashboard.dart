import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/adherentModel.dart';
import 'package:danaid/core/models/userModel.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/services/dynamicLinkHandler.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/views/social_network_views/profile_page.dart';
import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class AmbassadorDashboard extends StatefulWidget {
  const AmbassadorDashboard({ Key key }) : super(key: key);

  @override
  _AmbassadorDashboardState createState() => _AmbassadorDashboardState();
}

class _AmbassadorDashboardState extends State<AmbassadorDashboard> {
  List users = [];
  List paymentRequests = [];
  num total = 0;
  bool spinner = false;
  init(){
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    UserModel user = userProvider.getUserModel;
    FirebaseFirestore.instance.collection("COMPTES_CREER_VIA_INVITATION").where("senderId", isEqualTo: user.userId).get().then((query) {
      print(query.docs.length);
      for (int i = 0; i < query.docs.length; i++){
        var doc = query.docs[i];
        print(doc.data()["ambassadorPaid"]);
        if(doc.data()["ambassadorPaid"] == true){
          users.add(doc.data()["receiverId"]);
        }
        if(doc.data()["ambassadorPaymentRequest"] == true){
          paymentRequests.add(doc.data()["receiverId"]);
        }
      }
      setState(() {});
    }).then((value) {
      FirebaseFirestore.instance.collection("ADHERENTS").where("invitedBy", isEqualTo: user.userId).get().then((query) {
        List levels = [1,2,3];
        for (int i = 0; i < query.docs.length; i++){
          AdherentModel adherent = AdherentModel.fromDocument(query.docs[i]);
          if(adherent.adherentPlan == 0 && !users.contains(adherent.adherentId)){
            total = total + 100;
          }
          else if(levels.contains(adherent.adherentPlan) && !users.contains(adherent.adherentId)){
            total = total + 3000;
          }
        }
        setState(() {});
      });
    });
  }
  @override
  void initState() {
    super.initState();
    init();
  }
  @override
  Widget build(BuildContext context) {
    print(users.toString());
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    UserModel user = userProvider.getUserModel;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.grey[700],), onPressed: ()=>Navigator.pop(context)),
        title: Text("Dashboard", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("ADHERENTS").where("invitedBy", isEqualTo: user.userId).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return snapshot.data.docs.length >= 1 ? ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      DocumentSnapshot userSnapshot = snapshot.data.docs[index];
                      AdherentModel singleUser = AdherentModel.fromDocument(userSnapshot);
                      if (singleUser.adherentId == user.userId) {
                        return Container();
                      }
                      return userBox(
                        user: singleUser,
                        paymentRequested: paymentRequests.contains(singleUser.adherentId),
                        paid: users.contains(singleUser.adherentId)
                      );
                    },
                  ) :
                  Container(
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: hv*15,),
                        Icon(LineIcons.userPlus, color: Colors.grey[400], size: 85,),
                        SizedBox(height: 5,),
                        Text("Aucune invitation acceptée\npour le moment",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[400] )
                        , textAlign: TextAlign.center,),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: wv*4, vertical: hv*2),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text("Coupon :  ", style: TextStyle(color: kCardTextColor, fontSize: 18, fontWeight: FontWeight.bold)),
                  SelectableText("${userProvider.getUserModel.couponCode}", style: TextStyle(letterSpacing: 3,color: kDeepTeal, fontSize: 22, fontWeight: FontWeight.bold),)
                ],),
                SizedBox(height: hv*2.5),
                Row(children: [
                  Expanded(child: Text("Total :", style: TextStyle(color: kCardTextColor, fontSize: 18, fontWeight: FontWeight.bold))),
                  Text("$total FCFA", style: TextStyle(color: kDeepTeal, fontSize: 18, fontWeight: FontWeight.bold),)
                ],),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: hv*6.5+30),
        child: FloatingActionButton(
          tooltip: "Share invitation link",
          child: SvgPicture.asset('assets/icons/Two-tone/AddUser.svg', width: wv*8,),
          backgroundColor: kDeepTeal,
          onPressed: () async {
            var link;
            String couponCode = userProvider.getUserModel.matricule.replaceAll(new RegExp(r'[^0-9]'),'');
            link = await DynamicLinkHandler.createAmbassadorDynamicLink(userId: userProvider.getUserModel.userId, couponCode: couponCode);
            Share.share(link.toString(), subject: "Nouvelle demande d'ami d'ambassadeur").then((value) {
              print("Done !");
            });
          },
        ),
      )
    );
  }

  Widget userBox({AdherentModel user, bool paid = false, bool paymentRequested = false}){
    DateTime delay = user.dateCreated.toDate().add(Duration(days: 90));
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: paymentRequested ? kSouthSeas.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: hv*1, horizontal: wv*3),
        leading: CircleAvatar(
          radius: wv*6,
          backgroundColor: Colors.grey,
          backgroundImage: user.imgUrl != null
              ? CachedNetworkImageProvider(user.imgUrl)
              : null,
          child: user.imgUrl != null ? Container() : Icon(LineIcons.user, color: whiteColor,),
        ),
        title: Text(user.surname, style: TextStyle(color: kDeepTeal, fontWeight: FontWeight.bold, fontSize: 17),),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Niveau ${user.adherentPlan}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Text("Délai de retrait - ${delay.day}/${delay.month}/${delay.year}", style: TextStyle(fontSize: 14, color: DateTime.now().isAfter(delay) ? Colors.red : Colors.grey)),
          ],
        ),
        //subtitle: Text("Joined: " + DateFormat("dd MMMM, yyyy - hh:mm:aa").format(DateTime.fromMillisecondsSinceEpoch((int.parse(user.createdAt))))),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Spacer(),
                Text("Montant", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 3,),
                Text(user.adherentPlan == 0 ? "100 FCFA" : "3000 FCFA", style: TextStyle(color: kCardTextColor, fontSize: 16, fontWeight: FontWeight.bold, decoration: paid ? TextDecoration.lineThrough : TextDecoration.none))
              ],
            ),
            SizedBox(width: wv*4,),
            Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
          ],
        ),
        onTap: (){
          if(paid){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Vous avez déjà reçu le paiement pour cet adhérent")));
          }
          /*else if (DateTime.now().isAfter(delay)){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Le délai de retrait est dépassé")));
          }*/
          else {
            showDialog(context: context,
              builder: (BuildContext context){
                return StatefulBuilder(
                  builder: (context, setState) {
                    return Dialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: wv*5,),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Column(children: [
                              SizedBox(height: hv*4),
                              Icon(LineIcons.coins, color: kDeepTeal, size: 80,),
                              SizedBox(height: hv*2,),
                              Text("Démande de paiement", style: TextStyle(color: kDeepTeal, fontSize: 20, fontWeight: FontWeight.w700),),
                              
                              SizedBox(height: hv*2,),
                              Text("Une requète sera envoyée au service DanAid pour la préparation de votre rémunération", style: TextStyle(color: Colors.grey[600], fontSize: wv*4), textAlign: TextAlign.center),
                              SizedBox(height: hv*2),
                              CustomTextButton(
                                text: "Confirmer",
                                color: kDeepTeal,
                                isLoading: spinner,
                                action: (){
                                  setState((){spinner = true;});
                                  FirebaseFirestore.instance.collection("COMPTES_CREER_VIA_INVITATION").doc(user.adherentId).update({
                                    "ambassadorPaymentRequest": true
                                  }).then((value) {
                                    setState((){spinner = false;});
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Votre requète a été envoyée..")));
                                    paymentRequests.add(user.adherentId);
                                    Navigator.pop(context);
                                  });
                                },
                              )
                              
                            ], mainAxisAlignment: MainAxisAlignment.center, ),
                          ),
                        ],
                      ),
                    );
                  }
                );
              }
            );
          }
        },
      ),
    );
  }
}