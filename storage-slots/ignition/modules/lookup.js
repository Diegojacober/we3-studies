const hre = require("hardhat");
const {zeroPadValue, keccak256, toBeHex, toUtf8Bytes} = hre.ethers;
const addr = "0x5fbdb2315678afecb367f032d93f642f64180aa3";

async function lookup() {
    // eth_getStorageAt
    // const value = await hre.ethers.provider.getStorage(addr, "0x1");
    const key = zeroPadValue(toBeHex(44), 32);
    const baseSlot = zeroPadValue(toBeHex(0x2), 32).slice(2);
    const slot = keccak256(key  + baseSlot)
    const value = await hre.ethers.provider.getStorage(addr, slot);
    console.log(parseInt(value));
    const slot2 = keccak256(toUtf8Bytes("diego"))
    const value2 = await hre.ethers.provider.getStorage(addr, slot2);
    console.log(parseInt(value2))
}

lookup()