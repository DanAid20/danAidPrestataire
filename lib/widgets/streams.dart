import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:danaid/core/models/beneficiaryModel.dart';
import 'package:danaid/core/providers/adherentModelProvider.dart';
import 'package:danaid/core/providers/beneficiaryModelProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:danaid/widgets/home_page_mini_components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BeneficiaryStream extends StatefulWidget {
  //static getBeneficiary({BuildContext context, bool standardUse}){
    final bool standardUse, noLabel;

  BeneficiaryStream({Key key, this.standardUse = true, this.noLabel = false}) : super(key: key);

  @override
  _BeneficiaryStreamState createState() => _BeneficiaryStreamState();
}

class _BeneficiaryStreamState extends State<BeneficiaryStream> {
    String selectedMatricule;

    @override
    Widget build(BuildContext context){
      AdherentModelProvider adherentProvider = Provider.of<AdherentModelProvider>(context);
      BeneficiaryModelProvider beneficiaryProvider = Provider.of<BeneficiaryModelProvider>(context);
      return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("ADHERENTS").doc(adherentProvider.getAdherent.adherentId).collection("BENEFICIAIRES").snapshots(),
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
                      text: widget.standardUse ? "Bénéficiaires\n" : "Qui est malade?\n",
                      children: [
                        TextSpan(text: widget.standardUse ? (snapshot.data.docs.length+1).toString()+" personnes" : "Sélectionner le patient", style: TextStyle(color: kPrimaryColor, fontSize: wv*3.3)),
                      ], style: TextStyle(color: kPrimaryColor, fontSize: wv*4.5)),
                    ),
                    SizedBox(height: hv*2,),
                  ],
                ),
              ) : Container(),
              Container(
                height: hv*25,
                child: Row(
                  children: [
                    widget.standardUse ? HomePageComponents.beneficiaryCard(
                      name: adherentProvider.getAdherent.surname,
                      imgUrl: adherentProvider.getAdherent.imgUrl, 
                      action: (){Navigator.pushNamed(context, '/adherent-profile-edit');}
                    )
                    : HomePageComponents.beneficiaryChoiceCard(
                      name: adherentProvider.getAdherent.surname, 
                      imgUrl: adherentProvider.getAdherent.imgUrl,
                      isSelected: selectedMatricule == adherentProvider.getAdherent.adherentId,
                      selectAction: (){
                        selectedMatricule = adherentProvider.getAdherent.adherentId;
                        beneficiaryProvider.setBeneficiaryModel(
                          BeneficiaryModel(
                            matricule: adherentProvider.getAdherent.adherentId,
                            adherentId: adherentProvider.getAdherent.adherentId,
                            surname: adherentProvider.getAdherent.surname,
                            familyName: adherentProvider.getAdherent.familyName,
                            avatarUrl: adherentProvider.getAdherent.imgUrl,
                            birthDate: adherentProvider.getAdherent.birthDate,
                            phoneList: adherentProvider.getAdherent.phoneList
                          )
                        );
                        setState(() { });
                      },
                      editAction: (){
                        selectedMatricule = adherentProvider.getAdherent.adherentId;
                        setState(() { });
                        Navigator.pushNamed(context, '/adherent-profile-edit');
                      }
                    ),
                    snapshot.data.docs.length >= 1 ? Expanded(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index){
                          DocumentSnapshot doc = snapshot.data.docs[index];
                          BeneficiaryModel beneficiary = BeneficiaryModel.fromDocument(doc);
                          print("name: ");
                          return widget.standardUse ? HomePageComponents.beneficiaryCard(
                            name: beneficiary.surname, 
                            imgUrl: beneficiary.avatarUrl, 
                            action: (){
                              beneficiaryProvider.setBeneficiaryModel(beneficiary);
                              Navigator.pushNamed(context, '/edit-beneficiary');
                            }
                          )
                          :HomePageComponents.beneficiaryChoiceCard(
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