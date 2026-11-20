Alias: $GS1_GLN = https://gs1.org
Alias: $EUA_GLN = https://medcom.dk
Alias: $EER_CONN_TYPE = http://medcomehmi.dk
Alias: $MEDCOM_MSG_DEF = http://medcomehmi.dk
Alias: $OBLIGATION_EXT = http://hl7.org

// =========================================================================
// Parametriseret RuleSet til FHIR Obligations (sikker mod komma/parenteser)
// =========================================================================
RuleSet: SetObligation(actor, code)
* ^extension[+].url = $OBLIGATION_EXT
* ^extension[=].extension[+].url = "code"
* ^extension[=].extension[=].valueCode = {code}
* ^extension[=].extension[+].url = "actor"
* ^extension[=].extension[=].valueCanonical = Canonical({actor})

// =========================================================================
// Custom SearchParameter til tidsstyret cutover på Endpoint.period
// =========================================================================
Instance: EndpointPeriodSearchParameter
InstanceOf: SearchParameter
Title: "Endpoint Period SearchParameter"
Description: "Gør det muligt at søge og filtrere Endpoints på deres gyldighedsperiode (Endpoint.period) ved planlagt cutover mellem VANS og EHMI."
* url = "http://medcomehmi.dk"
* version = "1.0.0"
* name = "EndpointPeriodSearchParameter"
* status = #draft
* experimental = false
* date = "2026-11-20"
* publisher = "MedCom"
* description = "Søgeparameter for Endpoint.period (start og end) til understøttelse af tidsstyret transportskifte."
* code = #date
* base = #Endpoint
* type = #date
* expression = "Endpoint.period"
* comparator[+] = #eq
* comparator[+] = #ge
* comparator[+] = #le
* comparator[+] = #gt
* comparator[+] = #lt

// =========================================================================
// Extension til at koble offentligt endpoint til reelt EUA-endpoint
// =========================================================================
Extension: MappedEuaTargetEndpoint
Id: mapped-eua-target-endpoint
Title: "Mapped EUA Target Endpoint"
Description: "Peger fra et offentligt udstillet endpoint til det reelle EUA-endpoint, som VANS eller EHMI skal mappe til."
* ^context[+].type = #element
* ^context[=].expression = "Endpoint"
* value[x] only Reference(EerEuaTargetEndpoint)
* valueReference 1..1 MS

// =========================================================================
// 1. Profil for Offentligt Endpoint (VANS eller EHMI inkl. Cutover Period)
// =========================================================================
Profile: EerPublicMessagingEndpoint
Parent: Endpoint
Id: eer-public-messaging-endpoint
Title: "EER Public Messaging Endpoint"
Description: "Udstiller hvilke meddelelsestyper en organisation kan modtage fra omverdenen via EHMI eller VANS, inkl. tidsstyret gyldighedsperiode."

* name 1..1 MS
* identifier 1..* MS
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier contains gln 1..1 MS
* identifier[gln].use = #official
* identifier[gln].system = $GS1_GLN (exactly)
* identifier[gln].value 1..1 MS
* identifier[gln] insert SetObligation(EerRegistryActor, #SHALL:persist)
* identifier[gln] ^extension[=].extension[+].url = "documentation"
* identifier[gln] ^extension[=].extension[=].valueMarkdown = "EER skal lagre og udstille det officielle GLN til offentlig routing."
* identifier[gln] insert SetObligation(SendingMshActor, #SHALL:handle)
* identifier[gln] ^extension[=].extension[+].url = "documentation"
* identifier[gln] ^extension[=].extension[=].valueMarkdown = "Afsender-MSH skal bruge dette GLN til at fremsøge modtagerens offentlige udvekslingsformat."

* connectionType 1..1 MS
* managingOrganization 1..1 MS

* period 1..1 MS
* period.start 1..1 MS
* period.end 0..1 MS
* period insert SetObligation(SendingMshActor, #SHALL:handle)
* period ^extension[=].extension[+].url = "documentation"
* period ^extension[=].extension[=].valueMarkdown = "Afsender-MSH SKAL kun benytte endpoints, hvor det aktuelle afsendelsestidspunkt ligger inden for period.start og period.end."

* payloadType 1..* MS
* payloadType insert SetObligation(SendingMshActor, #SHALL:handle)
* payloadType ^extension[=].extension[+].url = "documentation"
* payloadType ^extension[=].extension[=].valueMarkdown = "Afsender-MSH skal sikre, at afsendt meddelelse overholder en af de angivne payloadTypes."

* payloadMimeType 1..* MS
* payloadMimeType insert SetObligation(SendingMshActor, #SHALL:handle)
* payloadMimeType ^extension[=].extension[+].url = "documentation"
* payloadMimeType ^extension[=].extension[=].valueMarkdown = "Afsender-MSH skal serialisere meddelelsen i en understøttet MimeType."

* extension contains MappedEuaTargetEndpoint named euaTarget 0..* MS
* extension[euaTarget] insert SetObligation(ReceivingMshActor, #SHALL:handle)
* extension[euaTarget] ^extension[=].extension[+].url = "documentation"
* extension[euaTarget] ^extension[=].extension[=].valueMarkdown = "Modtager-MSH skal følge denne reference for at afgøre, om beskeden skal konverteres til EUA'ens native format."
* extension[euaTarget] insert SetObligation(SendingMshActor, #MAY:ignore)
* extension[euaTarget] ^extension[=].extension[+].url = "documentation"
* extension[euaTarget] ^extension[=].extension[=].valueMarkdown = "Afsender-MSH må ikke afhænge af modtagerens interne EUA-endpoint ved offentlig routing."

// =========================================================================
// 2. Profil for Reelt EUA Endpoint (Internt mål for mapning)
// =========================================================================
Profile: EerEuaTargetEndpoint
Parent: Endpoint
Id: eer-eua-target-endpoint
Title: "EER EUA Target Endpoint"
Description: "Angiver hvilket format og transportlag slutbrugerapplikationen (EUA) reelt kan indlæse."

* name 1..1 MS
* identifier 1..* MS
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier contains euaGln 1..1 MS
* identifier[euaGln].use = #secondary
* identifier[euaGln].system = $EUA_GLN (exactly)
* identifier[euaGln].value 1..1 MS
* identifier[euaGln] insert SetObligation(EerRegistryActor, #SHALL:persist)
* identifier[euaGln] ^extension[=].extension[+].url = "documentation"
* identifier[euaGln] ^extension[=].extension[=].valueMarkdown = "EER skal lagre og udstille EUA-endpointet under eua-gln navnerummet."
* identifier[euaGln] insert SetObligation(ReceivingMshActor, #SHALL:handle)
* identifier[euaGln] ^extension[=].extension[+].url = "documentation"
* identifier[euaGln] ^extension[=].extension[=].valueMarkdown = "Modtager-MSH skal slå op på dette eua-gln ved modtagelse af beskeder."

* connectionType 1..1 MS
* managingOrganization 1..1 MS
* period 0..1 MS

* payloadType 1..* MS
* payloadType insert SetObligation(ReceivingEuaActor, #SHALL:populate)
* payloadType ^extension[=].extension[+].url = "documentation"
* payloadType ^extension[=].extension[=].valueMarkdown = "Modtager-EUA eller dens leverandør skal sikre, at payloadType afspejler fagsystemets faktiske indlæsningskapabilitet."
* payloadType insert SetObligation(ReceivingMshActor, #SHALL:handle)
* payloadType ^extension[=].extension[+].url = "documentation"
* payloadType ^extension[=].extension[=].valueMarkdown = "Modtager-MSH skal konvertere indkommende beskeder til denne payloadType."

* payloadMimeType 1..* MS
* payloadMimeType insert SetObligation(ReceivingMshActor, #SHALL:handle)
* payloadMimeType ^extension[=].extension[+].url = "documentation"
* payloadMimeType ^extension[=].extension[=].valueMarkdown = "Modtager-MSH skal levere beskeden til EUA i den angivne MimeType."

// =========================================================================
// EKSEMPLER: Tidsstyret Cutover (VANS -> EHMI) & Forskellige MimeTypes
// =========================================================================

Instance: Org-Laegehus-Nord
InstanceOf: Organization
Title: "Lægehus Nord (Eksempelorganisation)"
Description: "Eksempel på en organisation med tidsstyret cutover fra VANS til EHMI under samme GLN."
* identifier.system = $GS1_GLN
* identifier.value = "5790001234567"
* name = "Lægehus Nord"
* endpoint[+] = Reference(Ep-Public-Vans-Cutover-5790001234567)
* endpoint[+] = Reference(Ep-Public-Ehmi-Cutover-5790001234567)
* endpoint[+] = Reference(Ep-Eua-Target-Oioxml-5790001234567)
* endpoint[+] = Reference(Ep-Eua-Target-Edifact-5790001234567)

// 1. Offentligt VANS endpoint: Gyldigt FREM TIL 1. dec 2026 kl. 00:00
Instance: Ep-Public-Vans-Cutover-5790001234567
InstanceOf: EerPublicMessagingEndpoint
Title: "Offentligt VANS Endpoint - Udfases 1. dec 2026 (Lægehus Nord)"
Description: "Aktivt frem til cutover-tidspunktet, hvorefter trafikken automatisk skifter til EHMI."
* name = "Offentligt VANS Endpoint - Udfases 1. dec 2026 (Lægehus Nord)"
* status = #active
* identifier[gln].value = "5790001234567"
* connectionType = $EER_CONN_TYPE#medcom-vans "MedCom VANS Mailbox"
* managingOrganization = Reference(Org-Laegehus-Nord)
* address = "vans://vansleverandoer.dk/5790001234567"
* period.start = "2025-01-01T00:00:00+01:00"
* period.end = "2026-12-01T00:00:00+01:00"
* payloadType[+] = $MEDCOM_MSG_DEF#http://medcomfhir.dk|4.0.0
* payloadType[+] = $MEDCOM_MSG_DEF#http://medcomfhir.dk|3.0.0
* payloadMimeType[+] = #application/fhir+json
* payloadMimeType[+] = #application/fhir+xml
* extension[euaTarget][+].valueReference = Reference(Ep-Eua-Target-Oioxml-5790001234567)
* extension[euaTarget][+].valueReference = Reference(Ep-Eua-Target-Edifact-5790001234567)

