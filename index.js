if (require.extensions['.coffee']) {
  module.exports = require('./lib/mock-client-http.coffee');
} else {
  module.exports = require('./out/release/lib/mock-client-http.js');
}