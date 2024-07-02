const express = require("express");
const app = express();
const cors = require("cors");
const port = 3042;

app.use(cors());
app.use(express.json());

const balances = {
  "034de91d0e3280a0960f63dab221e537262dd7f98e6f8232e84fff39cee4914c1b": 100,
  // 6eba81856cb5e14c66e7f4a4651d66b9e70bec94c078dd816fd6d9150c275aa4
  "03bb0108b3e2880babfd6992536b978dcc31ad3d288c741350c644b48284f4464f": 50,
  // 27085ea507264daa00c2cbf5cdb1dbba89f2bca0e7541c4998c158f780d520c6
  "02edf43761ec649b464161e8b8bbcec3d5c08041b207a6451fc93b5c6dede7407e": 75,
  // 1c18afbaff2c6813fb60905f830add00857076ff77c51d61b2ed0e61f28d2933
};

app.get("/balance/:address", (req, res) => {
  const { address } = req.params;
  const balance = balances[address] || 0;
  res.send({ balance });
});

app.post("/send", (req, res) => {
  const { sender, recipient, amount } = req.body;

  setInitialBalance(sender);
  setInitialBalance(recipient);

  if (balances[sender] < amount) {
    res.status(400).send({ message: "Not enough funds!" });
  } else {
    balances[sender] -= amount;
    balances[recipient] += amount;
    res.send({ balance: balances[sender] });
  }
});

app.listen(port, () => {
  console.log(`Listening on port ${port}!`);
});

function setInitialBalance(address) {
  if (!balances[address]) {
    balances[address] = 0;
  }
}
