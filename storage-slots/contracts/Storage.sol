// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "./StorageSlot.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Storage {
    /*
    uint x = 97; // 0x0
    uint y = 56; // 0x1
    //eth_getStorageAt

    // keccark256(key + base)
    mapping(uint => uint) testing; // base = 0x2

    constructor() {
        // keccark256(21 + 0x2)
        testing[21] = 77;
        // keccark256(44 + 0x2)
        testing[44] = 98;
    }
    */

   constructor() {
      // 32 bytes - 256 bits
      // keccak256("diego") -> 256
      StorageSlot.getUint256Slot(keccak256("diego")).value = 256;

   }
}
