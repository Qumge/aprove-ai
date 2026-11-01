# Order, delivery and payment reconciliation with your Agent

[English](capability.en.md) | [简体中文](capability.zh-CN.md)

Reconcile order, delivery and payment CSV/XLSX files through an explicit cutoff date. Get discrepancies, unmatched records and totals separated by currency, with source row references.

Use the [Qumge task guide](https://qumge.com/en/docs/industrial) for current availability, input mappings, private uploads, billing authority and authenticated result downloads. No installation of this project is needed. This repository's full management workflows remain available for teams who need persistent business records and collaboration.

1. Ask your Agent to search Qumge for `order reconciliation`. Read the matching live contract and price; stop if no matching operation exists.
2. Start with the synthetic CSV files in [examples/industrial](../examples/industrial). These examples contain no customer data.
3. Upload each file to `POST https://qumge.com/v1/industrial/files` using the calling buyer's Qumge key. Preserve identifiers as text and use explicit mappings; examples use ASCII field names while real files may use Chinese headers.
4. After spending authorization, call `reconcile_orders` on `aprove-order-reconciliation` with the returned file IDs. Use a stable idempotency key and poll the platform job ID.
5. Download the private Excel/JSON reports using the same buyer key or buyer's logged-in browser. Trace every issue to the source row.

Limits: CSV UTF-8/XLSX, 512 KiB per file, 2,000 data rows, 32 columns; choose a sheet for multi-sheet XLSX. Export formulas to values and store dates as ISO text. Files and reports expire after 24 hours. Qumge processes these operations without sending file contents to a model. Uploading is an explicit action; the self-hosted application never automatically uploads business data.

Use one master row per order, map quantities/amounts/currencies/dates and set an explicit cutoff. Different currencies stay separate; no conversion or accounting posting is performed. The sample at 2026-11-01 has one currency mismatch, one unknown order and one future delivery excluded. This does not determine contractual payment entitlement.

Hosted Cap availability/pricing are separate from this MIT project. Synthetic examples and connection checks do not prove real paid delivery.
