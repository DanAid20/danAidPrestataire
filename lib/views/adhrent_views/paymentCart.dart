import 'package:flutter/material.dart';
import 'package:danaid/core/models/invoiceModel.dart';

class PaymentCart extends StatefulWidget {
  final InvoiceModel? invoice;
  final num? regFee;
  const PaymentCart({ Key? key, this.invoice, this.regFee }) : super(key: key);

  @override
  _PaymentCartState createState() => _PaymentCartState();
}

class _PaymentCartState extends State<PaymentCart> {


  @override
  Widget build(BuildContext context) {

    return Container();
  }


}