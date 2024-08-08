const {
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { expect, assert } = require("chai");
const hre = require("hardhat");

describe("Proxy", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployFixture() {
    const Proxy = await hre.ethers.getContractFactory("Proxy");
    const proxy = await Proxy.deploy();

    const Logic1 = await hre.ethers.getContractFactory("Logic1");
    const logic1 = await Logic1.deploy();

    const Logic2 = await hre.ethers.getContractFactory("Logic2");
    const logic2 = await Logic2.deploy();

    // new hre.ethers.Interface(["function changeX() external"]);
    const proxyAsLogic1 = await hre.ethers.getContractAt(
      "Logic1",
      await proxy.getAddress()
    );
    const proxyAsLogic2 = await hre.ethers.getContractAt(
      "Logic2",
      await proxy.getAddress()
    );

    return { proxy, proxyAsLogic1, proxyAsLogic2, logic1, logic2 };
  }

  it("Should work with logic 1", async function () {
    const { proxy, logic1, proxyAsLogic1 } = await loadFixture(deployFixture);

    await proxy.changeImplementation(logic1.getAddress());

    assert.equal(await lookupUint(await proxy.getAddress(), "0x0"), 0);

    await proxyAsLogic1.changeX(52);

    assert.equal(await lookupUint(await proxy.getAddress(), "0x0"), 52);
  });

  //eth_getStorageAt
  async function lookupUint(contractAddr, slot) {
    return parseInt(await hre.ethers.provider.getStorage(contractAddr, slot));
  }

  it("Should work with upgrades", async function () {
    const { proxy, logic2, logic1, proxyAsLogic1, proxyAsLogic2 } =
      await loadFixture(deployFixture);

    await proxy.changeImplementation(logic1.getAddress());

    assert.equal(await lookupUint(await proxy.getAddress(), "0x0"), 0);

    await proxyAsLogic1.changeX(45);

    assert.equal(await lookupUint(await proxy.getAddress(), "0x0"), 45);

    await proxy.changeImplementation(logic2.getAddress());

    assert.equal(await lookupUint(await proxy.getAddress(), "0x0"), 45);

    await proxyAsLogic2.changeX(25);
    await proxyAsLogic2.tripleX();

    assert.equal(await lookupUint(await proxy.getAddress(), "0x0"), 150);
  });
});
