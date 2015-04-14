try {
  rs.conf();
} catch (e) {
  rs.initiate(
    {"_id" : "peakaboo",
     "members": [{"_id": 0,
                  "host":"127.0.0.1"
                 }]
    }
  );
} finally {
  db.shutdownServer({force: true, timeoutSecs: 1});
}
