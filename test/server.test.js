const http = require('http');
const { handler } = require('../src/server');

let server;
let base;

beforeAll((done) => {
  server = http.createServer(handler).listen(0, () => {
    base = `http://127.0.0.1:${server.address().port}`;
    done();
  });
});

afterAll((done) => {
  server.closeAllConnections(); // fetch keeps connections alive, close them so Jest can exit
  server.close(done);
});

test('GET /health returns OK', async () => {
  const res = await fetch(`${base}/health`);
  expect(res.status).toBe(200);
  expect(await res.text()).toBe('OK');
});

test('GET /price returns the discounted price', async () => {
  const res = await fetch(`${base}/price?price=80&discount=50`);
  expect(await res.json()).toMatchObject({ final: 40 });
});

test('GET /price with an invalid discount returns 400', async () => {
  const res = await fetch(`${base}/price?price=80&discount=150`);
  expect(res.status).toBe(400);
});
