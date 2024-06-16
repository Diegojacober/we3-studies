// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22 <0.9.0;

// Get funds from user
// Withdraw funds
// set a minimum funding value in USD

contract FundMe {
    function fund() public payable {
        // want to be able to set a minimum fund amount in usd
        require(msg.value > 1e18, "Didn't send enough!"); // 1e18 == 1 * 10 * 18 = 1000000000000000000 wei = 1 eth 

        // UNDO ANY ACTION BEFORE, AND SEND REMAINING GAS BACK
    }

    // function withdraw() {}
}
