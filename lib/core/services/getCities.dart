var regions = [
    {
        "value": "Adamaoua",
        "key": "CM-AD"
    },
    {
        "value": "Est",
        "key": "CM-ES"
    },
    {
        "value": "Extrême-Nord",
        "key": "CM-EN"
    },
    {
        "value": "Ouest",
        "key": "CM-OU"
    },
    {
        "value": "Centre",
        "key": "CM-CE"
    },
    {
        "value": "Littoral",
        "key": "CM-LT"
    },
    {
        "value": "Nord",
        "key": "CM-NO"
    },
    {
        "value": "Nord-Ouest",
        "key": "CM-NW"
    },
    {
        "value": "Sud",
        "key": "CM-SU"
    },
    {
        "value": "Sud-Ouest",
        "key": "CM-SW"
    }
];

var cities = [
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-SW",
        "value": "Tiko",
        "iso_a2": "CM",
        "state_hasc": "CM.SW",
        "key": "TIKO|CM-SW"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-SW",
        "value": "Bamusso",
        "iso_a2": "CM",
        "state_hasc": "CM.SW",
        "key": "BAMUSSO|CM-SW"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-SW",
        "value": "Bekondo",
        "iso_a2": "CM",
        "state_hasc": "CM.SW",
        "key": "BEKONDO|CM-SW"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-SW",
        "value": "Nguti",
        "iso_a2": "CM",
        "state_hasc": "CM.SW",
        "key": "NGUTI|CM-SW"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-SW",
        "value": "Muyuka",
        "iso_a2": "CM",
        "state_hasc": "CM.SW",
        "key": "MUYUKA|CM-SW"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-SW",
        "value": "Mutengene",
        "iso_a2": "CM",
        "state_hasc": "CM.SW",
        "key": "MUTENGENE|CM-SW"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-SW",
        "value": "Fontem",
        "iso_a2": "CM",
        "state_hasc": "CM.SW",
        "key": "FONTEM|CM-SW"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-SW",
        "value": "Mundemba",
        "iso_a2": "CM",
        "state_hasc": "CM.SW",
        "key": "MUNDEMBA|CM-SW"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-SW",
        "value": "Mamfe",
        "iso_a2": "CM",
        "state_hasc": "CM.SW",
        "key": "MAMFE|CM-SW"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-SU",
        "value": "Sangmélima",
        "iso_a2": "CM",
        "state_hasc": "CM.SU",
        "key": "SANGMELIMA|CM-SU"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-SU",
        "value": "Ambam",
        "iso_a2": "CM",
        "state_hasc": "CM.SU",
        "key": "AMBAM|CM-SU"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-SU",
        "value": "Akom II",
        "iso_a2": "CM",
        "state_hasc": "CM.SU",
        "key": "AKOM II|CM-SU"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-SU",
        "value": "Lolodorf",
        "iso_a2": "CM",
        "state_hasc": "CM.SU",
        "key": "LOLODORF|CM-SU"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-SU",
        "value": "Mvangué",
        "iso_a2": "CM",
        "state_hasc": "CM.SU",
        "key": "MVANGUE|CM-SU"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-NO",
        "value": "Tcholliré",
        "iso_a2": "CM",
        "state_hasc": "CM.NO",
        "key": "TCHOLLIRE|CM-NO"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-NO",
        "value": "Rey Bouba",
        "iso_a2": "CM",
        "state_hasc": "CM.NO",
        "key": "REY BOUBA|CM-NO"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-NO",
        "value": "Poli",
        "iso_a2": "CM",
        "state_hasc": "CM.NO",
        "key": "POLI|CM-NO"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-NO",
        "value": "Pitoa",
        "iso_a2": "CM",
        "state_hasc": "CM.NO",
        "key": "PITOA|CM-NO"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-NO",
        "value": "Lagdo",
        "iso_a2": "CM",
        "state_hasc": "CM.NO",
        "key": "LAGDO|CM-NO"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-NW",
        "value": "Mme-Bafumen",
        "iso_a2": "CM",
        "state_hasc": "CM.NW",
        "key": "MME-BAFUMEN|CM-NW"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-NW",
        "value": "Babanki",
        "iso_a2": "CM",
        "state_hasc": "CM.NW",
        "key": "BABANKI|CM-NW"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-NW",
        "value": "Njinikom",
        "iso_a2": "CM",
        "state_hasc": "CM.NW",
        "key": "NJINIKOM|CM-NW"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-NW",
        "value": "Mbengwi",
        "iso_a2": "CM",
        "state_hasc": "CM.NW",
        "key": "MBENGWI|CM-NW"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-NW",
        "value": "Jakiri",
        "iso_a2": "CM",
        "state_hasc": "CM.NW",
        "key": "JAKIRI|CM-NW"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-NW",
        "value": "Bali",
        "iso_a2": "CM",
        "state_hasc": "CM.NW",
        "key": "BALI|CM-NW"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-NW",
        "value": "Fundong",
        "iso_a2": "CM",
        "state_hasc": "CM.NW",
        "key": "FUNDONG|CM-NW"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-NW",
        "value": "Belo",
        "iso_a2": "CM",
        "state_hasc": "CM.NW",
        "key": "BELO|CM-NW"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-NW",
        "value": "Batibo",
        "iso_a2": "CM",
        "state_hasc": "CM.NW",
        "key": "BATIBO|CM-NW"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-OU",
        "value": "Tonga",
        "iso_a2": "CM",
        "state_hasc": "CM.OU",
        "key": "TONGA|CM-OU"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-OU",
        "value": "Mbouda",
        "iso_a2": "CM",
        "state_hasc": "CM.OU",
        "key": "MBOUDA|CM-OU"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-OU",
        "value": "Bangangté",
        "iso_a2": "CM",
        "state_hasc": "CM.OU",
        "key": "BANGANGTE|CM-OU"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-OU",
        "value": "Foumbot",
        "iso_a2": "CM",
        "state_hasc": "CM.OU",
        "key": "FOUMBOT|CM-OU"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-OU",
        "value": "Ngou",
        "iso_a2": "CM",
        "state_hasc": "CM.OU",
        "key": "NGOU|CM-OU"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-OU",
        "value": "Bana",
        "iso_a2": "CM",
        "state_hasc": "CM.OU",
        "key": "BANA|CM-OU"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-OU",
        "value": "Bandjoun",
        "iso_a2": "CM",
        "state_hasc": "CM.OU",
        "key": "BANDJOUN|CM-OU"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-OU",
        "value": "Dschang",
        "iso_a2": "CM",
        "state_hasc": "CM.OU",
        "key": "DSCHANG|CM-OU"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-OU",
        "value": "Bazou",
        "iso_a2": "CM",
        "state_hasc": "CM.OU",
        "key": "BAZOU|CM-OU"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-OU",
        "value": "Bansoa",
        "iso_a2": "CM",
        "state_hasc": "CM.OU",
        "key": "BANSOA|CM-OU"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-OU",
        "value": "Bamendjou",
        "iso_a2": "CM",
        "state_hasc": "CM.OU",
        "key": "BAMENDJOU|CM-OU"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-LT",
        "value": "Ngambé",
        "iso_a2": "CM",
        "state_hasc": "CM.LT",
        "key": "NGAMBE|CM-LT"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-LT",
        "value": "Ndom",
        "iso_a2": "CM",
        "state_hasc": "CM.LT",
        "key": "NDOM|CM-LT"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-LT",
        "value": "Diang",
        "iso_a2": "CM",
        "state_hasc": "CM.LT",
        "key": "DIANG|CM-LT"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-LT",
        "value": "Yabassi",
        "iso_a2": "CM",
        "state_hasc": "CM.LT",
        "key": "YABASSI|CM-LT"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-LT",
        "value": "Loum",
        "iso_a2": "CM",
        "state_hasc": "CM.LT",
        "key": "LOUM|CM-LT"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-LT",
        "value": "Penja",
        "iso_a2": "CM",
        "state_hasc": "CM.LT",
        "key": "PENJA|CM-LT"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-LT",
        "value": "Manjo",
        "iso_a2": "CM",
        "state_hasc": "CM.LT",
        "key": "MANJO|CM-LT"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-LT",
        "value": "Dibombari",
        "iso_a2": "CM",
        "state_hasc": "CM.LT",
        "key": "DIBOMBARI|CM-LT"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-LT",
        "value": "Mouanko",
        "iso_a2": "CM",
        "state_hasc": "CM.LT",
        "key": "MOUANKO|CM-LT"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-LT",
        "value": "Melong",
        "iso_a2": "CM",
        "state_hasc": "CM.LT",
        "key": "MELONG|CM-LT"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-LT",
        "value": "Mbanga",
        "iso_a2": "CM",
        "state_hasc": "CM.LT",
        "key": "MBANGA|CM-LT"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-LT",
        "value": "Dizangué",
        "iso_a2": "CM",
        "state_hasc": "CM.LT",
        "key": "DIZANGUE|CM-LT"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-EN",
        "value": "Koza",
        "iso_a2": "CM",
        "state_hasc": "CM.EN",
        "key": "KOZA|CM-EN"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-EN",
        "value": "Yagoua",
        "iso_a2": "CM",
        "state_hasc": "CM.EN",
        "key": "YAGOUA|CM-EN"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-EN",
        "value": "Mora",
        "iso_a2": "CM",
        "state_hasc": "CM.EN",
        "key": "MORA|CM-EN"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-EN",
        "value": "Mokolo",
        "iso_a2": "CM",
        "state_hasc": "CM.EN",
        "key": "MOKOLO|CM-EN"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-EN",
        "value": "Mindif",
        "iso_a2": "CM",
        "state_hasc": "CM.EN",
        "key": "MINDIF|CM-EN"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-EN",
        "value": "Makary",
        "iso_a2": "CM",
        "state_hasc": "CM.EN",
        "key": "MAKARY|CM-EN"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-EN",
        "value": "Kousséri",
        "iso_a2": "CM",
        "state_hasc": "CM.EN",
        "key": "KOUSSERI|CM-EN"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-EN",
        "value": "Kaélé",
        "iso_a2": "CM",
        "state_hasc": "CM.EN",
        "key": "KAELE|CM-EN"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-EN",
        "value": "Bogo",
        "iso_a2": "CM",
        "state_hasc": "CM.EN",
        "key": "BOGO|CM-EN"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-ES",
        "value": "Dimako",
        "iso_a2": "CM",
        "state_hasc": "CM.ES",
        "key": "DIMAKO|CM-ES"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-ES",
        "value": "Yokadouma",
        "iso_a2": "CM",
        "state_hasc": "CM.ES",
        "key": "YOKADOUMA|CM-ES"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-ES",
        "value": "Bétaré Oya",
        "iso_a2": "CM",
        "state_hasc": "CM.ES",
        "key": "BETARE OYA|CM-ES"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-ES",
        "value": "Ndelele",
        "iso_a2": "CM",
        "state_hasc": "CM.ES",
        "key": "NDELELE|CM-ES"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-ES",
        "value": "Mbang",
        "iso_a2": "CM",
        "state_hasc": "CM.ES",
        "key": "MBANG|CM-ES"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-ES",
        "value": "Garoua Boulaï",
        "iso_a2": "CM",
        "state_hasc": "CM.ES",
        "key": "GAROUA BOULAI|CM-ES"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-ES",
        "value": "Doumé",
        "iso_a2": "CM",
        "state_hasc": "CM.ES",
        "key": "DOUME|CM-ES"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Mbankomo",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "MBANKOMO|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Ngomedzap",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "NGOMEDZAP|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Ndikiniméki",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "NDIKINIMEKI|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Minta",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "MINTA|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Évodoula",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "EVODOULA|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Mbandjok",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "MBANDJOK|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Akonolinga",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "AKONOLINGA|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Ombésa",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "OMBESA|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Ngoro",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "NGORO|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Okoa",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "OKOA|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Ntui",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "NTUI|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Akono",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "AKONO|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Okola",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "OKOLA|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Yoko",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "YOKO|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Nanga Eboko",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "NANGA EBOKO|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Saa",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "SAA|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Nkoteng",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "NKOTENG|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Essé",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "ESSE|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Obala",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "OBALA|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-AD",
        "value": "Somié",
        "iso_a2": "CM",
        "state_hasc": "CM.AD",
        "key": "SOMIE|CM-AD"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-AD",
        "value": "Tignère",
        "iso_a2": "CM",
        "state_hasc": "CM.AD",
        "key": "TIGNERE|CM-AD"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-AD",
        "value": "Bankim",
        "iso_a2": "CM",
        "state_hasc": "CM.AD",
        "key": "BANKIM|CM-AD"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-AD",
        "value": "Djohong",
        "iso_a2": "CM",
        "state_hasc": "CM.AD",
        "key": "DJOHONG|CM-AD"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-AD",
        "value": "Bélel",
        "iso_a2": "CM",
        "state_hasc": "CM.AD",
        "key": "BELEL|CM-AD"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-AD",
        "value": "Banyo",
        "iso_a2": "CM",
        "state_hasc": "CM.AD",
        "key": "BANYO|CM-AD"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-ES",
        "value": "Abong-Mbang",
        "iso_a2": "CM",
        "state_hasc": "CM.ES",
        "key": "ABONG MBANG|CM-ES"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-OU",
        "value": "Bafang",
        "iso_a2": "CM",
        "state_hasc": "CM.OU",
        "key": "BAFANG|CM-OU"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Bafia",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "BAFIA|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-OU",
        "value": "Bafoussam",
        "iso_a2": "CM",
        "state_hasc": "CM.OU",
        "key": "BAFOUSSAM|CM-OU"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-NW",
        "value": "Bamenda",
        "iso_a2": "CM",
        "state_hasc": "CM.NW",
        "key": "BAMENDA|CM-NW"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-ES",
        "value": "Batouri",
        "iso_a2": "CM",
        "state_hasc": "CM.ES",
        "key": "BATOURI|CM-ES"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-ES",
        "value": "Bertoua",
        "iso_a2": "CM",
        "state_hasc": "CM.ES",
        "key": "BERTOUA|CM-ES"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-SW",
        "value": "Buéa",
        "iso_a2": "CM",
        "state_hasc": "CM.SW",
        "key": "BUEA|CM-SW"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-ES",
        "value": "Bélabo",
        "iso_a2": "CM",
        "state_hasc": "CM.ES",
        "key": "BELABO|CM-ES"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-LT",
        "value": "Douala",
        "iso_a2": "CM",
        "state_hasc": "CM.LT",
        "key": "DOUALA|CM-LT"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-SU",
        "value": "Ebolowa",
        "iso_a2": "CM",
        "state_hasc": "CM.SU",
        "key": "EBOLOWA|CM-SU"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Eséka",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "ESEKA|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-OU",
        "value": "Foumban",
        "iso_a2": "CM",
        "state_hasc": "CM.OU",
        "key": "FOUMBAN|CM-OU"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-NO",
        "value": "Garoua",
        "iso_a2": "CM",
        "state_hasc": "CM.NO",
        "key": "GAROUA|CM-NO"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-NO",
        "value": "Guider",
        "iso_a2": "CM",
        "state_hasc": "CM.NO",
        "key": "GUIDER|CM-NO"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-AD",
        "value": "Kontcha",
        "iso_a2": "CM",
        "state_hasc": "CM.AD",
        "key": "KONTCHA|CM-AD"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-SU",
        "value": "Kribi",
        "iso_a2": "CM",
        "state_hasc": "CM.SU",
        "key": "KRIBI|CM-SU"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-SW",
        "value": "Kumba",
        "iso_a2": "CM",
        "state_hasc": "CM.SW",
        "key": "KUMBA|CM-SW"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-NW",
        "value": "Kumbo",
        "iso_a2": "CM",
        "state_hasc": "CM.NW",
        "key": "KUMBO|CM-NW"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-SW",
        "value": "Limbé",
        "iso_a2": "CM",
        "state_hasc": "CM.SW",
        "key": "LIMBE|CM-SW"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-EN",
        "value": "Maroua",
        "iso_a2": "CM",
        "state_hasc": "CM.EN",
        "key": "MAROUA|CM-EN"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Mbalmayo",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "MBALMAYO|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-AD",
        "value": "Meiganga",
        "iso_a2": "CM",
        "state_hasc": "CM.AD",
        "key": "MEIGANGA|CM-AD"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-AD",
        "value": "Ngaoundéré",
        "iso_a2": "CM",
        "state_hasc": "CM.AD",
        "key": "NGAOUNDERE|CM-AD"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-LT",
        "value": "Nkongsamba",
        "iso_a2": "CM",
        "state_hasc": "CM.LT",
        "key": "NKONGSAMBA|CM-LT"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-AD",
        "value": "Tibati",
        "iso_a2": "CM",
        "state_hasc": "CM.AD",
        "key": "TIBATI|CM-AD"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-NW",
        "value": "Wum",
        "iso_a2": "CM",
        "state_hasc": "CM.NW",
        "key": "WUM|CM-NW"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Yaoundé",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "YAOUNDE|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-LT",
        "value": "Édéa",
        "iso_a2": "CM",
        "state_hasc": "CM.LT",
        "key": "EDEA|CM-LT"
    }
];

var centre = 
[
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Mbankomo",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "MBANKOMO|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Ngomedzap",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "NGOMEDZAP|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Ndikiniméki",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "NDIKINIMEKI|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Minta",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "MINTA|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Évodoula",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "EVODOULA|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Mbandjok",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "MBANDJOK|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Akonolinga",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "AKONOLINGA|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Ombésa",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "OMBESA|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Ngoro",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "NGORO|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Okoa",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "OKOA|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Ntui",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "NTUI|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Akono",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "AKONO|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Okola",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "OKOLA|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Yoko",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "YOKO|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Nanga Eboko",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "NANGA EBOKO|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Saa",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "SAA|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Nkoteng",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "NKOTENG|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Essé",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "ESSE|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Obala",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "OBALA|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Bafia",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "BAFIA|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Eséka",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "ESEKA|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Mbalmayo",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "MBALMAYO|CM-CE"
    },
    {
        "timezone": "Africa/Douala",
        "state_code": "CM-CE",
        "value": "Yaoundé",
        "iso_a2": "CM",
        "state_hasc": "CM.CE",
        "key": "YAOUNDE|CM-CE"
    }
];