# Kona Web Proof Notes

## Result

Kona successfully served a live web app over HTTP.

The proof app:
- serves HTML from Kona
- serves JSON from Kona
- keeps mutable server-side state in Kona
- routes requests through `.m.h`

Confirmed working on localhost with:

```bash
cd /home/james/Documents/kona-master/james-scripts
../k -h 8094 proof_web.k
```

If a port is already in use, Kona prints:

```text
server: failed to bind
```

That is a port conflict, not an app failure. Use a different port.

## Routes

- `/` -> HTML page
- `/api` -> JSON state
- `/inc` -> increments counter and returns JSON
- `/reset` -> resets counter and returns JSON

Example JSON response:

```json
{"count":0,"kind":"proof"}
```

## What Was Learned

1. Kona can act as a small backend directly.
2. Kona can build and return raw HTTP responses as char vectors.
3. `json.k` is enough to emit structured JSON from K objects.
4. The HTTP entrypoint `.m.h` is sensitive to return shape.
5. For this proof, the safest path was to return a plain char vector directly from `.m.h`.

## Important Detail

An earlier app shape was close but not reliable under the HTTP bridge.
Flattening the handler into a single explicit `.m.h` expression made the route behavior stable.

## Files

- `proof_web.k` -> working proof app
- `json.k` -> JSON encoder/decoder used by the app
- `web.k` -> earlier example of Kona serving HTML and JSON
- `counter_app.k` -> earlier stateful example that helped reveal handler-shape issues
- `../src/kn.c` -> HTTP bridge behavior for `.m.h`
- `../src/kc.c` -> server bind/startup path

## Working Command

```bash
cd /home/james/Documents/kona-master/james-scripts
../k -h 8094 proof_web.k
```
