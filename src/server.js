const http = require('http');
const { applyDiscount } = require('./pricing');

const port = process.env.PORT || 3100;
const version = process.env.APP_VERSION || require('../package.json').version;

function handler(req, res) {
  const url = new URL(req.url, 'http://localhost');
  if (url.pathname === '/health') {
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    return res.end('OK');
  }
  if (url.pathname === '/price') {
    const price = Number(url.searchParams.get('price'));
    const discount = Number(url.searchParams.get('discount') || 0);
    try {
      const final = applyDiscount(price, discount);
      res.writeHead(200, { 'Content-Type': 'application/json' });
      return res.end(JSON.stringify({ price, discount, final }));
    } catch (err) {
      res.writeHead(400, { 'Content-Type': 'application/json' });
      return res.end(JSON.stringify({ error: err.message }));
    }
  }
  res.writeHead(200, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({
    app: 'az400-app',
    version,
    environment: process.env.APP_ENV || 'local',
    siteName: process.env.WEBSITE_SITE_NAME || null,
    time: new Date().toISOString(),
  }));
}

if (require.main === module) {
  http.createServer(handler).listen(port, () => console.log(`az400-app ${version} listening on ${port}`));
}

module.exports = { handler };
