/*
Instance: Org-Laegehus-Nord
InstanceOf: Organization
* identifier[0].system = $GS1_GLN
* identifier[0].value = "5790001234567"
* name = "Lægehus Nord"
* endpoint[0] = Reference(Ep-Public-Ehmi-5790001234567)
* endpoint[1] = Reference(Ep-Eua-Target-5790001234567)

Instance: Ep-Public-Ehmi-5790001234567
InstanceOf: EerPublicMessagingEndpoint
* status = #active
* identifier[gln].value = "5790001234567"
* connectionType = $EER_CONN_TYPE#ehmi-ap "EHMI Access Point (eDelivery AS4)"
* managingOrganization = Reference(Org-Laegehus-Nord)
* address = "https://ehmi.dk"
* payloadType[0] = $MEDCOM_MSG_DEF#http://medcomfhir.dk|4.0.0
* payloadMimeType[0] = #application/fhir+xml
* payloadMimeType[1] = #application/fhir+json
* extension[euaTarget].valueReference = Reference(Ep-Eua-Target-5790001234567)

Instance: Ep-Eua-Target-5790001234567
InstanceOf: EerEuaTargetEndpoint
* status = #active
* identifier[euaGln].value = "5790001234567"
* connectionType = $EER_CONN_TYPE#medcom-vans "MedCom VANS Mailbox"
* managingOrganization = Reference(Org-Laegehus-Nord)
* address = "vans://vansleverandoer.dk/5790001234567"
* payloadType[0] = $MEDCOM_MSG_DEF#urn:medcom:oioxml:DIS91:1.0.0
* payloadMimeType[0] = #application/xml
*/