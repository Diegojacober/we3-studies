// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22 <0.9.0;

import "./PriceConverter.sol";
// Get funds from user
// Withdraw funds
// set a minimum funding value in USD

contract FundMe {
    using PriceConverter for uint256;
    uint256 public minimumUsd = 50 * 1e18;

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    function fund() public payable {
        // want to be able to set a minimum fund amount in usd
        // require(getConversionRate(msg.value) >= minimumUsd, "Didn't send enough!"); // 1e18 == 1 * 10 * 18 = 1000000000000000000 wei = 1 eth
        require(msg.value.getConversionRate() >= minimumUsd, "Didn't send enough!"); 

        // UNDO ANY ACTION BEFORE, AND SEND REMAINING GAS BACK
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;

    }

    // function withdraw() {}
}
