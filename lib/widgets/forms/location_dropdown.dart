import 'package:danaid/core/services/algorithms.dart';
import 'package:danaid/core/services/getCities.dart';
import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/colors.dart';
import 'package:flutter/material.dart';

class LocationDropdown extends StatelessWidget {
  
  final String stateCode, city;
  final bool regionChosen, cityChosen;
  final Function(dynamic) regionOnChanged, cityOnChanged;

  const LocationDropdown({Key key, this.stateCode, this.city, this.regionChosen, this.cityChosen, this.regionOnChanged, this.cityOnChanged}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Region", style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w400),),
              SizedBox(height: 5,),
              Container(
                constraints: BoxConstraints(minWidth: wv*45),
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton(
                      isExpanded: true,
                      value: stateCode,
                      hint: Text("Choisir une region"),
                      items: regions.map((region){
                        return DropdownMenuItem(
                          child: SizedBox(child: Text(region["value"], style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)), width: wv*50,),
                          value: region["key"],
                        );
                      }).toList(),
                      onChanged: regionOnChanged ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: wv*3,),
        regionChosen ? Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Choix de la ville", style: TextStyle(fontSize: wv*4, fontWeight: FontWeight.w400),),
              SizedBox(height: 5,),
              Container(
                constraints: BoxConstraints(minWidth: wv*45),
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton(
                      isExpanded: true,
                      value: city,
                      hint: Text("Ville"),
                      items: Algorithms.getTownNamesFromRegion(cities, stateCode).map((city){
                        return DropdownMenuItem(
                          child: Text(city, style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
                          value: city,
                        );
                      }).toList(),
                      onChanged: cityOnChanged),
                  ),
                ),
              ),
            ],
          ),
        ) : Container(),
      ],
    );
  }
}