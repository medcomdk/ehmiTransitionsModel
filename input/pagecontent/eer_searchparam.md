Konkrete EER Søgeparametre for Afsender, EHMI og VANS

Når Identifier.system adskiller offentlig og intern routing, bliver opslagene i EER's FHIR API helt entydige:

• 1. Afsendersystemet (EAS / Afsender-EUA) slår modtager op:
Afsenderen søger udelukkende på det officielle GS1 GLN-system og den meddelelsestype, afsenderen vil sende. Afsenderen ser aldrig EUA-endpointet.http

GET [eer-base]/Endpoint?identifier=https://gs1.org|5790001234567&payload-type=http://medcomfhir.dk|4.0.0&status=active


• 2. VANS-leverandør eller EHMI-komponent henter mapningsmål (via Extension):
Hvis komponenten allerede har det offentlige endpoint, kan den inkludere det linkede EUA-endpoint i ét samlet kald med _include:http

GET [eer-base]/Endpoint?identifier=https://gs1.org|5790001234567&_include=Endpoint:mapped-eua-target

• 3. VANS-leverandør eller EHMI-komponent slår direkte op på EUA-kapabilitet:
Når en indkommende besked rammer modtagerens VANS eller EHMI Access Point for GLN 5790001234567, slår komponenten op på eua-gln navnerummet for at se, hvilket slutformat EUA kræver:http

GET [eer-base]/Endpoint?identifier=https://medcom.dk|5790001234567&status=active
