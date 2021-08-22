package com.danaid.danaidmobile

import Constants.isMTNMoneyTransfertInitiated
import Constants.isOrangeMoneyTransfertInitiated
import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import androidx.annotation.NonNull
import com.hover.sdk.api.Hover
import com.hover.sdk.api.HoverParameters
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "danaidproject.sendmoney"

    var myResult: MethodChannel.Result? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Hover.initialize(this)

    }


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                CHANNEL
        ).setMethodCallHandler { call, result ->

            myResult = result

            when (call.method) {
                "moneyTransferOrangeAction" -> {
                    val amount = call.argument<String>("amount")
                    val phoneNumber = call.argument<String>("phoneNumber")

                    if (amount != null && phoneNumber != null) {
                        moneyTransferOrangeAction(amount, phoneNumber)
                    }
                }
                "moneyTransferMTNAction" -> {
                    val amount = call.argument<String>("amount")
                    val phoneNumber = call.argument<String>("phoneNumber")

                    if (amount != null && phoneNumber != null) {
                        moneyTransferMTNAction(amount, phoneNumber)
                    }
                }

                else -> {
                    result.notImplemented()
                }

            }
        }
    }


    fun moneyTransferOrangeAction(amount: String, receiverPhone: String) {
        val payementIntent = HoverParameters.Builder(this)
                .request(Constants.ID_ACTION_PAYEMENT_ORANGE_MONEY)
                .extra(
                        Constants.ETAPE_1_PAYEMENT_ORANGE_MONEY,
                        receiverPhone
                )
                .extra(
                        Constants.ETAPE_2_PAYEMENT_ORANGE_MONEY,
                        amount
                )
                .buildIntent()

        startActivityForResult(
                payementIntent,
                Constants.REQUEST_CODE_FOR_PAYEMENY_ORANGE_MONEY
        )
    }

    fun moneyTransferMTNAction(amount: String, receiverPhone: String) {
        val payementIntent = HoverParameters.Builder(context)
                .request(Constants.ID_ACTION_PAYEMENT_MTN_MONEY_VERS_MTN)
                .extra(Constants.ETAPE_1_PAYEMENT_MTN_MONEY_VERS_MTN, "1")
                .extra(Constants.ETAPE_2_PAYEMENT_MTN_MONEY_VERS_MTN, "1")
                .extra(
                        Constants.ETAPE_3_PAYEMENT_MTN_MONEY_VERS_MTN,
                        receiverPhone
                )
                .extra(
                        Constants.ETAPE_4_PAYEMENT_MTN_MONEY_VERS_MTN,
                        amount
                )
                .extra(
                        Constants.ETAPE_5_PAYEMENT_MTN_MONEY_VERS_MTN,
                        "Paiement Danaid"
                )
                .buildIntent()
        startActivityForResult(
                payementIntent,
                Constants.REQUEST_CODE_FOR_PAYEMENT_MTN_MOBILE_MONEY
        )
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        // on controle le resulatat de la transaction
        when (requestCode) {
            Constants.REQUEST_CODE_FOR_PAYEMENY_ORANGE_MONEY -> {
                if (resultCode == Activity.RESULT_OK) {

                    val sessionTextArr = data!!.getStringArrayExtra("ussd_messages")
                    var strMessage = ""
                    if (sessionTextArr != null) {
                        for (str in sessionTextArr) {
                            strMessage += str
                        }
                    }

                    if (isOrangeMoneyTransfertInitiated(strMessage)) {
                        showPaiementInitier()

                    } else {
                        showPaiementNonInitier()
                    }
                } else {

                    // en cas d'érreur de l'initialisation de la transaction
                    val erroMessage = data?.getStringExtra("error")
                    Toast.makeText(
                            this@MainActivity.applicationContext, erroMessage.toString(),
                            Toast.LENGTH_SHORT
                    ).show()
                }
            }
            Constants.REQUEST_CODE_FOR_PAYEMENT_MTN_MOBILE_MONEY -> {
                if (resultCode == Activity.RESULT_OK) {
                    val sessionTextArr = data!!.getStringArrayExtra("ussd_messages")
                    var strMessage = ""
                    if (sessionTextArr != null) {
                        for (str in sessionTextArr) {
                            strMessage += str
                        }
                    }

                    if (isMTNMoneyTransfertInitiated(strMessage)) {
                        showPaiementInitier()
                    } else {
                        showPaiementNonInitier()
                    }
                } else {

                    // en cas d'érreur de l'initialisation de la transaction
                    val erroMessage = data?.getStringExtra("error")
                    Toast.makeText(
                            this@MainActivity.applicationContext, erroMessage.toString(),
                            Toast.LENGTH_SHORT
                    ).show()
                }
            }
            else -> {
            }
        }
    }

    private fun showPaiementNonInitier() {
        Toast.makeText(
                this@MainActivity.applicationContext, "Paiement non initier",
                Toast.LENGTH_SHORT
        ).show()
        myResult?.success("FAILURE")

    }

    private fun showPaiementInitier() {
        Toast.makeText(
                this@MainActivity.applicationContext, "Paiement initier avec succes",
                Toast.LENGTH_SHORT
        ).show()

        myResult?.success("SUCCESS")
    }
}