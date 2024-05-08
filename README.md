This repo is combination of Paima's "open-world" template and Godot project that serves for testing interactions between web-exported Godot project and Paima middleware.


## Repo overview

- `bather`, `open-world` and `packaged` are created is some way or another by `paima-engine-linux`
  - `open-world` is the project, that I'm trying to connect godot to, it already has its own simple frontend with HTML and JS; the dir of the project is used to spin up local network, paima node and batcher
- `godot-cip-30-prototype` - Godot project to test interactions with Paima middleware
  - `extra-resources`
  - `index.html` - custom HTML shell for web-export, it adds to header scripts from `paima` dir
  - `paima` - contains packaged Paima middleware (`paimaMiddleware.js`) and wrappers around GDScript functions to enable CIP-30 interface; would be great to mike somehow so this directory will be exported together with the project, currently it should be copied manually to [web-server dir](./web-server/godot-web-export/) with `make copy-paima-dir`
- `web-server` - dir for godot web-export

## Starting the thing

Paima setup requires Docker.

From fresh repo proceed with following steps:

1. `nix develop`
2. `make init` (goes through initialization process according to the [open-world-readme](./open-world/README.md); tested in Linux,some extra flags are required for macOS, see the readme; if there is some "red" messages about vulnerabilities it should be ok, but no other errors should appear; initialization was done already for this project, but it won't hurt to run it again)
3. ⚠️ (batcher issues) Got to `open-world/middleware/packaged/middleware.js` and change `var batcherUri = ENV.BATCHER_URI` to `var batcherUri = "http://localhost:3340"`
4. `make distribute-middleware-and-helper-scripts`
5. `make start-db` (will keep running in  terminal)
6. `make start-chain` (will keep running in  terminal)
7. `make deploy-contracts`
8. `make start-paima-node` (will keep running in  terminal)
9. `make start-batcher` (will keep running in  terminal)

None of these processes should report any errors.

From here it is possible to either run original frontend for "open-world" game with `original-frontend-website` (http://localhost:8061/index.html) or run web-export of godot prototype with `godot-website` (http://localhost:8060/index.html).

Godot prototype is currently very WIP, login button works by providing mock wallet address via CIP-30 interface. But making a move will fail to validate signature, as data was takes from Nami wallet and message that is being signed contains timestamp. Sot here is nop way really to mock `signData` for now.

⚠️ After changes in the paima middleware it is better to reopen site in new private window, coz even reloading page without cache can cause issues from my experience.
