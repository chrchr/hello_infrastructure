curl -X GET http://localhost:49191/appservers/balance_members
curl -X POST http://localhost:49191/appservers/balance_members -d '["http://www.google.com", "http://yahoo.com"]'
curl -X GET http://localhost:49191/appservers/balance_members
curl -X POST http://localhost:49191/appservers/commit -d ''
