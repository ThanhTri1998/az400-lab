// L15 DEMO ONLY - deliberately vulnerable code so CodeQL raises alerts. Not used by the app.
const http = require('http');
const { exec } = require('child_process');

http.createServer((req, res) => {
  const url = new URL(req.url, 'http://localhost');
  const host = url.searchParams.get('host');
  const name = url.searchParams.get('name');

  if (url.pathname === '/ping') {
    // js/command-line-injection: user input concatenated into a shell command
    exec('ping -c 1 ' + host, (err, stdout) => res.end(stdout));
    return;
  }
  // js/reflected-xss: user input written into HTML without encoding
  res.writeHead(200, { 'Content-Type': 'text/html' });
  res.end('<h1>Hello ' + name + '</h1>');
}).listen(3999);
