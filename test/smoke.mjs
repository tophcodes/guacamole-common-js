// Loads every bundle of a built package and checks that it exposes the
// Guacamole namespace. Usage: node smoke.mjs <package directory>

import assert from "node:assert/strict";
import { createRequire } from "node:module";
import { join } from "node:path";
import { pathToFileURL } from "node:url";

const dir = process.argv[2];
const require = createRequire(join(dir, "package.json"));

const bundles = {
	cjs: require(join(dir, "dist/cjs/guacamole-common.js")),
	"cjs min": require(join(dir, "dist/cjs/guacamole-common.min.js")),
	esm: (await import(pathToFileURL(join(dir, "dist/esm/guacamole-common.js"))))
		.default,
	"esm min": (
		await import(pathToFileURL(join(dir, "dist/esm/guacamole-common.min.js")))
	).default,
};

for (const [name, Guacamole] of Object.entries(bundles)) {
	for (const member of [
		"Client",
		"Tunnel",
		"WebSocketTunnel",
		"Keyboard",
		"Mouse",
		"Display",
	]) {
		assert.equal(
			typeof Guacamole[member],
			"function",
			`${name}: Guacamole.${member}`,
		);
	}
}

console.log(`ok: ${Object.keys(bundles).join(", ")}`);
