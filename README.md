[![npm version](https://img.shields.io/npm/v/guacamole-common-js.svg)](https://www.npmjs.com/package/guacamole-common-js) [![downloads](https://img.shields.io/npm/dt/guacamole-common-js.svg)](https://www.npmjs.com/package/guacamole-common-js)

# guacamole-common-js

guacamole-common-js is the core JavaScript library of the
[Apache Guacamole](https://guacamole.apache.org/) web application. It provides
an HTTP and WebSocket tunnel for Guacamole protocol data, a protocol client,
and synchronized drawing layers.

Apache Guacamole does not publish this library to npm. This repository builds
it from the upstream release tags of
[apache/guacamole-client](https://github.com/apache/guacamole-client) and
publishes it as an npm package with CommonJS and ES module entry points.

```
npm install guacamole-common-js
```

```js
import Guacamole from 'guacamole-common-js';

// or CommonJS
const Guacamole = require('guacamole-common-js');
```

Each bundle also exists minified as `dist/{esm,cjs}/guacamole-common.min.js`.

## Version numbers

The npm version equals the Apache Guacamole release the package is built from.
Versions up to 1.5.0 came from an earlier build of this repository and
sometimes carry a letter suffix (`1.4.0-b`) for repackaging fixes. That build
took 1.5.0 from the upstream development branch, so it already contains APIs
that Apache released in 1.6.0, such as `Guacamole.Client.State` and
`Guacamole.Display.Statistics`. The releases 1.5.1 to 1.5.5 lack those APIs and
are not published here; upgrade from 1.5.0 to 1.6.0.

## How the package is built

`package.nix` fetches the release tag, concatenates the license header and all
modules in file name order (the same order upstream uses for its own bundle),
adds one export line per module format, and minifies with esbuild. A smoke test
loads all four bundles in Node.js and checks the `Guacamole` namespace.

```
nix build                               # build the package and run the smoke test
nix run .#update                        # bump to the newest Guacamole release
nix run .#update -- --version=1.6.0     # bump to a given release
```

A GitHub Actions job looks for a new upstream release every Monday and opens a
pull request that bumps `package.nix`. Merging it publishes the new version to
npm.

## Reporting problems

Bugs in the library itself belong to the Apache Guacamole project:
https://issues.apache.org/jira/browse/GUACAMOLE/

Problems with the npm package, such as a missing file or a broken export,
belong in this repository's issues.
