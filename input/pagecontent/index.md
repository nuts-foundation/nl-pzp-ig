### Overview

This implementation guide describes the agreements and specifications for exchanging Proactieve
Zorgplanning (PZP) data between healthcare organisations. It lets a data user — a care provider
with a treatment relationship — retrieve the PZP information that other care organisations record
and make available, in a secure and auditable way.

### Status and scope

This guide is a proposition for a production-grade pilot on a relatively small scale: fewer than 20
participating organisations. It is a plan for what could be piloted now, as of June 2026. There is
no commitment to use it, to bring it live, or to follow the Zorginzage governance, release schedule
or planning. The architectural choices are made for what is practical and usable for this pilot,
which is why the guide is versioned 0.1.0 rather than 1.0. The guiding principle is to reuse the
building blocks that already exist.

> Versioning rule. This specification is dimensioned for a pilot of fewer than 20 organisations.
> When the scope grows beyond 20 organisations, a new version is created, because some of the
> choices below — in particular organisation authentication via X509 certificates — are not
> expected to scale past that threshold.

### Relationship to the Zorginzage specification

This guide reuses building blocks from the [Zorginzage 2026
template](https://nuts-foundation.github.io/nl-zorginzage-ig/). The relevant content is copied into
this guide so that the PZP specification is self-contained and does not change when the Zorginzage
specification evolves. Only the technical building blocks are taken over; the Zorginzage
governance, reciprocity, commitment, roadmap and release-policy chapters are out of scope.

### Release-time-based components

Some components name a preferred option together with a fallback that the pilot would use while the
preferred option is not yet available. This lets the pilot start with available technology while
staying ready to adopt the preferred generic functions as they mature. The pattern applies to
[addressing](exchange.html#addressing) and [localisation](exchange.html#localisation).

### Participating parties and roles (pilot)

The two roles are vastleggen / beschikbaarstellen (record and make available — the data holder) and
raadplegen / tonen (consult and display — the data user). See [Use Case & Roles](functional.html)
for the role definitions.

| Party | Vastleggen / beschikbaarstellen (data holder) | Raadplegen / tonen (data user) |
|-------|:--:|:--:|
| HINQ / Formelio           |   | ✓ |
| Topicus                   | ✓ | ✓ |
| Nedap                     | ✓ | ✓ |
| Pharmapartners / Formelio | ✓ |   |

### Organisation of this guide

- [Use Case & Roles](functional.html) — functional overview, the participating parties and their
  roles, and the functional flows (in Dutch).
- [Exchange Architecture](exchange.html) — the technical agreements: exchange patterns,
  identification, authentication, addressing, localisation, authorisation, consent and network
  security (in English).
- [Transactions](transactions.html) — the individual transactions: discovery registration and the
  pull flow (in English).
- [Dataset](dataset.html) — the PZP dataset (in English).

### Support

For support interpreting and implementing this specification, contact
[Stichting Nuts](mailto:info@nuts.nl).
