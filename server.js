const express = require('express');
const app = express();
const expressWS = require('express-ws')(app);

const portNumber = 3000;

app.listen(portNumber, () => {
    console.log(`Listening on port ${portNumber}`);
});

app.ws('/', (websocket, req) => {
  console.log('A client connected to /!')
  // FIXME : get all the tokens
})

// FIXME : debug, remove
// websocket.send(JSON.stringify({action: "whiteJudgeCard", card: "Stupid Cunt."}));
app.ws('/:gameToken', (websocket, req) => {
  console.log('A client connected!')

  console.log(req.params);

  const gameToken = req.params['game_token'];

  websocket.on('message', (message) => {
    switch (message.action) {
      case "connect":
       break;

      // Forwards the message to everyone else
      default:
        const room = expressWs.getWss(gameToken)

        room.clients.forEach((client) => {
          if (client != websocket) {
            client.send(message);
          }
        });
        break;
    }
  });
});
