import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/beneficiaryModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/beneficiaryModelProvider.dart';
import 'package:danaid/core/providers/userProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/generated/l10n.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/helpers/constants.dart' as CONST;
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/services/getPlatform.dart';

class BeneficiaryStream extends StatefulWidget {
  //static getBeneficiary({BuildContext context, bool standardUse}){
    final bool standardUse, noLabel;

  BeneficiaryStream({Key? key, this.standardUse = true, this.noLabel = false}) : super(key: key);

  @override
  _BeneficiaryStreamState createState() => _BeneficiaryStreamState();
}

class _BeneficiaryStreamState extends State<BeneficiaryStream> {
    String? selectedMatricule;

    @override
    Widget build(BuildContext context){
      AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
      UserProvider userProvider = Provider.of<UserProvider>(context);
      BeneficiaryModelProvider beneficiaryProvider = Provider.of<BeneficiaryModelProvider>(context);
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent!.adherentId).collection("BENEFICIAIRES").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData){
            return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),),);
          }
          return Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              !widget.noLabel ? Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column( 
                  children: [
                    RichText(text: TextSpan(
                      text: widget.standardUse ? S.of(context).bnficiairesn : S.of(context).quiEstMaladen,
                      children: [
                        TextSpan(text: widget.standardUse ? (snapshot.data!.docs.length+1).toString()+S.of(context).personnes : S.of(context).slectionnerLePatient, style: TextStyle(color: kPrimaryColor, fontSize: Device.isSmartphone(context) ? wv*3.3 : 20)),
                      ], style: TextStyle(color: kPrimaryColor, fontSize: Device.isSmartphone(context) ? wv*4.5 : 25)),
                    ),
                    SizedBox(height: hv*2,),
                  ],
                ),
              ) : Container(),
              SizedBox(
                height: Device.isSmartphone(context) ? hv*25 : 225,
                child: Row(
                  children: [
                    widget.standardUse ? HomePageComponents.beneficiaryCard(
                      context: context,
                      name: adherentProvider.getAdherent?.cniName != null ? adherentProvider.getAdherent?.cniName : adherentProvider.getAdherent?.surname,
                      edit: userProvider.getUserModel?.profileType != CONST.beneficiary,
                      imgUrl: adherentProvider.getAdherent?.imgUrl, 
                      action: (){Navigator.pushNamed(context, '/adherent-profile-edit');}
                    )
                    : userProvider.getUserModel?.profileType != CONST.beneficiary ? HomePageComponents.beneficiaryChoiceCard(
                      context: context,
                      name: adherentProvider.getAdherent?.surname, 
                      imgUrl: adherentProvider.getAdherent?.imgUrl,
                      isSelected: selectedMatricule == adherentProvider.getAdherent?.adherentId,
                      selectAction: (){
                        selectedMatricule = adherentProvider.getAdherent?.adherentId;
                        beneficiaryProvider.setBeneficiaryModel(
                          BeneficiaryModel(
                            matricule: adherentProvider.getAdherent?.adherentId,
                            adherentId: adherentProvider.getAdherent?.adherentId,
                            surname: adherentProvider.getAdherent?.surname,
                            familyName: adherentProvider.getAdherent?.familyName,
                            avatarUrl: adherentProvider.getAdherent?.imgUrl,
                            birthDate: adherentProvider.getAdherent?.birthDate,
                            phoneList: adherentProvider.getAdherent?.phoneList
                          )
                        );
                        setState(() { });
                      },
                      editAction: (){
                        selectedMatricule = adherentProvider.getAdherent?.adherentId;
                        setState(() { });
                        Navigator.pushNamed(context, '/adherent-profile-edit');
                      }
                    ) : Container(),
                    snapshot.data!.docs.length >= 1 ? Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index){
                          if(snapshot.data!.docs[index]['adherentId'] == null){
                            return Container();
                          }
                          DocumentSnapshot doc = snapshot.data!.docs[index];
                          BeneficiaryModel beneficiary = BeneficiaryModel.fromDocument(doc, doc.data() as Map);
                          print("name: ");
                          return widget.standardUse ? HomePageComponents.beneficiaryCard(
                            context: context,
                            name: beneficiary.surname, 
                            imgUrl: beneficiary.avatarUrl, 
                            edit: userProvider.getUserModel?.profileType != CONST.beneficiary ? true : userProvider.getUserModel?.matricule == beneficiary.matricule,
                            action: (){
                              beneficiaryProvider.setBeneficiaryModel(beneficiary);
                              Navigator.pushNamed(context, '/edit-beneficiary');
                            }
                          )
                          :HomePageComponents.beneficiaryChoiceCard(
                            context: context,
                            name: beneficiary.surname, 
                            imgUrl: beneficiary.avatarUrl, 
                            isSelected: beneficiary.matricule == selectedMatricule,
                            selectAction: (){
                              selectedMatricule = beneficiary.matricule;
                              beneficiaryProvider.setBeneficiaryModel(beneficiary);
                              setState(() { });
                            },
                            editAction: (){
                              selectedMatricule = beneficiary.matricule;
                              beneficiaryProvider.setBeneficiaryModel(beneficiary);
                              setState(() { });
                              Navigator.pushNamed(context, '/edit-beneficiary');
                            }
                          );
                        }
                      ),
                    ) : Container(),
                  ],
                )
              ),
            ],
          );
        }
      );
    }
}