import 'package:danaid/core/utils/config_size.dart';
import 'package:danaid/helpers/constants.dart';
import 'package:flutter/material.dart';

class IntroText extends StatelessWidget {
  const IntroText({
    Key? key, this.title, this.rank
  }) : super(key: key);
  final String? title;
  final int? rank;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom(size: defSize! * 13),
      left: 0,
      right: 0,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
            horizontal: horizontal(size: wv*4)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title!,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize(size: 23),
                  fontWeight: FontWeight.bold
              ),
            ),
            VerticalSpacing(of: inch * 1.18),
            Text.rich(
              rank == 1 ?
                TextSpan(
                    text: 'Avec votre famille, bénéficiez d’une couverture de ',
                    children: [
                      TextSpan(
                          text: '70% ',
                          style: TextStyle(fontWeight: FontWeight.w700)
                      ),
                      TextSpan(text: 'en '),
                      TextSpan(
                          text: '1 heures, ',
                          style: TextStyle(fontWeight: FontWeight.w700)
                      ),
                      TextSpan(text: 'partout au Cameroun. '),
                    ]
                )
              :
              rank == 2 ?
                TextSpan(
                    text: 'En cas de besoin, obtenez l’aide des membres du réseau ou un ',
                    children: [
                      TextSpan(
                          text: 'prêt santé ',
                          style: TextStyle(fontWeight: FontWeight.w700)
                      ),
                      TextSpan(text: 'en quelques minutes'),
                    ]
                )
              :
                TextSpan(
                    text: 'Traitement VIP chez mon médecin\n',
                    children: [
                      TextSpan(text: 'Mon médecin de famille personnel : reçu rapidement, orienté, suivi à long terme... '),
                    ]
                )
              ,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  height: 1.5,
                  letterSpacing: .72,
                  fontSize: fontSize(size: 22)),
            ),
          ],
        ),
      ),
    );
  }
}