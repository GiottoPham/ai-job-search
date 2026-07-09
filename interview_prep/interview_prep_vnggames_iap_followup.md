# Interview Prep Follow-up — VNGGames IAP/Webhook Deep Dive

Source: mock interview scored 55/100 (Project Deep Dive, subscription/IAP architecture). Root cause: conflating "unique ID for deduplication" with "cryptographic authentication," and not knowing the specific Apple/Google server-to-server mechanisms that replace polling. This doc closes those four gaps with accurate concepts, then gives honest rewritten answers — acknowledging what was actually built at HouseNow · CarNow vs. what a hardened version would add. Do not claim the hardened version was already implemented; the credible move is "here's what we shipped, here's what I'd add given more scope."

## Concept Primers (study these first)

### 1. Webhook/receipt authenticity — signature verification, not unique IDs
A unique ID stops you from double-processing the *same* legitimate event twice. It does nothing to prove the event *came from Apple/Google in the first place* — an attacker who guesses or leaks an ID can replay or forge a request.
- **Apple App Store Server Notifications V2**: payload arrives as a signed JWS (JSON Web Signature). You verify it using Apple's public key certificate chain (`x5c` header), confirming the payload was signed by Apple and hasn't been tampered with — this is the actual authenticity check, not the transaction ID.
- **Google Play Real-time Developer Notifications (RTDN)**: delivered via Google Cloud Pub/Sub. Authenticity comes from Pub/Sub's own push endpoint verification (JWT bearer token signed by Google, validated against Google's public certs) — you're trusting Google Cloud's auth layer, not a shared secret you invented.
- **Generic pattern (if you ever roll your own webhook receiver)**: HMAC-SHA256 signature over the raw request body using a shared secret, sent in a header (e.g., `X-Signature`), compared with constant-time comparison. Add a timestamp in the signed payload and reject anything older than a few minutes to block replay attacks.

### 2. Real-time alternatives to polling
Polling every 10 seconds (as described in the transcript) works but wastes requests and adds latency. The store-to-backend leg has a real fix; the backend-to-client leg is more nuanced.
- **Store → backend (guaranteed):** Apple App Store Server Notifications V2 and Google Play RTDN push transaction events to your backend endpoint directly. No polling needed here — the store guarantees delivery to your server.
- **Backend → client (best-effort, not guaranteed):** two options, don't conflate them —
  - **Silent/background push** (iOS `content-available: 1`, Android data-only FCM message — same Expo Notifications API you already use, but a different payload shape than the *visible* alert-and-deep-link notifications you built for user-facing messages). Wakes the app to re-sync in the background. Caveat: iOS explicitly does **not** guarantee delivery or timing for these — can be throttled or dropped (low battery, Background App Refresh off, etc.).
  - **Persistent connection** (WebSocket/SSE) — actually guaranteed while connected, but adds infra you may not need for an entitlement update.
- **The correct framing:** silent push is a *latency optimization*, not a replacement for reconciliation. Claiming "push means we don't need polling anymore" is the kind of overclaim that gets picked apart — the accurate answer is "push gets us near-instant updates most of the time; the cron/reconciliation stays as the correctness guarantee underneath it, since push delivery isn't guaranteed."
- Don't confuse this with the *visible* push notification you actually built (Expo Notifications + iOS notification service extension) — that's a user-facing alert with tap-to-navigate deep linking, a different feature from a silent background sync trigger, even though it's the same underlying APNs/FCM tech.

### 3. Idempotency — how to safely handle the same event arriving twice
Both a webhook and a cron job can independently try to apply the same purchase. The fix isn't "cronjob and polling aren't related" (the vague answer given) — it's making the *write* idempotent regardless of how many times or which path triggers it:
- Use the store's transaction ID / purchase token as a unique constraint in your database (`UNIQUE` index), so a second write with the same ID is a no-op or safely ignored (upsert, `ON CONFLICT DO NOTHING`/`DO UPDATE`).
- Track processed-event IDs in a dedup table with a TTL, check-before-apply.
- Design the update as idempotent by nature: "set entitlement to active as of transaction X" is safe to run twice; "increment entitlement count" is not.

### 4. Race conditions
Two processes (webhook handler + cron job) touching the same user's entitlement row concurrently.
- Database-level: wrap the read-check-write in a transaction with row-level locking (`SELECT ... FOR UPDATE`) or rely on the unique constraint above to let the database itself reject the duplicate.
- Alternative: a distributed lock (Redis `SETNX` with expiry) keyed on transaction ID while processing.
- The interview-ready framing: "the database's unique constraint on transaction ID is the actual race-condition guard — it doesn't matter which path (webhook or cron) gets there first, the second write is rejected or becomes a no-op."

## Rewritten Answers (honest framing: what shipped vs. what you'd harden)

**Q2 (backend validation of purchase legitimacy)**
"On the backend, once the client's purchase event fires, we poll our own backend to confirm the entitlement is marked active, and reconcile via a cron job against Apple/Google if it isn't. The piece I'd add if I were hardening this further is validating the receipt directly against Apple's `verifyReceipt`-equivalent (App Store Server API) or Google Play Developer API at the point of purchase, rather than only trusting our own DB state — that closes the gap between 'our system says it's active' and 'Apple/Google actually confirms this transaction is real.'"

**Q3 (real-time alternative to polling)**
"What we actually built relies on polling plus a reconciliation cron job, which works but adds latency and unnecessary load. On the store-to-backend side, Apple App Store Server Notifications V2 and Google Play's RTDN push transaction events to our backend directly, so the backend doesn't need to poll the store at all — that part's a guaranteed delivery from Apple/Google. On the backend-to-client side it's more nuanced: we could use a silent background push — same Expo Notifications setup we already have, but a data-only payload instead of the visible alert-and-deep-link notifications we built for user-facing messages — to nudge the app to re-sync immediately. The caveat is iOS doesn't guarantee delivery or timing on silent pushes, so that's a latency optimization on top of reconciliation, not a replacement for it — I'd keep the cron job as the correctness guarantee and use push to make the common case feel instant."

**Q4 (duplicate processing / race conditions between cron and webhook)**
"Right now the cron job and the purchase-event handler can both attempt to update the same entitlement. The way I'd guard against that concretely is a unique constraint on the transaction ID in the database — so no matter which path (webhook or cron) processes it first, the second write is a no-op instead of a duplicate charge or double-entitlement. That's a more precise guard than just having a unique ID for lookup — the constraint has to be enforced at the write, not just used as a reference."

**Q5 (webhook authenticity / spoofing prevention)** — this was the weakest answer, rebuild it fully:
"Honestly, what we had was a unique ID per purchase, which prevents duplicate processing but doesn't prove the request came from Apple or Google in the first place — that's a real gap. The correct mechanism is verifying the notification's signature: Apple signs App Store Server Notifications as a JWS payload, verified against Apple's public certificate chain; Google's RTDN comes through Pub/Sub, authenticated via a Google-signed JWT on the push endpoint. Either way, you're validating a cryptographic signature from Apple/Google's servers, not trusting an opaque ID that could theoretically be replayed or guessed."

## Likely Follow-ups After Giving These Answers
| If they ask... | Say... |
|---|---|
| "Have you actually implemented JWS/signature verification?" | Be direct: "Not yet in production — our reconciliation relied on polling and a unique-ID check. I know the mechanism and how I'd wire it in; I haven't had the chance to build it myself." Do not claim you built it. |
| "Why didn't you build it this way originally?" | Honest, non-defensive: scope/time tradeoffs on a small frontend team, reconciliation via cron was "good enough" at current scale, and this is exactly the kind of hardening you'd prioritize with more backend ownership. |
| "What's the risk if you don't verify signatures?" | An attacker could POST a forged 'purchase succeeded' event with a guessed/leaked ID and get free entitlement, since nothing proves the event came from Apple/Google. |

## Study Checklist Before Retry
- [ ] Can explain JWS verification in one sentence without notes
- [ ] Can name both Apple's and Google's real-time notification systems unprompted
- [ ] Can explain idempotency using "unique constraint on transaction ID," not "unique ID for lookup"
- [ ] Can explain the race-condition guard as a database-level mechanism, not a scheduling argument
- [ ] Answers are front-loaded with the concrete mechanism name, not the narrative build-up
