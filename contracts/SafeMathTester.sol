// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22 <0.9.0;

contract SafeMathTester {
    uint8 public bigNumber = 255; // unched before 0.8.0 - unchecked, but now is checked

    function add() public{
        unchecked {bigNumber = bigNumber + 1;} 
    }
}