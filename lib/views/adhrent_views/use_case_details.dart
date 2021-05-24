import 'package:danaid/core/providers/usecaseModelProvider.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
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
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: kPrimaryColor,), 
            onPressed: ()=>Navigator.pop(context)
          ),
          title: Column(crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Démande du " + startTime.day.toString().padLeft(2, '0') + " "+DateFormat('MMMM', 'fr_FR').format(startTime)+" "+ startTime.year.toString(), style: TextStyle(color: kPrimaryColor, fontSize: wv*4.2, fontWeight: FontWeight.w400), overflow: TextOverflow.fade,),
              Text("Ajouter des prestations et justificatifs",  style: TextStyle(color: kPrimaryColor, fontSize: wv*3.8, fontWeight: FontWeight.w300),
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
        children: [],
      ),
    );
  }
}