// L15 DEMO - fixed version of the deliberately vulnerable code. Not used by the app.
const http = require('http');
const { execFile } = require('child_process');

const escapeHtml = (s) => String(s).replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));

http.createServer((req, res) => {
  const url = new URL(req.url, 'http://localhost');
  const host = url.searchParams.get('host') || '';
  const name = url.searchParams.get('name') || '';

  if (url.pathname === '/ping') {
    // FIX: validate input + execFile (no shell) with an argument array
    if (!/^[a-zA-Z0-9.-]{1,253}$/.test(host)) { res.statusCode = 400; return res.end('bad host'); }
    execFile('ping', ['-c', '1', host], (err, stdout) => res.end(stdout));
    return;
  }
  // FIX: encode output before writing it into HTML
  res.writeHead(200, { 'Content-Type': 'text/html' });
  res.end('<h1>Hello ' + escapeHtml(name) + '</h1>');
}).listen(3999);
