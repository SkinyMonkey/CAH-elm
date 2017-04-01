var express = require('express');
var app = express();
var expressWS = require('express-ws')(app);

var portNumber = 3000;

app.listen(portNumber, function() {
    console.log(`Listening on port ${portNumber}`);
});

app.ws('/', function(websocket, request) {
  console.log('A client connected!');

  websocket.on('message', function(message) {
    console.log(`A client sent a message: ${message}`);
    // websocket.send(JSON.stringify({action: "whiteJudgeCard", card: "Stupid Cunt."}));
  });
});
