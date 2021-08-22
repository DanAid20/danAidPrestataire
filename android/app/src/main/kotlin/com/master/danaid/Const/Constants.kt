import com.example.Const.removeSpaceAndPubLowecase

object Constants {

    val ETAPE_5_PAYEMENT_MTN_MONEY_VERS_MTN = "raison"
    val ETAPE_4_PAYEMENT_MTN_MONEY_VERS_MTN = "montantTransfert"
    val ETAPE_3_PAYEMENT_MTN_MONEY_VERS_MTN = "phoneNumber"
    val ETAPE_2_PAYEMENT_MTN_MONEY_VERS_MTN = "1"
    val ETAPE_1_PAYEMENT_MTN_MONEY_VERS_MTN = "1"
    val ID_ACTION_PAYEMENT_MTN_MONEY_VERS_MTN = "e33f1918"
    val REQUEST_CODE_FOR_PAYEMENT_MTN_MOBILE_MONEY = 50

    val ID_ACTION_PAYEMENT_ORANGE_MONEY = "d68d2e79"
    val ETAPE_1_PAYEMENT_ORANGE_MONEY = "1"
    val ETAPE_2_PAYEMENT_ORANGE_MONEY = "2"
    val REQUEST_CODE_FOR_PAYEMENY_ORANGE_MONEY = 51


    val ID_ACTION_PAYEMENT_ORANGE_MONEY_VERS_MTN = "c3494999"
    val ETAPE_1_PAYEMENT_ORANGE_MONEY_VERS_MTN = "1"
    val ETAPE_2_PAYEMENT_ORANGE_MONEY_VERS_MTN = "2"


    const val NUMBRE_DE_PERSONNE_COUVERTE_PAR_NIVEAU_DE_SERVICE = 5


    fun isOrangeMoneyTransfertInitiated(text: String): Boolean {
        return (text.removeSpaceAndPubLowecase()
            .contains("transfert initie".removeSpaceAndPubLowecase(), true) ||
                text.removeSpaceAndPubLowecase()
                    .contains("rechargement effectue".removeSpaceAndPubLowecase(), true)) ||
                text.removeSpaceAndPubLowecase()
                    .contains("Success".removeSpaceAndPubLowecase(), true) ||
                text.removeSpaceAndPubLowecase().contains("record".removeSpaceAndPubLowecase(), true)
    }

    fun isMTNMoneyTransfertInitiated(text: String): Boolean {
        return (
                text.removeSpaceAndPubLowecase()
                    .contains("effectue avec succes".removeSpaceAndPubLowecase(), true) ||
                        text.removeSpaceAndPubLowecase()
                            .contains("Successful".removeSpaceAndPubLowecase(), true) ||
                        text.removeSpaceAndPubLowecase()
                            .contains("Enter 1 to save".removeSpaceAndPubLowecase(), true) ||
                        text.removeSpaceAndPubLowecase()
                            .contains("Mobile Money favorite list".removeSpaceAndPubLowecase(), true) ||
                        text.removeSpaceAndPubLowecase()
                            .contains("Successful".removeSpaceAndPubLowecase(), true) ||
                        text.removeSpaceAndPubLowecase().contains(
                            "Vous recevrez votre confirmation".removeSpaceAndPubLowecase(),
                            true
                        )
                )
    }

}