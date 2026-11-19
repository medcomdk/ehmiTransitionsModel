CodeSystem: EHMIDeliveryEventCS
Id: ehmi-delivery-event-cs
Title: "EHMI Delivery Status (EDS) Event Codes"
Description: "Hændelsestyper i en meddelelses rejse gennem EHMI-infrastrukturen."
* ^status = #draft
* ^caseSensitive = true
* ^content = #complete

* #msg-sent "Afsendt fra MSH" "Meddelelsen er pakket i ehmiSBDH og afsendt fra afsenders MSH."
* #ap-forwarded "Videresendt via Access Point" "Meddelelsen er routet gennem eDelivery Access Point."
* #msh-received "Modtaget hos modtagers MSH" "Meddelelsen er modtaget og pakket ud hos modtagers MSH."
* #eua-delivered "Leveret til slutsystem (EUA)" "Meddelelsen er afleveret til modtagerens fagsystem."
* #delivery-failed "Levering fejlet" "En fejl opstod i et af knudepunkterne."

ValueSet: EHMIDeliveryEventVS
Id: ehmi-delivery-event-vs
Title: "EHMI Delivery Status (EDS) Event ValueSet"
* ^status = #draft
* include codes from system EHMIDeliveryEventCS

// -----------------------------------------------------------------------------

Extension: EDSEventTimestamp
Id: eds-event-timestamp
Title: "EDS Event Timestamp"
Description: "Præcist tidspunkt for hvornår EDS-hændelsen fandt sted."
* value[x] only dateTime

Extension: EDSEventCode
Id: eds-event-code
Title: "EDS Event Code"
Description: "Struktureret statuskode for det enkelte EDS-trin."
* value[x] only Coding
* valueCoding from EHMIDeliveryEventVS (required)

Extension: EDSNodeIdentifier
Id: eds-node-identifier
Title: "EDS Node Identifier"
Description: "Identifikation (EAN/SOR) på det knudepunkt der rapporterede hændelsen."
* value[x] only Identifier

// -----------------------------------------------------------------------------

Profile: EHMIDeliveryStatusCommunication
Parent: Communication
Id: ehmi-delivery-status-communication
Title: "EHMI Delivery Status Timeline Communication"
Description: "Samlet leveringslog over EDS-events for en given meddelelse mellem MSH og EUA."
* ^status = #draft

// Status afspejler den samlede tilstand: in-progress | completed | entered-in-error
* status 1..1

// Kategori = eds-tracking
* category 1..1

// Korrelation til oprindelig meddelelse
* identifier 1..*
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier contains originalMessageId 1..1
* identifier[originalMessageId].system = "http://medcomehmi.dk" (exactly)
* identifier[originalMessageId].value 1..1

// Hvert payload-element repræsenterer ét EDS-event i kronologisk rækkefølge
* payload 1..*
* payload.extension contains
    EDSEventTimestamp named timestamp 1..1 and
    EDSEventCode named eventCode 1..1 and
    EDSNodeIdentifier named node 0..1
* payload.content[x] only string
* payload.contentString 1..1
