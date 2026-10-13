# Retail Inventory and Order Management — Neo4j Migration

**PRT563 Advanced Data Management · Assessment 4 · Sydney Group 11**

This repository has the scripts and data used to migrate our Assessment 2 relational database (SQLite) to a Neo4j graph database. It covers graph modelling, Cypher import, queries, and Graph Data Science (GDS) analytics.

| Member | Student ID |
|---|---|
| Bhuwan Sharma | S396374 |
| Oshan Thapa Chhetri | S395087 |
| Shushil Paudel | S393576 |
| Sabin Subedi | S394876 |

---

## Repository contents

| File | Purpose | Report section |
|---|---|---|
| `import.txt` | Cypher scripts: constraints, indexes, node and relationship import from CSV, derived relationships, verification | Task 2 / Section 3 |
| `queries.txt` | Four Cypher query use cases (basic → complex) | Task 3 / Section 4 |
| `analytics.txt` | GDS centrality (Degree, PageRank, Betweenness, Closeness) and similarity (Node Similarity: Jaccard, Overlap, Cosine) | Tasks 4–5 / Sections 5–6 |
| `csv/` | 12 CSV files, one per relational table | Task 2 |
| `database_revised.sql` | Assessment 2 SQL script with the five missing `CUSTOMER` rows added | Section 2.1 |

### CSV files

| File | Source table | Rows |
|---|---|---|
| `customers.csv` | CUSTOMER | 5 |
| `products.csv` | PRODUCT | 8 |
| `suppliers.csv` | SUPPLIER | 4 |
| `locations.csv` | LOCATION | 4 |
| `sales_orders.csv` | SALES_ORDER | 6 |
| `sales_order_items.csv` | SALES_ORDER_ITEM | 10 |
| `purchase_orders.csv` | PURCHASE_ORDER | 5 |
| `purchase_order_items.csv` | PURCHASE_ORDER_ITEM | 12 |
| `stock.csv` | STOCK | 24 |
| `invoices.csv` | INVOICE | 6 |
| `payments.csv` | PAYMENT | 4 |
| `deliveries.csv` | DELIVERY | 6 |

---

## Requirements

- **Neo4j 5.x**: Neo4j Desktop (recommended), Neo4j Server, or Neo4j AuraDS
- **Graph Data Science library 2.x** plugin (needed only for `analytics.txt`)
- No APOC plugin is required

---

## How to run

### 1. Create the database
1. Open Neo4j Desktop and create a new **Local DBMS** (Neo4j 5.x).
2. Before starting it, open **Plugins** and install **Graph Data Science Library**.
3. Start the DBMS.

### 2. Copy the CSV files
1. In Neo4j Desktop, click **⋯ → Open folder → Import** for your DBMS.
2. Copy **all 12 files** from `csv/` into that `import` folder. Put the files themselves there, not the `csv` folder.

> **Neo4j Aura:** `file:///` paths don't work. Upload the CSVs somewhere public (for example raw GitHub links) and replace `file:///name.csv` in `import.txt` with the full URL.

### 3. Import the data
1. Open **Neo4j Browser**.
2. Enable multi-statement queries: **Settings (⚙) → Enable multi statement query editor**.
3. Paste the contents of `import.txt` and run it. You can also run it one step at a time (Steps 0–6).

### 4. Verify the import
Step 6 of `import.txt` should return:

| Node label | Count | Relationship type | Count |
|---|---|---|---|
| Customer | 5 | STOCKED_AT | 24 |
| Product | 8 | ORDERS | 12 |
| Category | 5 | CONTAINS | 10 |
| Supplier | 4 | BOUGHT | 10 |
| Location | 4 | SUPPLIES | 10 |
| SalesOrder | 6 | IN_CATEGORY | 8 |
| PurchaseOrder | 5 | PLACED | 6 |
| Invoice | 6 | INVOICED_AS | 6 |
| Payment | 4 | SHIPPED_BY | 6 |
| Delivery | 6 | PLACED_WITH | 5 |
| | | PAYS | 4 |
| **Total** | **53** | **Total** | **101** |

Run `CALL db.schema.visualization();` to see the graph model.

### 5. Run the queries
Paste each query from `queries.txt` separately and run it.

### 6. Run the analytics
Run `analytics.txt` step by step. It needs the `BOUGHT` and `SUPPLIES` relationships created in Step 5 of `import.txt`.

---

## Graph model summary

**Nodes:** `Customer`, `Supplier`, `Product`, `Category`, `Location` (extra label `:Store` or `:Warehouse`), `SalesOrder`, `PurchaseOrder`, `Invoice`, `Payment`, `Delivery`

**Relationships:**

```
(:Customer)-[:PLACED]->(:SalesOrder)
(:SalesOrder)-[:CONTAINS {quantity, unitPrice, lineTotal}]->(:Product)
(:PurchaseOrder)-[:PLACED_WITH]->(:Supplier)
(:PurchaseOrder)-[:ORDERS {quantity, unitCost, lineTotal}]->(:Product)
(:Product)-[:STOCKED_AT {quantityOnHand, lastUpdated}]->(:Location)
(:Product)-[:IN_CATEGORY]->(:Category)
(:SalesOrder)-[:INVOICED_AS]->(:Invoice)
(:Payment)-[:PAYS]->(:Invoice)
(:SalesOrder)-[:SHIPPED_BY]->(:Delivery)

// Derived from the order paths (rebuilt by import.txt Step 5)
(:Customer)-[:BOUGHT {totalQuantity, orderCount}]->(:Product)
(:Supplier)-[:SUPPLIES {totalQuantity, orderCount, avgUnitCost}]->(:Product)
```

---

## Changes from Assessment 2

1. Added five `CUSTOMER` rows. The original script inserted none, although sales orders reference customers 1–5.
2. `PRODUCT.Category` is now a `:Category` node.
3. The `LOCATION` subtype is modelled as `:Store` / `:Warehouse` labels.
4. The associative tables (`SALES_ORDER_ITEM`, `PURCHASE_ORDER_ITEM`, `STOCK`) are now relationships with properties.
5. Added derived `BOUGHT` and `SUPPLIES` relationships for analytics.
6. Dates are stored as native `date` values. Phone numbers and postcodes stay as strings.

The report (Section 2.1) explains the reason for each change.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| `Couldn't load the external resource at: file:///...` | The CSV isn't in the DBMS `import` folder, or the file name doesn't match. |
| Only the first statement runs | Turn on the multi-statement query editor (step 3.2). |
| `There is no procedure with the name gds...` | The GDS plugin isn't installed. Install it and restart the DBMS. |
| `Graph with name ... already exists` | Run `CALL gds.graph.drop('supplyDemand', false);` (or `'productProfile'`) and run the projection again. |
| Counts are higher than expected | Data was loaded twice. Run Step 0 (`MATCH (n) DETACH DELETE n;`) and import again. |
| `CALL (row) { ... }` syntax error | That example is in a comment and only for Neo4j 5.23+. On older 5.x versions use `CALL { WITH row ... }`. |