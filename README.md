# NEX OSINT Pro

A responsive, black-and-white glassmorphism workspace for real, public-source OSINT queries. Built with HTML/CSS/vanilla JavaScript and a Python FastAPI backend. No login or paid API key is required for the base integrations; public endpoints still have availability and rate-limit restrictions.

## Live modules

- **Universal multi-source lookup:** Domain bundles query public RDAP, DNS, IP/network attribution, Certificate Transparency, and urlscan search. The output shows each source's success or error independently.
- **Username reconnaissance:** Integrates [Maigret](https://github.com/soxoj/maigret) as a Python library to check public profile URLs using its shipped site database. Quick/Standard/Extended request 100/500/1,000 top-ranked entries from that database. False positives, timeouts, blocks, and stale site rules are possible; matches are leads that require manual verification.
- **Telegram public page:** Requests `t.me/<username>` and, if available, `t.me/s/<username>` for public channel-preview posts. It only exposes fields actually returned by Telegram's public web preview. It does not retrieve private messages, phone numbers, hidden account fields, member lists, or login-only data.
- **IP/network intelligence:** Public IP network, ASN, ISP and approximate geolocation from [ipwho.is](https://ipwho.is/documentation). Private, loopback and reserved IPs are rejected. A reported location is not a person's exact GPS or home address.
- **DNS:** A, AAAA, MX, NS, CNAME, SOA, CAA and TXT via [Cloudflare DNS over HTTPS](https://developers.cloudflare.com/1.1.1.1/encryption/dns-over-https/).
- **Domain/IP RDAP:** Public registration and registry metadata via [rdap.org](https://rdap.org/); registrant fields may be redacted by the registry.
- **Certificate Transparency:** Historical certificates and observed hostnames via [crt.sh](https://crt.sh/). A hostname in a certificate log is not proof it is currently active.
- **GitHub:** Public profile and recently updated public repositories via the GitHub REST API.
- **urlscan.io:** Public scan archive search. Availability and unauthenticated rate limits can vary.
- **Email / MX:** MX, SPF, DMARC, TXT, NS and SOA clues from public DNS only. It does not verify mailbox existence or search private breach data.
- **Web research:** Creates real search-engine and public-index links. It does not pretend to scrape those search results.
- **History:** Local-first history, JSON export/import and per-record delete.
- **Optional encrypted device sync:** Pair a desktop and phone without creating an account. History is compressed and encrypted in the browser using AES-GCM. The server stores the encrypted payload and a one-way hash of the pairing proof, not the encryption key.

## Requirements

- Python 3.10+ (3.11/3.12 recommended).
- Internet access for live queries.
- A modern browser.

## Windows quick start

1. Extract this folder.
2. Double-click `start_windows.bat`, or run these commands in PowerShell from this folder:

   ```powershell
   py -m venv .venv
   .\.venv\Scripts\python.exe -m pip install --upgrade pip
   .\.venv\Scripts\python.exe -m pip install -r requirements.txt
   .\.venv\Scripts\python.exe -m uvicorn app:app --host 127.0.0.1 --port 8000
   ```

3. Open **http://127.0.0.1:8000**. Keep the terminal/server running. API docs are available at **http://127.0.0.1:8000/api/docs**.

## macOS / Linux / Android Termux

Run `./start_unix.sh` or execute:

```bash
python3 -m venv .venv
. .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
python -m uvicorn app:app --host 127.0.0.1 --port 8000
```

Open `http://127.0.0.1:8000` on that same device. Opening `index.html` directly via `file://` does not start the Python API. On Android, the server can run locally in Termux, subject to device memory/network limits.

## PC ↔ phone encrypted sync (no login)

1. Deploy this *whole* application to one HTTPS URL on a Python-capable host. The same web origin must serve the frontend and `/api/*` backend routes. For cross-device history, configure a **persistent writable disk/volume** for the SQLite sync database; set `NEX_SYNC_DB_PATH` to that volume path if needed.
2. Open the same HTTPS site on the first device, go to **Research history → Sync devices**, and press **Create new code**.
3. Use **Copy pairing code** and transfer the complete code to your other device through a private channel. On that device, open the same URL, paste the code, and choose **Connect / Sync**.
4. New history records and deletes are pushed automatically after a short delay. Use **Sync now** if you need to retry manually.

**Treat the pairing code like a password.** It contains both the encryption key and workspace authorization secret. Anyone who gets it can read that workspace. Do not post it publicly. The app encrypts locally with AES-GCM; only the ciphertext reaches the backend, but HTTPS and a trusted host are still essential. The application does not create a user account. If the host has ephemeral storage or loses its SQLite file, the remote encrypted copy can be lost. A local server listening on `127.0.0.1` is not accessible from another device; remote deployment is required for real PC/phone syncing.

Server launch command for most hosts:

```bash
python -m pip install -r requirements.txt
uvicorn app:app --host 0.0.0.0 --port ${PORT:-8000}
```

Use a host with persistent storage for sync. Do not run multiple independent deployments if you expect the devices to share the same sync workspace.

## Source code & design

- `index.html` — page structure.
- `assets/css/app.css` — high-contrast, multi-layer glass effects, strong specular edges, responsive desktop/mobile layouts, button sheen and motion.
- `assets/js/app.js` — live frontend, source rendering, history, JSON portability, animated navigation, command palette and AES-GCM device pairing.
- `app.py` — FastAPI endpoints, public-data lookups and encrypted-sync store.
- `requirements.txt` — Python dependencies.

The interface uses native CSS/JavaScript and needs no CDN or frontend build step. `prefers-reduced-motion` is respected.

## Rate limits and integrity

There is no honest way to promise unlimited requests against third-party public services. They can change APIs, block automation, return incomplete data or enforce quotas. NEX shows source errors instead of converting them into “not found.” A username match does not prove that accounts belong to one person; Telegram public previews can contain little metadata; IP geolocation is approximate; CT and urlscan data may be historical.

## Troubleshooting

- **Maigret not installed:** run `python -m pip install -r requirements.txt` inside the active virtual environment.
- **Backend unavailable:** open the app through `http://127.0.0.1:8000`, not by double-clicking the HTML file.
- **HTTP 429 / 403 / timeout:** the external source may be rate-limiting, blocking automation or unavailable. It is not a “not found” result.
- **Telegram result contains little information:** public profile pages often expose only a small preview. This is expected; private data is not bypassed.
- **Sync pairing failure:** both devices must use exactly the same HTTPS application origin and the complete pairing code; confirm server storage persists between restarts.

## Public source references

- Maigret: https://github.com/soxoj/maigret and https://maigret.readthedocs.io/en/latest/library-usage.html
- Telegram public pages: https://t.me/ and https://telegram.org/faq
- ipwho.is: https://ipwho.is/documentation
- Cloudflare DNS DoH: https://developers.cloudflare.com/1.1.1.1/encryption/dns-over-https/
- RDAP: https://rdap.org/
- crt.sh: https://crt.sh/
- GitHub REST API: https://docs.github.com/en/rest
- urlscan.io: https://urlscan.io/docs/
