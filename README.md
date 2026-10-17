# MyLast — Linux Authentication Log Monitor

A Bash script that emulates the `last` / `lastb` commands by reading the **text-based**
`/var/log/auth.log` instead of the binary `wtmp` / `btmp` databases.
Built for the **ITBI** course (Faculty of Mathematics and Computer Science,
University of Bucharest, 2025) by team *The Pursuit of Happyness*:
Antonia Gherghe and Luca Popescu.

## What it does
- `last` mode: lists successful logins (`Accepted password`, `session opened`)
- `lastb` mode: lists failed attempts (`Failed password`, `authentication failure`)
- Reads rotated and gzip-compressed logs (`auth.log.1`, `auth.log.N.gz`) directly with `zgrep`
- Shows the newest entries first, with an optional limit (`-n`)

## How it works
```
zgrep (match events) → sort -r (newest first) → head -n (limit) → awk (user, date, time)
```
Arguments are parsed with a `while` / `case` / `shift` loop.

## Usage
Log files under `/var/log` belong to `root:adm`, so the script needs `sudo`.

```bash
chmod +x mylast.sh
sudo ./mylast.sh            # successful logins
sudo ./mylast.sh lastb      # failed login attempts
sudo ./mylast.sh -n 10      # only the 10 most recent entries
```

Tested on Debian/Ubuntu, where SSH and login events go to `/var/log/auth.log`.

The full documentation (in Romanian) is in [`docs/Documentatie.pdf`](docs/Documentatie.pdf).
