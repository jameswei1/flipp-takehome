const express = require('express');
const axios = require('axios');
const app = express();
const port = 3000;

// Define an endpoint that makes an additional request to ipify and returns whatever that returns
app.get('/ip', (req, response) => {
    axios.get('https://api.ipify.org?format=json')
    .then((res) => {
        const currentTime = new Date().toLocaleTimeString();
        response.send(`The host's public ip is ${res.data.ip} and the host time is ${currentTime}`)
    })
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});