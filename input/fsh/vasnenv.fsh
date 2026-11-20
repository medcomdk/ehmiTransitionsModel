Alias: $GS1_GLN = https://gs1.org
Alias: $SOR_ID = urn:oid:1.2.208.176.1.1

// Extensions til VANS Reliable Messaging & ServiceTags
Extension: VansReliableMessaging
Id: vans-reliable-messaging
Title: "VANS Reliable Messaging Extension"
Description: "Indeholder Reliable Messaging parametre fra MedCom VANSEnvelope."
* ^context[+].type = #element
* ^context[=].expression = "MessageHeader"
* extension contains
    transformMessage 0..1 MS and
    acknowledgementRequest 1..1 MS and
    originalMessageId 0..1 MS and
    correlationId 0..1 MS and
    retryCount 0..1 MS and
    timeToLive 0..1 MS and
    acknowledgementType 0..1 MS
* extension[transformMessage].value[x] only boolean
* extension[acknowledgementRequest].value[x] only boolean
* extension[originalMessageId].value[x] only id
* extension[correlationId].value[x] only id
* extension[retryCount].value[x] only integer
* extension[timeToLive].value[x] only dateTime
* extension[acknowledgementType].value[x] only code

Extension: VansServiceTag
Id: vans-service-tag
Title: "VANS Service Tag Extension"
Description: "Nøgle/værdi-par til netværksstyring (f.eks. MCM:MIME)."
* ^context[+].type = #element
* ^context[=].expression = "MessageHeader"
* extension contains
    name 1..1 MS and
    value 1..1 MS
* extension[name].value[x] only string
* extension[value].value[x] only string

// Profil: VANSEnvelopeProfile
Profile: VANSEnvelopeProfile
Parent: MessageHeader
Id: vans-envelope-profile
Title: "VANSEnvelope FHIR Profile (incl. Reliable Messaging)"
Description: "FHIR-profil baseret på VANSEnvelopeModel til repræsentation af MedCom VANS-kuvert og Reliable Messaging."

// Afsender (sender)
* sender 1..1 MS
* sender only Reference(Organization)

// Modtager (destination)
* destination 1..1 MS
* destination.receiver 1..1 MS
* destination.receiver only Reference(Organization)
* destination.endpoint 1..1 MS

// Dokumentmetadata (event[x] & definition)
* event[x] only Coding
* eventCoding 1..1 MS
* definition 1..1 MS // Indeholder standard, navn og version

// Reliable Messaging & ServiceTags
* extension contains
    VansReliableMessaging named reliableMessaging 1..1 MS and
    VansServiceTag named serviceTag 0..* MS

// Payload (focus -> Binary med base64 data)
* focus 1..1 MS
* focus only Reference(Binary)
