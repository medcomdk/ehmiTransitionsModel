Instance: ExampleEHMIDeliveryTimeline
InstanceOf: EHMIDeliveryStatusCommunication
Title: "Eksempel på EDS-tidslinje med fejl i sidste led"
Description: "Viser forløbet af EDS-events for en meddelelse, der fejler ved levering til modtager."
Usage: #example

* status = #entered-in-error
* category.coding.system = "http://medcomehmi.dk"
* category.coding.code = #delivery-failure

* identifier[originalMessageId].system = "http://medcomehmi.dk"
* identifier[originalMessageId].value = "b2c8d1e0-4a1f-4e9b-9c3a-1f2e3d4c5b6a"

* sent = "2026-11-18T10:15:00+01:00"

// Event 1: Afsendt fra MSH (OK)
* payload[0].extension[timestamp].valueDateTime = "2026-11-18T10:15:02+01:00"
* payload[0].extension[eventCode].valueCoding = EHMIDeliveryEventCS#msg-sent
* payload[0].extension[node].valueIdentifier.system = "iso6523-actorid-upis"
* payload[0].extension[node].valueIdentifier.value = "0088:5790000120314"
* payload[0].contentString = "10:15:02 - Afsendt fra Odense Universitetshospitals MSH."

// Event 2: Videresendt via Access Point (OK)
* payload[1].extension[timestamp].valueDateTime = "2026-11-18T10:15:05+01:00"
* payload[1].extension[eventCode].valueCoding = EHMIDeliveryEventCS#ap-forwarded
* payload[1].contentString = "10:15:05 - Routet gennem eDelivery Access Point."

// Event 3: Fejlet ved modtager (Fejl)
* payload[2].extension[timestamp].valueDateTime = "2026-11-18T10:16:12+01:00"
* payload[2].extension[eventCode].valueCoding = EHMIDeliveryEventCS#delivery-failed
* payload[2].extension[node].valueIdentifier.system = "iso6523-actorid-upis"
* payload[2].extension[node].valueIdentifier.value = "0088:5790000121526"
* payload[2].contentString = "10:16:12 - Fejl (AS4-0004): Ukendt modtager-endpoint hos Odense Kommune."
