import 'package:danaid/widgets/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:hover_ussd/hover_ussd.dart';

class CoveragePayment extends StatefulWidget {
  @override
  _CoveragePaymentState createState() => _CoveragePaymentState();
}

class _CoveragePaymentState extends State<CoveragePayment> {
  final HoverUssd _hoverUssd = HoverUssd();

  void send(){
    _hoverUssd.sendUssd(actionId: "d68d2e79", extras: {"1": "658112605", "2": "100", "pin": "1980"});
  }

  @override
  Widget build(BuildContext context) {
    _hoverUssd.onTransactiontateChanged.listen((event) {
      if (event == TransactionState.succesfull) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successful",)));
      } else if (event == TransactionState.waiting) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Pending",)));
      } else if (event == TransactionState.failed) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed",)));
      }
    });

    return Scaffold(
      body: StreamBuilder(
        stream: _hoverUssd.onTransactiontateChanged,
        builder: (context, snapshot) {
          return Column(
            children: [
              Container(
                child: CustomTextButton(
                  text: "Pay",
                  action: send,
                ),
              )
            ],
          );
        }
      ),
    );
  }
}