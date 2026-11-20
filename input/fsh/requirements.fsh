// =========================================================================
// Kravspecifikation for EHMI/VANS Overgangs- og Mapningsarkitektur
// =========================================================================
Instance: EhmiVansTransitionRequirements
InstanceOf: Requirements
Title: "Requirement - Krav til EHMI/VANS Overgangs- og Mapningsarkitektur"
Description: "Funktionelle og tekniske krav til opslag i EER, formatkonvertering og symmetrisk kvitteringshåndtering på tværs af MSH-topologier."
* url = "http://medcomehmi.dk"
* version = "1.0.0"
* name = "EhmiVansTransitionRequirements"
* title = "Krav til EHMI/VANS Overgangs- og Mapningsarkitektur"
* status = #draft
* experimental = false
* date = "2026-11-19"
* publisher = "MedCom"

// Tilknyt de involverede aktører til kravspecifikationen
* actor[+] = Canonical(EerRegistryActor)
* actor[+] = Canonical(SendingMshActor)
* actor[+] = Canonical(ReceivingMshActor)
* actor[+] = Canonical(ReceivingEuaActor)

// -------------------------------------------------------------------------
// KRAV 1: Opslag på offentligt vs. reelt EUA-endpoint
// -------------------------------------------------------------------------
* statement[+].key = "REQ-EER-01"
* statement[=].label = "Adskillelse af offentlig routing og intern EUA-kapabilitet"
* statement[=].conformance = #SHALL
* statement[=].requirement = """
EER SKAL udstille modtagerens offentligt aftalte udvekslingsformat under `https://gs1.org` 
og slutbrugerapplikationens (EUA) reelle format under `https://medcom.dk` 
for samme organisatoriske enhed.
"""
* statement[=].satisfiedBy[+] = "StructureDefinition-eer-public-messaging-endpoint.html"
//* statement[=].satisfiedBy[+] = "http://medcomehmi.dk/ig/ehmiTransitionsModel/StructureDefinition/eer-public-messaging-endpoint"

// -------------------------------------------------------------------------
// KRAV 2: Afsender-MSH datadrevet formatvurdering
// -------------------------------------------------------------------------
* statement[+].key = "REQ-MSH-01"
* statement[=].label = "Afsender-MSH opgradering til offentligt udvekslingsformat"
* statement[=].conformance = #SHALL
* statement[=].requirement = """
Afsender-MSH SKAL sammenholde afsenderens eget `eua-gln` med modtagerens offentlige `gs1.org/gln` i EER. 
Hvis `payloadType` eller `payloadMimeType` afviger, SKAL Afsender-MSH konvertere meddelelsen til det offentlige format før afsendelse.
"""
* statement[=].source.display = "SendingMshActor"

// -------------------------------------------------------------------------
// KRAV 3: Modtager-MSH tilpasning til EUA-format
// -------------------------------------------------------------------------
* statement[+].key = "REQ-MSH-02"
* statement[=].label = "Modtager-MSH konvertering til EUA-format"
* statement[=].conformance = #SHALL
* statement[=].requirement = """
Modtager-MSH SKAL ved modtagelse af en meddelelse slå modtagerens `eua-gln` op i EER. 
Hvis EUA'ens reelle format afviger fra det indkommende format, SKAL Modtager-MSH konvertere meddelelsen til EUA'ens format før aflevering.
"""
* statement[=].source.display = "ReceivingMshActor"

// -------------------------------------------------------------------------
// KRAV 4: Symmetrisk kvitteringsmapning (CTL / Acknowledgement)
// -------------------------------------------------------------------------
* statement[+].key = "REQ-ACK-01"
* statement[=].label = "Tilbageoversættelse af forretningskvitteringer"
* statement[=].conformance = #SHALL
* statement[=].requirement = """
Enhver MSH, der har konverteret en indkommende eller udgående forretningsmeddelelse, SKAL opfange den tilhørende 
forretningskvittering (positiv eller negativ CTL/Acknowledgement) og konvertere den tilbage til det format, den forudgående part forventer.
"""

// -------------------------------------------------------------------------
// KRAV 5: Fejlhåndtering ved datatab under nedkonvertering
// -------------------------------------------------------------------------
* statement[+].key = "REQ-ERR-01"
* statement[=].label = "Negativ kvittering ved konverteringsfejl eller datatab"
* statement[=].conformance = #SHALL
* statement[=].requirement = """
Hvis en formatkonvertering (f.eks. fra FHIR til OIOXML eller EDIFACT) fejler eller medfører tab af klinisk kritiske data, 
SKAL den konverterende MSH afvise meddelelsen og returnere en negativ forretningskvittering i afsenderens format.
"""
