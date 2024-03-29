// A schema is a collection of type definitions (hence "typeDefs")
// that together define the "shape" of queries that are executed against
// your data.
export const typeDefs = `#graphql
type Book {
    title: String
    author: String
}
type Query {
    books: [Book]
}
`;

const books = [
    {
        title: 'The Awakening',
        author: 'Kate Chopin',
    },
    {
        title: 'City of Glass',
        author: 'Paul Auster',
    },
];

export const resolvers = {
    Query: {
        books: () => books,
    },
};
