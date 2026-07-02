### Version: 0.1.2 (current)

- [Implementation Guide](https://nuts-foundation.github.io/nl-pzp-ig/)
- [Source code](https://github.com/nuts-foundation/nl-pzp-ig)
- [Compare to v0.1.1](https://github.com/nuts-foundation/nl-pzp-ig/compare/v0.1.1...v0.1.2)

Significant changes:

- Added an **Implementation** note to Person authentication — EmployeeID: the data user passes the
  employee fields directly in the `request-service-access-token` call and the Nuts node places them
  in the access-token claims (no HTML page rendered by the Nuts node), with links to the Nuts node
  auth v2 API documentation and the Requesting Access wiki page.

### Version: 0.1.1

- [Implementation Guide](https://nuts-foundation.github.io/nl-pzp-ig/)
- [Source code](https://github.com/nuts-foundation/nl-pzp-ig)
- [Compare to v0.1.0](https://github.com/nuts-foundation/nl-pzp-ig/compare/v0.1.0...v0.1.1)

Significant changes:

- Professional authentication clarified: the `NutsEmployeeCredential` is self-attested (Nuts v6 /
  Zorginzage); the data user supplies and is expected to have verified the fields so the data holder
  can meet its NEN 7513 audit-logging obligations. Added an explicit note that there is no HTML
  challenge/pop-up, unlike the previous Nuts v5 employee identity means (RFC019).
- Stated that medical workflows and care protocols are out of scope — the guide covers the technical
  means only (Home scope and Functionele flows).
- Gave the versioning rule its own heading so it can be linked directly.

### Version: 0.1.0

- [Implementation Guide](https://nuts-foundation.github.io/nl-pzp-ig/)
- [Source code](https://github.com/nuts-foundation/nl-pzp-ig)

Initial proposition for the Proactieve Zorgplanning (PZP) pilot (< 20 organisations). Reuses the
Zorginzage 2026 building blocks (copied in, not referenced); drops the Zorginzage governance,
roadmap and release-policy chapters.

<!-- Template for future entries:
### Version: 0.2.0
- [Compare to v0.1.2](https://github.com/nuts-foundation/nl-pzp-ig/compare/v0.1.2...main)
- Significant changes:
-->
