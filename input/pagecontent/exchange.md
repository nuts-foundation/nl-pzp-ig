This volume contains the technical agreements for exchanging PZP data. The content is adapted from
the Zorginzage 2026 building blocks so that this guide is self-contained; the PZP-specific choices
are noted where they apply.

### Exchange patterns: gericht bevragen and geïndexeerd bevragen

PZP data exchange uses the communication patterns "gericht bevragen" (targeted querying) and
"geïndexeerd bevragen" (indexed querying). See the [Whitepaper Communicatiepatronen](https://www.datavoorgezondheid.nl/documenten/2025/07/14/whitepaper-communicatiepatronen-vws)
of the Ministry of Health (in Dutch).

- **Gericht bevragen** — the data user already knows that data is present at a data holder,
  requests the data from that data holder, and receives or retrieves it.
- **Geïndexeerd bevragen** — the data user is looking for certain data, queries the localisation
  service (index), requests the data from the data holders that hold data according to the
  localisation service, and receives or retrieves it.

In this pilot gericht bevragen is always available; geïndexeerd bevragen applies once a localisation
service (NVI) is in place (see [Localisation](#localisation)).

A data exchange consists of the following steps:

1. **Addressing** — the data user finds the FHIR and OAuth endpoints of each data holder.
2. **Authentication** — the data user authenticates at organisation and person level.
3. **Localisation** — the data user determines which data holder(s) to query, optionally via the
   localisation service.
4. **Patient search** — the data user searches the patient on BSN at each targeted data holder to
   obtain the patient's technical identifier.
5. **Data request** — the data user requests data using that technical identifier.
6. **Authorisation** — the data holder authorises the request, including a check of explicit
   patient consent (see [Consent](#consent)).

### Principles

- This specification makes use of did:web and verifiable credentials (commonly referred to as
  "Nuts v6").
- This specification makes use of FHIR R4 APIs.

### Identification

#### Healthcare organisations — identifier: URA

Healthcare organisations are identified using the URA-number (UZI-Register Abonneenummer,
OID `2.16.528.1.1007.3.3`).

Rationale:

- Identification by URA conforms to the national information model for healthcare organisations
  (Zorginformatiebouwsteen Zorgaanbieder, [zibs.nl](https://zibs.nl/wiki/Zorgaanbieder-v3.6(2024NL))).
- The URA-number is issued by a public organisation (CIBG).
- The URA-number is cryptographically verifiable because it is contained in a PKI certificate
  (UZI-servercertificaat).

#### Healthcare organisations — HealthcareProviderRoleType

Healthcare organisations use a HealthcareProviderRoleType attribute to express which type(s) of
healthcare organisation they are. This type is a useful attribute in authorisation and
localisation, and is relevant for OTV-consent (Mitz). The credential is self-issued by each
organisation (see [Healthcare role type](#healthcare-role-type)).

#### Vendor organisations

Vendor organisations are not identified by a business identifier. They are authenticated at the
transport layer; see [Network security](#network-security).

#### Healthcare professionals — local employee identifier

Healthcare professionals are identified using a local employee identifier, with local employee name
and local employee role as non-identifying attributes. All professionals have a local employee
number, while a national healthcare professional identifier and role are not yet available for all
professionals.

### Authentication

Authentication establishes a verifiable identity for the parties in a data exchange, at three
levels: healthcare organisations (by URA), healthcare professionals (federated from data user to
data holder), and vendor organisations (at the transport layer). Organisation- and
professional-level authentication is performed via the standard did:web-based Nuts processes.

#### Organisation authentication — URA via X509Credential

The requesting and responding organisations are identified by URA and authenticated using an
X509Credential derived from a UZI server certificate, in line with Nuts RFC023.

- Data holders and data users **MUST** authenticate the URA using an
  [X509Credential derived from a UZI server certificate](https://build.fhir.org/ig/nuts-foundation/nl-generic-functions-ig/credential-X509Credential.html),
  in line with Nuts RFC023.

The URA is the agreed attribute to authenticate on, but there is no authoritative issuer for
URA-as-a-credential today. Deriving the URA from the UZI server certificate via an X509Credential
makes it cryptographically verifiable without a separate issuer.

> **Caveat: this is a workaround, not the desired end state.** Each vendor requests and manages a
> separate certificate, which is costly and laborious and is not expected to scale past about 20
> organisations. This is the main reason for the [versioning rule](index.html#status-and-scope).

#### Healthcare role type

Each organisation presents a self-issued HealthcareProviderRoleTypeCredential expressing its
organisation type(s), copied from the Zorginzage building blocks. No trusted third-party issuer is
active at the moment, so the credential is self-issued; this keeps the pilot ready to switch to a
proper issuer once one becomes available.

#### Person authentication — EmployeeID

The healthcare professional's identity is federated from the data user to the data holder by
including a NutsEmployeeCredential in the access-token request. The professional is identified by a
local employee identifier (the "EmployeeID"), with local name and role as non-identifying
attributes.

- Data users **MUST** federate healthcare professional identity using a `NutsEmployeeCredential`
  (see the request body in [Transactions](transactions.html#pull)).

The professional's identifying information is needed at the data holder for NEN 7513 audit logging,
which the NutsEmployeeCredential carries, and it can be used now independent of national
initiatives (e.g. Dezi) that are not yet in place.

> **Caveat: the user experience is limited.** The EmployeeID interaction (and its pop-up) is
> accepted for this pilot, but improving or removing it is a likely change before a larger-scale
> pilot.

#### Vendor authentication

Vendor organisations are authenticated at the transport layer through mTLS; see
[Network security](#network-security).

### Addressing

Addressing discovers the FHIR base URL and the authorisation server URL of a data holder; the other
functions depend on it.

The preferred route is the generieke functie (GF) adressering, which is expected to be pilot-ready
soon. While it is not yet available, the pilot would use a Nuts Discovery Service with an
`X509Credential` in the presentation definition — a pragmatic and currently available option,
specified below.

#### Fallback: Nuts Discovery Service

Preconditions:

- The data holder organisation has a UZI server certificate and the URA contained in it.
- The data holder operates a Nuts node that has registered with a Nuts Discovery Service for this
  use case, presenting:
  - an `X509Credential` carrying the URA (presented as `organization_ura`, per Nuts RFC023);
  - a self-issued `HealthcareProviderRoleTypeCredential` stating its organisation type(s);
  - a `DiscoveryRegistrationCredential` carrying the `fhir_base_url` and `authorization_server_url`
    of the data holder.
- The data user operates a Nuts node configured to consume the same discovery service and use case.

Conformance:

- The presentation definition for the discovery service **MUST** require the following fields:
  - `authorization_server_url`
  - `fhir_base_url`
  - `organization_facility_type`
  - `organization_ura`
- Data holders **MUST** publish the above fields during registration.
- Data holders **MUST** present a valid X509Credential derived from a UZI server certificate and a
  self-issued HealthcareProviderRoleTypeCredential at registration.
- Data users **SHOULD** resolve endpoints through the discovery service rather than hard-coding
  them.

Registration is described in [Transactions](transactions.html#registration-at-the-discovery-service).

### Localisation

Localisation is the process of finding out which organisations hold data about a patient.

The baseline is gericht bevragen: the data user determines, using the addressing function and its
own lists, which data holder(s) to query, and queries those. Maintaining that list (patient-supplied,
referral-based, sourced from an EHR, or otherwise) is out of scope for this specification.

When the NVI (Nationale Verwijsindex) becomes available, geïndexeerd bevragen is in scope as well:
localisation records are published to the NVI and retrieved from it. This is an addition on top of
the baseline.

### Authorisation

This specification follows the Zorginzage authorisation model: a fine-grained, policy-based access
model rather than a role-based model. Whether a requestor gets access depends on whether the
request passes the access policies of the data holder.

- Policies are expressed in a domain-specific language called Rego, so everyone uses the same
  rulesets evaluated against a commonly agreed information model. Implementers are free not to
  implement a Rego interpreter, as long as their solution follows exactly the same rules as the
  Rego policy for this use case.
- The applicable policies for this use case are version-controlled in a Git repository for the PZP
  pilot.
- The data holder operates a policy enforcement point (PEP) and has access to a policy decision
  point (PDP), e.g. the PDP functionality in the Nuts Knooppunt.

Conformance:

- The data holder organisation **MUST** enforce the rules described in the commonly defined Rego
  policy for this use case.
- The data holder organisation **MAY** implement a Rego interpreter.

The policy **MUST** take the following into account:

- Presence of the URA identifier of the requesting organisation **MUST** be checked.
- When the request is for a FHIR endpoint, conformance to a CapabilityStatement **MUST** be
  evaluated.
- Patient context is mandatory: for search interactions a patient id or BSN **MUST** be derivable
  from the query; for read interactions the requested resource **MUST** have a direct link to a
  patient.
- Explicit patient consent **MUST** be checked before returning data (see [Consent](#consent)).

### Consent

Consent verification is part of the authorisation decision for PZP. The data holder checks that a
valid explicit consent for the requested exchange is present before releasing data. The check is
performed by the data holder (the source system), wherever the patient's consent is stored —
locally, at an OTV such as Mitz, or in another consent registry; the storage location does not
matter for this specification.

Conformance:

- The data holder **MUST** check the presence of a valid explicit patient consent for the requested
  exchange before returning data.
- The data holder **MAY** check consent in a local system, at an online toestemmingsvoorziening
  (OTV, e.g. Mitz), or in another consent registry.

Attributes available for the consent check include: URA of the data user, organisation type of the
data user, URA and organisation type of the data holder, BSN of the patient, and a use-case
identifier.

### Network security

In production and acceptance environments, vendor organisations **MUST** use server- and
client-authentication (mutual TLS) based on PKIoverheid certificates. In test environments,
PKIoverheid certificates or public-trust certificates **MUST** be used.

The national specifications for network security ("Veilig Netwerk") are not yet finalised; the
current concept version prescribes PKIoverheid certificates, which are already widely in use by
vendors.
