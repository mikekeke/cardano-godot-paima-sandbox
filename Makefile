godot-website:
	cd web-server && python3 serve.py -n -p 8060 --root ./godot-web-export

# Serve original frontend from "open-world" template
original-frontend-website:
	cd web-server && python3 serve.py -n -p 8061 --root ../open-world/frontend

init:
	cd open-world && npm run initialize && npm install && npm run pack && npm run pack:middleware

init-batcher:
	./paima-engine batcher

distribute-middleware-and-helper-scripts:
	cp ./open-world/middleware/packaged/middleware.js ./godot-cip-30-prototype/extra-resources/paima/paimaMiddleware.js \
	&& cp ./open-world/middleware/packaged/middleware.js ./open-world/frontend/paimaMiddleware.js \
	&& cp -r ./godot-cip-30-prototype/extra-resources/paima ./web-server/godot-web-export

start-db:
	cd open-world && npm run database:up

start-chain:
	cd open-world && npm run chain:start

deploy-contracts:
	cd open-world && npm run chain:deploy

reset-db:
	cd open-world && npm run database:reset

start-paima-node:
	NETWORK=localhost ./paima-engine run

start-batcher:
	cd batcher && NETWORK=localhost ./start.sh

