# Smart E-Commerce Recommendation System

A local, portrait-and-mobile-friendly website for Team 3's existing eight-table Oracle DBMS project. It uses a Node.js server and the Oracle Thin driver. No new database tables are required, no sample data is re-imported and no SQL project files are changed.

## Start in VS Code

Open this folder in VS Code. In its terminal:

```sh
npm install
npm start
```

Requires Node.js 22 or newer. Keep Oracle Docker running and wait until the database is ready. Open **http://localhost:3000**. Click **Connect Oracle** and enter the password for your `smart_ecommerce` schema. The server keeps it only in memory; it is never saved in the browser or sent to third parties.

Default connection: `smart_ecommerce` at `localhost:1521/FREEPDB1`.

For a persistent connection, copy `.env.example` to `.env` in VS Code and fill in `DB_PASSWORD`. Keep `.env` private; it is excluded from Git. Change other settings there if necessary. Restart the server after editing it. The app serves only localhost; do not expose it publicly.

## Website features

- Product catalogue, search, categories, prices, stock and ratings from Oracle.
- A customer selector for the academic presentation — **not secure login**. Only customers appear; passwords and email addresses are never returned by catalogue APIs.
- SQL recommendations: separately aggregated average rating × 2 + interaction count; excludes products that the customer previously interacted with. Category history supplies an explanatory label, not an extra score. This is rule-based, not trained AI.
- Opening a product records VIEW. Adding to the bag records CART. The heart records WISHLIST interest (not a persistent, removable wishlist collection).
- Browser-local bags are isolated by customer. The existing Cart table has no product-line storage, so no database cart-product table is invented.
- Checkout requires confirmation, calculates prices from Oracle, locks and verifies stock, inserts Orders and Order_Item, reduces stock, records PURCHASE interactions and updates an existing Cart's timestamp in one transaction. Failure rolls back all changes. There is no payment or delivery integration.
- Reviews save/update the selected customer's unique review for a product. My orders shows their history, items and recorded total.
- Project page explains normalization through 3NF and database consistency.

## Important demo limitations

All write actions are real when Oracle is connected. They change sample data and may change SQL result screenshots. Normal browsing records VIEW history too. Use a copy of the database if you need to preserve original demonstration results. The application does not modify existing order totals. The provided sample passwords are placeholders, so this app intentionally does not pretend to provide authentication.

The schema uses manually assigned integer IDs. Short exclusive table locks make MAX(ID)+1 allocation safe across sessions during this small local demo. Transactions and lock timeouts prevent partial orders; this is not intended as a high-throughput production ID strategy. Live writes require the schema owner to have the usual table access/lock permissions. Existing triggers remain active.

## Read-only preview

```sh
npm run demo
```

This explicitly labelled sample preview uses catalogue values from your SQL and does **not** connect to Oracle or permit database writes. Order/review history is available only in live mode. Stop with Ctrl+C before switching modes. Cart contents are local only and are separate between live and preview modes.

## Verification

```sh
npm test
```

These tests check input validation, not your live database. To verify live mode after connecting: compare products to `SELECT * FROM Product`, check a customer's My orders, then (only if you want real changes) place a small test order and verify its header, items, stock and interactions in VS Code. Without your private password the initial build cannot verify a live Oracle connection.

Oracle driver documentation: https://node-oracledb.readthedocs.io/en/latest/user_guide/connection_handling.html
