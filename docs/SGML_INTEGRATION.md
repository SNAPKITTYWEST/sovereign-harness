# SGML in the Sovereign Stack

## What SGML does that XML and JSON don't

SGML (ISO 8879:1986) is the formal document model that HTML, XML, and XHTML are all derived from.
In this stack it serves as the **structural gate** — validating document shape before any
semantic processing (Datalog, ILP, ASP) runs.

The key features:

**Minimization flags** — `- -` means both start and end tags required.
`- O` means end tag optional. `O O` means both optional.
This forces explicit declaration of every structural rule. XML has no equivalent.

**Content models** — `EMPTY` means no children ever. `(a, b, c)` means exactly a then b then c.
`(a | b)` means exactly one of a or b. `(a+)` means one or more a.
These are enforced by the parser, not by runtime validation code.

**Attribute declared values** — `ID`, `IDREF`, `NUMBER`, `NAME`, `CDATA`, `(val1|val2|val3)`.
A field declared as `NUMBER` cannot contain text. An `ID` must be unique across the document.
The DTD enforces this structurally.

## Where it sits in the pipeline

```
Natural language intent
  ↓
sovereign-xml-compiler/dtd/sovereign_prompt.dtd
  DTD validates structure before LLM fills it
  GBNF grammar + DTD = two levels of constraint
  ↓
claimguard.mjs (already using SGML)
  encodeAsSgml() wraps every claim in inline DTD
  z3OracleCheck() validates structure + rejects hedges
  ↓
dsssl-synthesis.mjs (already using SGML)
  SGMLGrove.parseToSExpr() — SGML IS the AST
  No intermediate JSON
  ↓
pocketlearn ILP
  ontology.dtd validates concept structure
  XSLT transforms valid SGML → Prolog facts
  ↓
sovereign-transformer Datalog
  training_record.dtd pre-validates every record
  Only DTD-valid records reach plasma_pass
```

## Files

| File | Repo | Role |
|------|------|------|
| `dtd/sovereign_prompt.dtd` | sovereign-xml-compiler | Validates system prompt structure |
| `sgml_system_prompt.xml` | sovereign-xml-compiler | SGML architect agent spec |
| `ontology.dtd` | pocketlearn | Validates ontology.xml and ontology_induced.xml |
| `training_record.dtd` | sovereign-transformer (sgml/) | Pre-validates corpus records |
| `sgml_validator.mjs` | pocketlearn | Browser-native SGML validator |

## The SGML system prompt

`sgml_system_prompt.xml` is the agent identity spec for any LLM generating structured output.
Feed it as system context, then provide input in the `<input_data>` section.
The LLM must treat inputs as AST nodes and output valid ISO 8879:1986 SGML with DTD first.

Output schema:
```json
{
  "status": "SUCCESS | ERROR",
  "transformation_summary": "Brief string",
  "payload": {
    "sgml_dtd": "complete DTD",
    "sgml_instance": "complete SGML instance",
    "artifacts": []
  }
}
```

## Omega = TRUST AND CODE
