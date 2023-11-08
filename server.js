const express = require('express');
const axios = require('axios');
const app = express();
const port = 3000;

var public_ip = ""

// Define an endpoint that returns current time, and saved result from ipify
app.get('/ip', (req, response) => {
  const currentTime = new Date().toLocaleTimeString();
  response.send(`The host's public ip is ${public_ip} and the host time is ${currentTime}`)
});

// Start the server, make a request to ipify and save result
app.listen(port, () => {
  axios.get('https://api.ipify.org?format=json')
  .then((res) => {
    public_ip = res.data.ip
    console.log(`Server is running on port ${port} at ${public_ip}, so go to ${public_ip}/api to see host ip and time`)
  })
});