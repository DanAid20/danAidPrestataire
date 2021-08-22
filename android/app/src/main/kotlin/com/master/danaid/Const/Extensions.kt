package com.example.Const


fun String.removeSpaceAndPubLowecase(): String {
    return this.replace("\\s".toRegex(), "")
}