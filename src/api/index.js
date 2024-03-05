const { response } = require("express");
const express = require("express");
const app = express();

const port = process.env.PORT || 8080;

app.get("/", (req, res) => {
  res.send({
    message: "Here's your response from the node.js 🐳 container",
  });
});

app.get("/test", (req, res) => {
  if (req.body) {
    alert(req.body);
    res.send({
      message:
        "Here's your response from test URL in the node.js 🐳 container with this in the request body",
    });
  } else {
    res.send({
      message:
        "Here's your response from test URL in the node.js 🐳 container with nothing in the request body",
    });
  }
});

app.listen(port, () => {
  console.log(`Hi there, I'm listening on port http://localhost:${port}`);
});
