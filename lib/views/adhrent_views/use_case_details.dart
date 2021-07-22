import 'package:danaid/core/providers/usecaseModelProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UseCaseDetails extends StatefulWidget {
  @override
  _UseCaseDetailsState createState() => _UseCaseDetailsState();
}

class _UseCaseDetailsState extends State<UseCaseDetails> {
  @override
  Widget build(BuildContext context) {
    UseCaseModelProvider usecaseProvider = Provider.of<UseCaseModelProvider>(context);
    DateTime startTime = usecaseProvider.getUseCase.dateCreated.toDate();
    int status = 2;
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: kPrimaryColor,), 
            onPressed: ()=>Navigator.pop(context)
          ),
          title: Column(crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(S.of(context).dmandeDu + startTime.day.toString().padLeft(2, '0') + " "+DateFormat('MMMM', 'fr_FR').format(startTime)+" "+ startTime.year.toString(), style: TextStyle(color: kPrimaryColor, fontSize: wv*4.2, fontWeight: FontWeight.w400), overflow: TextOverflow.fade,),
              Text(S.of(context).ajouterDesPrestationsEtJustificatifs,  style: TextStyle(color: kPrimaryColor, fontSize: wv*3.8, fontWeight: FontWeight.w300),
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(icon: SvgPicture.asset('assets/icons/Two-tone/InfoSquare.svg', color: kSouthSeas,), padding: EdgeInsets.all(4), constraints: BoxConstraints(), onPressed: (){}),
            IconButton(icon: SvgPicture.asset('assets/icons/Bulk/Drawer.svg', color: kSouthSeas), padding: EdgeInsets.all(8), constraints: BoxConstraints(), onPressed: (){})
          ],
        ),
      body: Column(
        children: [
          SizedBox(height: hv*2,),
          Container(
            padding: EdgeInsets.only(bottom: hv*1),
            decoration: BoxDecoration(
              color: kSouthSeas.withOpacity(0.3),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: HomePageComponents.head(surname: usecaseProvider.getUseCase.beneficiaryName, fname: "")),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: hv*5,),
                    Text(S.of(context).statutDeLaDemande,  style: TextStyle(color: kBlueDeep, fontSize: 15, fontWeight: FontWeight.w300)),
                    SizedBox(height: hv*1,),
                    Container(
                      width: wv*50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: status == 1 ? 45 : 10,
                            child: Container(
                              decoration: BoxDecoration(
                                color: kDeepTeal,
                                border: Border.all(color: whiteColor, width: 2),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
                              ),
                              child: Text(status == 1 ?  "1"+S.of(context).enAttente : "1", style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),)),
                          Expanded(
                            flex: status == 2 ? 45 : 10,
                            child: Container(
                              decoration: BoxDecoration(
                                color: kDeepTeal.withOpacity(0.7),
                                border: Border(top: BorderSide(color: whiteColor, width: 2), bottom: BorderSide(color: whiteColor, width: 2), right: BorderSide(color: whiteColor, width: 2)),
                              ),
                              child: Text(status == 2 ?  "2."+S.of(context).enCours : "2", style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold), textAlign: TextAlign.center))),
                          Expanded(
                            flex: status == 3 ? 45 : 10,
                            child: Container(
                              decoration: BoxDecoration(
                                color: kDeepTeal.withOpacity(0.3),
                                border: Border(top: BorderSide(color: whiteColor, width: 2), bottom: BorderSide(color: whiteColor, width: 2), right: BorderSide(color: whiteColor, width: 2)),
                              ),
                              child: Text(status == 3 ?  "3."+S.of(context).approuv : "3", style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold), textAlign: TextAlign.center))),
                          Expanded(
                            flex: status == 4 ? 45 : 10,
                            child: Container(
                              decoration: BoxDecoration(
                                color: primaryColor,
                                border: Border(top: BorderSide(color: whiteColor, width: 2), bottom: BorderSide(color: whiteColor, width: 2)),
                              ),
                              child: Text(status == 4 ?  "4."+S.of(context).rjt : "4", style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold), textAlign: TextAlign.center))),
                          Expanded(
                            flex: status == 5 ? 45 : 10,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border: Border.all(color: whiteColor, width: 2),
                                borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))
                              ),
                              child: Text(status == 5 ?  "5."+S.of(context).cltur : "5", style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold), textAlign: TextAlign.center))),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(width: wv*3,)
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: kSouthSeas.withOpacity(0.3)
                    ),
                    child: Container()
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}