# nl-pzp-ig — Proactieve Zorgplanning (PZP) Implementation Guide

Self-contained FHIR Implementation Guide for exchanging **Proactieve Zorgplanning (PZP)** data
between healthcare organisations in a **small-scale pilot (< 20 organisations)**.

The guide selectively **reuses building blocks** from the
[Zorginzage 2026 template](https://nuts-foundation.github.io/nl-zorginzage-ig/), but the relevant
content is **copied in** so this specification does not change when Zorginzage changes. It does
**not** adopt the Zorginzage governance, release cycle or planning — every choice here is made on
account of this PZP pilot.

This is a **proposition**, not a commitment to build or go live. It is explicitly **not a 1.0**;
a new version must be created when the pilot scope grows beyond 20 organisations.

Rendered guide: <https://nuts-foundation.github.io/nl-pzp-ig/>

## Structure

| Page | Content |
|------|---------|
| Home | Purpose, scope, proposition disclaimer, participants, versioning rule |
| Use Case & Roles | PZP use case, role split, participating parties, functional flows |
| Exchange Architecture | Exchange patterns, identification, authentication, addressing, localisation, authorisation, consent, network security |
| Transactions | Discovery registration, pull retrieval, patient context |
| Dataset | IKNL dataset reuse, open questions |
| History | Changelog |

## Build & deploy

The guide is rendered in CI (`.github/workflows/build_deploy.yml`): on every push to `main` a
Docker image containing SUSHI and the HL7 IG Publisher is built, the IG is generated into
`./output`, and the result is deployed to GitHub Pages.

### Validate FSH locally

```bash
npx fsh-sushi sushi .
```

### Full local render (requires Docker)

```bash
docker build . -t ig-builder
docker run --rm --name=ig-builder \
  -v ./input:/app/input \
  -v ./output:/app/output \
  -v ./ig.ini:/app/ig.ini \
  -v ./sushi-config.yaml:/app/sushi-config.yaml \
  ig-builder
# open ./output/index.html
```
