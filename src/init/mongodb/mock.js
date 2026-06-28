conn = new Mongo();
db = conn.getDB("testdb");

db.mock.insertMany([
    { key1: "value1", key2: 1 },
    { key1: "value2", key2: 2 },
]);
