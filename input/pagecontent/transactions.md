This volume describes the individual transactions used in the pull flow.

### Registration at the discovery service

When the [Nuts Discovery Service fallback](exchange.html#fallback-nuts-discovery-service) is used,
every data holder registers itself at the discovery service. This registration takes place in the
implementation phase.

<div width="90%" style="width: 90vw;">{% include sequence-diagram-disco.svg %}</div>
<br clear="all"/>

The body of the registration request to the internal API of the Nuts node **MUST** contain the
following registration parameters:

```
{
  "registrationParameters": {
    "authorization_server_url": "https://example.com/some-endpoint",
    "fhir_base_url": "https://example.com/some-endpoint"
  }
}
```

The following credentials **MUST** be available in the Nuts node organisation wallet:

1. `X509Credential` based on a UZI server certificate (carrying the URA);
2. `HealthcareProviderRoleTypeCredential` (self-issued).

### Pull

The sequence for the pull scenario is shown below.

<div width="90%" style="width: 90vw;">{% include sequence-diagram-pull.svg %}</div>
<br clear="all"/>

Key steps:

- The healthcare professional authenticates in the data user application, which may be the source
  system itself or a separate viewer application (such as HINQ). The application creates a user
  session and stores the user info needed for the `NutsEmployeeCredential`.
- The data user determines the targeted data holder(s) (see
  [Localisation](exchange.html#localisation)) and resolves their endpoints (see
  [Addressing](exchange.html#addressing)).
- The data user requests an access token, federating the professional identity by including a
  `NutsEmployeeCredential` (see below).
- The data user performs a Patient search on BSN (see [Patient context](#patient-context)),
  followed by the data request using the patient's technical identifier.
- The data holder authorises the request, checks explicit consent
  ([Consent](exchange.html#consent)), and returns the data.

The access-token request body **MUST** contain a `NutsEmployeeCredential` credentialSubject:

```
POST <internal Nuts interface>/internal/auth/v2/<subjectID>/request-service-access-token
Content-Type: application/json

{
  "authorization_server": "<authorization_server_url>",
  "scope": "<use-case-identifier>",
  "credentials": [
    {
      "@context": [
        "https://www.w3.org/2018/credentials/v1",
        "https://nuts.nl/credentials/v1"
      ],
      "type": ["VerifiableCredential", "NutsEmployeeCredential"],
      "credentialSubject": {
        "name": "John Doe",
        "roleName": "Nurse",
        "identifier": "123456"
      }
    }
  ]
}
```

### Patient context

All queries are patient-specific. The data user needs the logical id of the patient at the data
holder and includes it in every query (e.g. `patient=123` or `subject=Patient/123`). The logical id
is obtained through an initial search on the Patient endpoint using the BSN as identifier:

- the search **MUST** follow [IHE PDQm ITI-78](https://profiles.ihe.net/ITI/PDQm/ITI-78.html), with
  these additional agreements:
  - search **MUST** be performed on BSN (`identifier.system` = `http://fhir.nl/fhir/NamingSystem/bsn`);
  - only POST-based search is allowed; GET-based search is not allowed.
- data user organisations **MUST** support POST-based Patient search;
- data holder organisations **MUST** support POST-based Patient search.

```
POST {fhir_base}/Patient/_search

Header: Content-Type = x-www-form-urlencoded

Body: identifier=http://fhir.nl/fhir/NamingSystem/bsn|{bsn}
```

### Individual resource requests

- Read requests are only allowed on individual resource types, excluding `List`, `Composition` and
  `Bundle` resources.
- Search requests are only allowed on individual resource types, excluding `List`, `Composition`
  and `Bundle` resources.
