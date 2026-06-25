// Minimal CapabilityStatement for the PZP data holder (server).
// The authorisation policy requires conformance to a CapabilityStatement to be evaluated for
// FHIR endpoint requests (see the Exchange Architecture volume).
Instance: PZPDataHolder
InstanceOf: CapabilityStatement
Usage: #definition
Title: "PZP Data Holder CapabilityStatement"
Description: "Capabilities a data holder exposes in the PZP pull flow: BSN-based Patient search to resolve the patient's technical identifier, followed by patient-scoped data requests."

* url = "https://nuts-foundation.github.io/nl-pzp-ig/CapabilityStatement/PZPDataHolder"
* name = "PZPDataHolder"
* title = "PZP Data Holder CapabilityStatement"
* status = #draft
* experimental = true
* date = "2026-06-25"
* publisher = "Stichting Nuts"
* kind = #requirements
* fhirVersion = #4.0.1
* format[0] = #json
* format[+] = #xml

* rest.mode = #server
* rest.documentation = "All interactions are patient-scoped and protected by Nuts-based authentication, policy-based authorisation and an explicit consent check."

// Patient: BSN-based POST search to obtain the technical identifier
* rest.resource[0].type = #Patient
* rest.resource[=].documentation = "POST-based search on BSN (identifier.system = http://fhir.nl/fhir/NamingSystem/bsn) per IHE PDQm ITI-78. GET-based search is not allowed."
* rest.resource[=].interaction[0].code = #search-type
* rest.resource[=].searchParam[0].name = "identifier"
* rest.resource[=].searchParam[=].type = #token
