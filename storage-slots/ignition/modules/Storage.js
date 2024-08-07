const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("StorageModule", (m) => {

  const storage = m.contract("Storage", [], {
    
  });

  console.log(storage)
  return { storage: storage };
});
