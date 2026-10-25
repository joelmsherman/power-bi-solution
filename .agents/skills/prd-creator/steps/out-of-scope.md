# Out of scope

Based on the locked page inventory, propose up front a list of likely out-of-scope items: things that *could* be in a Power BI solution like this, but that the user almost certainly doesn't want in v1. Examples common to Power BI reports:

- Write-back or data entry (Translytical task flows, Power Apps visuals). The report is read-only against the semantic model
- What-if parameters and scenario modelling
- Pages beyond the locked inventory
- A dedicated mobile layout for each page
- Real-time or DirectQuery sources, and refresh more often than the agreed schedule
- Paginated (pixel-perfect, print-ready) reports
- Data alerts, subscriptions and Power Automate flows, beyond what the Service gives each reader
- Embedding in another application, or publishing to the web
- Personal bookmarks or per-user views beyond what the Service gives each reader
- Translations and multi-language field names
- Custom visuals beyond the core set

Present the list, explain why each is a reasonable cut for v1, and ask the user to confirm or pull anything back into scope. Also ask if there's anything else they want explicitly out.
