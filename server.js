const express = require('express');
const app = express();
const expressWs = require('express-ws')(app);

const portNumber = 3000;

app.listen(portNumber, function() {
    console.log(`Listening on port ${portNumber}`);
});

app.ws('/', function(websocket, request) {
  console.log('A client connected!');

  const room = expressWs.getWss('/');

  websocket.broadcast = (message) => {
    console.log('broadcasting: ', message);
    room.clients.forEach((client) => {
//      if (client != websocket) {
        client.send(message);
//      }
    });
  };

  websocket.sendMessage = (message) => {
    websocket.send(JSON.stringify(message));
  }

  room.clients.forEach((client, index) => {
    if (index == 0) return;

    websocket.sendMessage({
      action : 'newPlayer',
      name : `Player ${index}`
    });
  });

  if (room.clients.size == 1) {
    console.log('Is a judge');
    websocket.sendMessage({ action : 'setup', role : 'judge' });
  }
  else {
    console.log('Is a player');
    websocket.sendMessage({ action : 'setup', role : 'player' });
  }

  websocket.on('message', (message) => websocket.broadcast(message));
});
