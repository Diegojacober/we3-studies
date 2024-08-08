// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// EOA -> Proxy -> Logic1
//              -> Logic2

import "./StorageSlot.sol";

contract Proxy {
    function changeImplementation(address _implementation) external {
        StorageSlot.getAddressSlot(keccak256("impl")).value = _implementation;
    }

    // when have a big protocol all data are passing to contract from other, all data is living in logic contract
    // fallback() external {
    //     (bool success, ) = implementation.call(msg.data);
    //     require(success);
    // }

    fallback() external {
        (bool success, ) = StorageSlot.getAddressSlot(keccak256("impl")).value.delegatecall(msg.data);
        require(success);
    }
}

contract Logic1 {
    uint x = 0;

    function changeX(uint _x) external {
        x = _x;
    }
}

contract Logic2 {
    uint x = 0;

    function changeX(uint _x) external {
        x = _x * 2;
    }

    function tripleX() external{
        x *= 3;
    }
}
