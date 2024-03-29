import { ApolloServer } from '@apollo/server';
import { expressMiddleware } from '@apollo/server/express4';
import { ApolloServerPluginDrainHttpServer } from '@apollo/server/plugin/drainHttpServer';
import express from 'express';
import http from 'http';
import cors from 'cors';
import bodyParser from 'body-parser';
import { typeDefs, resolvers } from './schema';
import axios from "axios";

interface MyContext {
    token?: String;
}
// ECS-trader-tracker-aggregator-task-execution-role check why i dont get the execute role perms
const run = async () => {
    axios.get('http://internal-trader-tracker-private-alb-1481817480.eu-west-1.elb.amazonaws.com/trader-tracker-backend/').then(resp => {

        console.log(resp.data);
    }).catch(console.error);
    // Required logic for integrating with Express
    const app = express();
    // Our httpServer handles incoming requests to our Express app.
    // Below, we tell Apollo Server to "drain" this httpServer,
    // enabling our servers to shut down gracefully.
    const httpServer = http.createServer(app);

    // Same ApolloServer initialization as before, plus the drain plugin
    // for our httpServer.
    const server = new ApolloServer<MyContext>({
        typeDefs,
        resolvers,
        plugins: [ApolloServerPluginDrainHttpServer({ httpServer })],
    });
    // Ensure we wait for our server to start
    await server.start();

    // Set up our Express middleware to handle CORS, body parsing,
    // and our expressMiddleware function.
    // Requests to `http://localhost:4000/health` now return "Okay!"
    app.get('/health', (req, res) => {
        res.status(200).send('Okay!');
    });

    app.use(
        '/',
        cors<cors.CorsRequest>(),
        bodyParser.json(),
        // expressMiddleware accepts the same arguments:
        // an Apollo Server instance and optional configuration options
        expressMiddleware(server, {
            context: async ({ req }) => ({ token: req.headers.token }),
        }),
    );

    // Modified server startup
    await new Promise<void>((resolve) => httpServer.listen({ port: 5000 }, resolve));
    console.log(`🚀 Server ready at http://localhost:5000/`);
}
run()