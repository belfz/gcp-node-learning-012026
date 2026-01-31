import fastify from 'fastify';
const app = fastify({ logger: true });

app.get('/', async (request, reply) => {
  return { hello: 'ELUWINA', timestamp: new Date() };
});

const start = async () => {
  try {
    await app.listen({ port: 3000, host: '0.0.0.0' });
  } catch (err) {
    app.log.error(err);
    process.exit(1);
  }
};

start();
