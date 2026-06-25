### Inleiding

Deze implementatiegids bevat de afspraken en specificaties voor de use case **Proactieve
Zorgplanning (PZP)**. Het doel is het technisch definiëren van deze use case voor een pilot op
kleine schaal (minder dan 20 organisaties).

Met deze use case kan een zorgverlener met een behandelrelatie de voor hem of haar relevante
PZP-gegevens die bij een andere zorgaanbieder zijn vastgelegd, gericht raadplegen en tonen. Voor de
inhoudelijke definitie en de dataset van proactieve zorgplanning wordt verwezen naar het werk van
IKNL (zie [Dataset](dataset.html)).

### Relatie tot de Zorginzage-specificatie

Deze implementatiegids hergebruikt bouwstenen uit de [Zorginzage 2026-specificatie](https://nuts-foundation.github.io/nl-zorginzage-ig/)
en neemt de relevante inhoud integraal over, zodat deze gids zelfstandig leesbaar is en niet
meewijzigt wanneer de Zorginzage-specificatie wordt aangepast. Alleen de technische bouwstenen
worden overgenomen; de governance, het releasebeleid en de planning van Zorginzage vallen buiten
scope. Zie [Home](index.html) voor de uitgangspunten.

### Rollen

In deze use case worden twee rollen onderscheiden:

- **Datahouder (data holder)** — vastleggen / beschikbaarstellen. De organisatie die PZP-gegevens
  vastlegt en deze, na authenticatie en autorisatie, beschikbaar stelt aan een datagebruiker.
- **Datagebruiker (data user)** — raadplegen / tonen. De organisatie die PZP-gegevens bij een
  datahouder opvraagt en aan de zorgverlener toont. Dit kan het bronsysteem zelf zijn, of een
  aparte viewer-applicatie (bijvoorbeeld HINQ).

In deze pilot geldt geen verplichte wederkerigheid: een deelnemer hoeft niet beide rollen te
implementeren. Welke partij welke rol(len) vervult in deze pilotpropositie staat hieronder.

### Deelnemende partijen en hun rollen (pilot)

| Partij | Vastleggen / beschikbaarstellen (datahouder) | Raadplegen / tonen (datagebruiker) |
|--------|:--:|:--:|
| HINQ / Formelio           |   | ✓ |
| Topicus                   | ✓ | ✓ |
| Nedap                     | ✓ | ✓ |
| Pharmapartners / Formelio | ✓ |   |

### Rollen en uitvoerders

| Rol | Uitvoerder |
|-----|------------|
| Eigenaar van deze specificatie | Topicus, HINQ, Nedap |
| Deelnemer                      | XIS-leverancier of platform-leverancier |
| Eigenaar Discovery Service     | n.t.b. (zie [Exchange Architecture](exchange.html#addressing)) |

### Functionele flows

> Open punt (nog te specificeren). De precieze functionele flows worden nog uitgewerkt. Hier wordt
> beschreven wat binnen de scope van deze pilot met de genoemde leveranciers werkt, en wat nog niet.

Op hoofdlijnen verloopt de gerichte raadpleging als volgt (de technische uitwerking staat in
[Exchange Architecture](exchange.html) en [Transactions](transactions.html)):

1. Een zorgverlener opent de datagebruiker-applicatie — dit kan het bronsysteem zelf zijn of een
   aparte viewer-applicatie — en start een raadpleging voor een specifieke patiënt.
2. De datagebruiker bepaalt — op basis van de adresseringsfunctie en de eigen lijst van mogelijke
   datahouders — welke datahouder(s) bevraagd worden.
3. De datagebruiker authenticeert zich (organisatie en persoon) en doet een patiëntzoekvraag op
   BSN bij de datahouder.
4. De datahouder autoriseert de vraag, controleert de vereiste toestemming en levert de
   PZP-gegevens.
5. De datagebruiker toont de gegevens aan de zorgverlener.

Nog uit te werken voor de pilot:

- welke leverancier in welke rol (vastleggen/beschikbaarstellen dan wel raadplegen/tonen) aan welke
  stap deelneemt;
- welke PZP-gegevens per bronsysteem beschikbaar zijn (zie de open punten in [Dataset](dataset.html));
- hoe de lokale lijst van mogelijke datahouders bij de datagebruiker tot stand komt.
