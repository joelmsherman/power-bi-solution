# Documentation (permanent)

This is the half of the repo's writing that outlives the build. `_project_/` holds the engagement record and is deleted once the report ships. Anything a future maintainer will still need lives here.

| File | What it is |
|---|---|
| `stack-playbook.md` | The stack: what each component is, who owns the account, which identifiers the work needs and where each comes from. Ships with the template |

Nothing else is prescribed. Files that tend to accumulate on a Power BI solution:

| Typical file | What it is for |
|---|---|
| `fabric-admin-brief.md` | The tenant settings, capacity, licences and workspace permissions the solution needs, and who to ask |
| `refresh-and-monitoring.md` | How the model refreshes, on what schedule, and what to do when it fails |
| `data-lineage.md` | Which upstream systems feed the model, and who owns each |
| `security.md` | The row-level security roles, what each one filters, and who maintains membership |

The `README.md` at the repo root is the front door. It says what the solution is, how to open it and how it is deployed. Use `docs/` for anything too long or too operational to sit there.

Writing rules for client-facing artifacts are **not** here. They are in `training/`, and kept byte-identical with the copies in `project-intake` and the sibling templates.
