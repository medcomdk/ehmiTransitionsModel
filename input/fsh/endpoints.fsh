/*
Alias: $GS1_GLN = https://gs1.org
Alias: $EUA_GLN = https://medcom.dk
Alias: $EER_CONN_TYPE = http://medcomehmi.dk
Alias: $MEDCOM_MSG_DEF = http://medcomehmi.dk

// 1. Extension til at koble offentligt endpoint direkte til det reelle EUA-endpoint
Extension: MappedEuaTargetEndpoint
Id: mapped-eua-target-endpoint
Title: "Mapped EUA Target Endpoint"
Description: "Peger fra et offentligt udstillet endpoint til det reelle EUA-endpoint, som VANS eller EHMI skal mappe til."
* ^context[+].type = #element
* ^context[=].expression = "Endpoint"
* value[x] only Reference(EerEuaTargetEndpoint)
* valueReference 1..1 MS

// 2. Profil for Offentligt Endpoint (VANS eller EHMI)
Profile: EerPublicMessagingEndpoint
Parent: Endpoint
Id: eer-public-messaging-endpoint
Title: "EER Public Messaging Endpoint"
Description: "Udstiller hvilke meddelelsestyper en organisation kan modtage fra omverdenen via EHMI eller VANS."
* identifier 1..* MS
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier contains gln 1..1 MS
* identifier[gln].use = #official
* identifier[gln].system = $GS1_GLN (exactly)
* identifier[gln].value 1..1 MS
* connectionType 1..1 MS // F.eks. 'ehmi-ap' eller 'medcom-vans'
* managingOrganization 1..1 MS
* payloadType 1..* MS
* payloadType from http://medcomehmi.dk (required)
* payloadMimeType 1..* MS
* extension contains MappedEuaTargetEndpoint named euaTarget 0..* MS

// 3. Profil for Reelt EUA Endpoint (Internt mål for mapning)
Profile: EerEuaTargetEndpoint
Parent: Endpoint
Id: eer-eua-target-endpoint
Title: "EER EUA Target Endpoint"
Description: "Angiver hvilket format og transportlag slutbrugerapplikationen (EUA) reelt kan indlæse."
* identifier 1..* MS
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier contains euaGln 1..1 MS
* identifier[euaGln].use = #secondary
* identifier[euaGln].system = $EUA_GLN_EDI (exactly)
* identifier[euaGln].value 1..1 MS
* connectionType 1..1 MS // F.eks. 'eua-native-vans' eller 'eua-native-ehmi'
* managingOrganization 1..1 MS
* payloadType 1..* MS
* payloadMimeType 1..* MS

*/