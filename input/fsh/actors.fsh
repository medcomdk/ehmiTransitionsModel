// =========================================================================
// 1. EER (EHMI Endpoint Register)
// =========================================================================
Instance: EerRegistryActor
InstanceOf: ActorDefinition
Title: "Actor - EER (EHMI Endpoint Register)"
Description: "Centralt register der udstiller adresserings- og kapabilitetsoplysninger for både offentlige endpoints og reelle EUA-endpoints."
* url = "http://medcomehmi.dk"
* version = "1.0.0"
* name = "EerRegistryActor"
* title = "EER (EHMI Endpoint Register)"
* status = #draft
* experimental = false
* date = "2026-11-19"
* publisher = "MedCom"
* type = #system
* purpose = "At fungere som Single Source of Truth for både offentligt udstillede modtager-kapabiliteter (gs1.org/gln) og slutsystemernes reelle kapabiliteter (eua-gln)."
* documentation = """
**Ansvar og forpligtelser:**
1. SKAL opbevare og udstille offentlige routing-endpoints under `https://gs1.org`.
2. SKAL opbevare og udstille reelle EUA-kapabilitetsendpoints under `https://medcom.dk`.
3. SKAL understøtte FHIR søgeparametre på `identifier`, `payload-type` og `status`, så MSH-komponenter entydigt kan udlede mapningsbehov.
4. SKAL sikre adgangskontrol, så kun autoriserede leverandører eller administratorer kan opdatere `eua-gln` endpoints.
"""

// =========================================================================
// 2. Afsender EUA (Slutbrugerapplikation)
// =========================================================================
Instance: SendingEuaActor
InstanceOf: ActorDefinition
Title: "Actor - Afsender EUA (Slutbrugerapplikation)"
Description: "Det afsendende kliniske fagsystem, der producerer den oprindelige sundhedsfaglige meddelelse."
* url = "http://medcomehmi.dk"
* version = "1.0.0"
* name = "SendingEuaActor"
* title = "Afsender EUA (Slutbrugerapplikation)"
* status = #draft
* experimental = false
* date = "2026-11-19"
* publisher = "MedCom"
* type = #system
* purpose = "At generere en valid sundhedsfaglig meddelelse i fagsystemets eget understøttede format og håndtere modtagne kvitteringer."
* documentation = """
**Ansvar og forpligtelser:**
1. SKAL danne meddelelsen i det format, der er registreret på organisationens eget `eua-gln` i EER (f.eks. FHIR, OIOXML eller EDIFACT).
2. SKAL overdrage meddelelsen til sin tilknyttede Afsender-MSH (enten internt i samme applikation eller via lokalt interface).
3. SKAL kunne modtage og præsentere både positive og negative kvitteringer i sit eget native format.
4. BEHØVER IKKE kende til modtagerens faktiske fagsystemformat eller transportprotokol.
"""

// =========================================================================
// 3. Afsender MSH (Message Service Handler)
// =========================================================================
Instance: SendingMshActor
InstanceOf: ActorDefinition
Title: "Actor - Afsender MSH (Message Service Handler)"
Description: "Komponent på afsendersiden (standalone, i EUA eller i AP/VANS), der sikrer at meddelelsen afsendes i det offentligt aftalte format."
* url = "http://medcomehmi.dk"
* version = "1.0.0"
* name = "SendingMshActor"
* title = "Afsender MSH (Message Service Handler)"
* status = #draft
* experimental = false
* date = "2026-11-19"
* publisher = "MedCom"
* type = #system
* purpose = "At bygge bro mellem afsender-EUA'ens interne format og modtagerens offentligt udstillede endpoint-krav."
* documentation = """
**Ansvar og forpligtelser:**
1. SKAL slå afsenderens eget `eua-gln` og modtagerens offentlige `gs1.org/gln` op i EER.
2. SKAL sammenligne `payloadType` og `payloadMimeType` mellem kilde og offentligt mål.
3. SKAL konvertere meddelelsen til det offentligt udstillede format (f.eks. opgradere OIOXML til kanonisk FHIR), hvis formaterne afviger.
4. SKAL konvertere indkommende kvitteringer (Acknowledgement/CTL) fra det offentlige format tilbage til afsender-EUA'ens native format.
5. SKAL generere en negativ kvittering til Afsender-EUA, hvis konverteringen til det offentlige format fejler.
"""

// =========================================================================
// 4. Transport Gateway (EHMI Access Point / VANS Netværk)
// =========================================================================
Instance: TransportGatewayActor
InstanceOf: ActorDefinition
Title: "Actor - Transport Gateway (EHMI AP / VANS)"
Description: "Den netværksvendte kommunikationskomponent, der flytter meddelelsen sikkert mellem afsender- og modtagerdomæne."
* url = "http://medcomehmi.dk"
* version = "1.0.0"
* name = "TransportGatewayActor"
* title = "Transport Gateway (EHMI AP / VANS)"
* status = #draft
* experimental = false
* date = "2026-11-19"
* publisher = "MedCom"
* type = #system
* purpose = "At sikre pålidelig, krypteret og sporbar transport af meddelelser og kvitteringer mellem organisationer."
* documentation = """
**Ansvar og forpligtelser:**
1. SKAL modtage meddelelsen i det format, der matcher det offentlige endpoint (`connectionType` f.eks. `ehmi-ap` eller `medcom-vans`).
2. SKAL route meddelelsen til modtagerens gateway baseret på det offentlige `gs1.org/gln`.
3. MÅ IKKE ændre i det kliniske payload uden for en tilknyttet MSH-rolle.
4. SKAL levere transportkvitteringer og sporbarhedsdata (f.eks. til EDS - EHMI Delivery Status).
"""

// =========================================================================
// 5. Modtager MSH (Message Service Handler)
// =========================================================================
Instance: ReceivingMshActor
InstanceOf: ActorDefinition
Title: "Actor - Modtager MSH (Message Service Handler)"
Description: "Komponent på modtagersiden (i AP/VANS, standalone eller i EUA), der tilpasser indkommende meddelelser til modtager-EUA'ens reelle kapabilitet."
* url = "http://medcomehmi.dk"
* version = "1.0.0"
* name = "ReceivingMshActor"
* title = "Modtager MSH (Message Service Handler)"
* status = #draft
* experimental = false
* date = "2026-11-19"
* publisher = "MedCom"
* type = #system
* purpose = "At sikre at indkommende meddelelser i det offentlige udvekslingsformat leveres i det præcise format og den serialisering, som modtagerens EUA kan indlæse."
* documentation = """
**Ansvar og forpligtelser:**
1. SKAL slå modtagerorganisationens `eua-gln` op i EER ved modtagelse af en besked.
2. SKAL sammenligne den indkommende meddelelses `payloadType` og `payloadMimeType` med kravene på `eua-gln`.
3. SKAL eksekvere formatkonvertering (f.eks. FHIR til OIOXML eller EDIFACT), hvis EUA'en ikke understøtter det indkommende format nativt.
4. SKAL opfange EUA'ens lokale kvittering (CTL/Ack) og konvertere den tilbage til det offentlige format, som afsenderen forventer.
5. SKAL generere og returnere en negativ kvittering i det offentlige format til afsenderen, hvis nedkonvertering til EUA-formatet fejler eller medfører kritisk datatab.
"""

// =========================================================================
// 6. Modtager EUA (Slutbrugerapplikation)
// =========================================================================
Instance: ReceivingEuaActor
InstanceOf: ActorDefinition
Title: "Actor - Modtager EUA (Slutbrugerapplikation)"
Description: "Det modtagende kliniske fagsystem, der indlæser meddelelsen til klinisk brug og kvitterer for modtagelsen."
* url = "http://medcomehmi.dk"
* version = "1.0.0"
* name = "ReceivingEuaActor"
* title = "Modtager EUA (Slutbrugerapplikation)"
* status = #draft
* experimental = false
* date = "2026-11-19"
* publisher = "MedCom"
* type = #system
* purpose = "At indlæse sundhedsfaglige meddelelser i fagsystemets native format og afsende forretningsmæssig kvittering."
* documentation = """
**Ansvar og forpligtelser:**
1. SKAL holde sit reelle kapabilitets-endpoint (`eua-gln`) opdateret i EER (direkte eller via sin leverandør).
2. SKAL kunne indlæse alle meddelelsestyper og MimeTypes, der er deklareret på organisationens `eua-gln`.
3. SKAL afsende en positiv eller negativ forretningskvittering i sit native format til Modtager-MSH efter behandling af meddelelsen.
"""

// =========================================================================
// Extension & RuleSet til sammensatte topologi-aktører
// =========================================================================

Extension: ComposedOfActor
Id: composed-of-actor
Title: "Composed Of Actor"
Description: "Angiver hvilke atomare ansvarsområder (ActorDefinitions) en sammensat systemkomponent varetager i en given deployment-topologi."
* ^context[+].type = #element
* ^context[=].expression = "ActorDefinition"
* value[x] only canonical
* valueCanonical 1..1 MS

RuleSet: TopologyActorMetadata
* version = "1.0.0"
* status = #draft
* experimental = false
* date = "2026-11-19"
* publisher = "MedCom"
* type = #system

// =========================================================================
// AFSENDERSIDE TOPOLOGIER (Variant A1 - A3)
// =========================================================================

// Variant A1: Integreret Afsender EUA + MSH
Instance: TopologyA1IntegratedSendingEuaMsh
InstanceOf: ActorDefinition
Title: "Actor - Integreret Afsender EUA + MSH"
Description: "Fagsystem på afsendersiden der kombinerer klinisk meddelelsesdannelse (EUA) og EER-opslag/formatkonvertering (MSH) i én applikation."
* url = "http://medcomehmi.dk"
* name = "TopologyA1IntegratedSendingEuaMsh"
* insert TopologyActorMetadata
* purpose = "At lade moderne fagsystemer håndtere både forretningslogik og kanonisk formattilpasning internt før aflevering til AP/VANS."
* extension[+].url = "http://medcomehmi.dk"
* extension[=].valueCanonical = Canonical(SendingEuaActor)
* extension[+].url = "http://medcomehmi.dk"
* extension[=].valueCanonical = Canonical(SendingMshActor)

// Variant A2: Standalone Afsender MSH (mellem EUA og AP/VANS)
Instance: TopologyA2StandaloneSendingMsh
InstanceOf: ActorDefinition
Title: "Actor - Standalone Afsender MSH"
Description: "Dedikeret integrationsmotor på afsendersiden (f.eks. regional servicebus), der varetager MSH-rollen mellem et klassisk fagsystem og AP/VANS."
* url = "http://medcomehmi.dk"
* name = "TopologyA2StandaloneSendingMsh"
* insert TopologyActorMetadata
* derivedFrom = Canonical(SendingMshActor)
* purpose = "At afkoble ældre fagsystemer fra EER-opslag og kanonisk formatkonvertering via en lokal eller regional integrationsplatform."

// Variant A3: Integreret Afsender MSH + AP/VANS
Instance: TopologyA3IntegratedSendingMshGateway
InstanceOf: ActorDefinition
Title: "Actor - Integreret Afsender MSH + AP/VANS"
Description: "Leverandør-gateway (VANS-leverandør eller hosted EHMI AP) der kombinerer MSH-konvertering og netværkstransport i én samlet service."
* url = "http://medcomehmi.dk"
* name = "TopologyA3IntegratedSendingMshGateway"
* insert TopologyActorMetadata
* purpose = "At lade afsenderens VANS- eller AP-leverandør opgradere ældre meddelelsesformater til det offentligt aftalte format før transport."
* extension[+].url = "http://medcomehmi.dk"
* extension[=].valueCanonical = Canonical(SendingMshActor)
* extension[+].url = "http://medcomehmi.dk"
* extension[=].valueCanonical = Canonical(TransportGatewayActor)

// =========================================================================
// MODTAGERSIDE TOPOLOGIER (Variant M1 - M3)
// =========================================================================

// Variant M1: Integreret Modtager EUA + MSH
Instance: TopologyM1IntegratedReceivingEuaMsh
InstanceOf: ActorDefinition
Title: "Actor - Integreret Modtager EUA + MSH"
Description: "Fagsystem på modtagersiden der kombinerer MSH-kapabilitetsvalidering og klinisk indlæsning (EUA) i én applikation."
* url = "http://medcomehmi.dk"
* name = "TopologyM1IntegratedReceivingEuaMsh"
* insert TopologyActorMetadata
* purpose = "At lade moderne modtagersystemer modtage det offentlige format direkte fra AP/VANS uden mellemliggende konverteringsled."
* extension[+].url = "http://medcomehmi.dk"
* extension[=].valueCanonical = Canonical(ReceivingMshActor)
* extension[+].url = "http://medcomehmi.dk"
* extension[=].valueCanonical = Canonical(ReceivingEuaActor)

// Variant M2: Standalone Modtager MSH (mellem AP/VANS og EUA)
Instance: TopologyM2StandaloneReceivingMsh
InstanceOf: ActorDefinition
Title: "Actor - Standalone Modtager MSH"
Description: "Dedikeret integrationsmotor på modtagersiden, der varetager MSH-rollen mellem AP/VANS og et ældre fagsystem."
* url = "http://medcomehmi.dk"
* name = "TopologyM2StandaloneReceivingMsh"
* insert TopologyActorMetadata
* derivedFrom = Canonical(ReceivingMshActor)
* purpose = "At nedkonvertere indkommende meddelelser fra det offentlige format til fagsystemets reelle format angivet på eua-gln."

// Variant M3: Integreret Modtager MSH + AP/VANS
Instance: TopologyM3IntegratedReceivingMshGateway
InstanceOf: ActorDefinition
Title: "Actor - Integreret Modtager MSH + AP/VANS"
Description: "Leverandør-gateway (VANS-leverandør eller hosted EHMI AP) der kombinerer netværksmodtagelse og MSH-konvertering til modtagerens EUA."
* url = "http://medcomehmi.dk"
* name = "TopologyM3IntegratedReceivingMshGateway"
* insert TopologyActorMetadata
* purpose = "At lade modtagerens VANS- eller AP-leverandør slå eua-gln op i EER og konvertere beskeden til EUA'ens format før aflevering i postkasse."
* extension[+].url = "http://medcomehmi.dk"
* extension[=].valueCanonical = Canonical(TransportGatewayActor)
* extension[+].url = "http://medcomehmi.dk"
* extension[=].valueCanonical = Canonical(ReceivingMshActor)
