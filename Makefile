test: test-node test-browser
.PHONY: test

test-setup:
	@npx firebase setup:emulators:firestore

test-node:
	@npx firebase emulators:exec --only firestore "npx vitest run"

test-node-watch:
	@npx firebase emulators:exec --only firestore "npx vitest"

test-browser:
	@npx firebase emulators:exec --only firestore "env BROWSER=true npx vitest run --browser"

test-browser-watch:
	@npx firebase emulators:exec --only firestore "env BROWSER=true npx vitest --browser"

types:
	@npx tsc --noEmit

types-watch:
	@npx tsc --noEmit --watch

test-types: install-attw build 
	@cd lib && attw --pack

deploy-test-functions:
	@cd test/functions && npx firebase deploy --only functions:prepareVector

build: prepare-build
	@npx tsc -p tsconfig.lib.json 
	@env BABEL_ENV=esm npx babel src --config-file ./babel.config.lib.json --source-root src --out-dir lib --extensions .mjs,.ts --out-file-extension .mjs --quiet
	@env BABEL_ENV=cjs npx babel src --config-file ./babel.config.lib.json --source-root src --out-dir lib --extensions .mjs,.ts --out-file-extension .js --quiet
	@node copy.mjs
	@rm -rf lib/types.*js
	@make build-mts
	@rm lib/types.d.mts
	
build-mts:
	@find lib -name '*.d.ts' | while read file; do \
		new_file=$${file%.d.ts}.d.mts; \
		cp $$file $$new_file; \
	done

prepare-build:
	@rm -rf lib
	@mkdir -p lib

publish: build
	cd lib && npm publish --access public

publish-next: build
	cd lib && npm publish --access public --tag next

link:
	@cd lib && npm link

install-attw:
	@if ! command -v attw >/dev/null 2>&1; then \
		npm i -g @arethetypeswrong/cli; \
	fi