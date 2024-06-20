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

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable {
        // want to be able to set a minimum fund amount in usd
        // require(getConversionRate(msg.value) >= minimumUsd, "Didn't send enough!"); // 1e18 == 1 * 10 * 18 = 1000000000000000000 wei = 1 eth
        require(
            msg.value.getConversionRate() >= minimumUsd,
            "Didn't send enough!"
        );

        // UNDO ANY ACTION BEFORE, AND SEND REMAINING GAS BACK
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    function withdraw() public onlyOwner {
        /* starting index, ending index, step amount*/
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        //reset the array
        funders = new address[](0);
        // actually withdraw the funds

        // transfer - is the simplwst and surface way
        // msg.sender = address
        // payable(msg.sender) = payable address
        // transfer (2300 gas, throws error)
        // send (2300 gas, returns bool)
        // call (forward all gas or set gas, returns bool)
        //payable(msg.sender).transfer(address(this).balance);
        //send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");
        //call
        // https://ethereum.stackexchange.com/questions/74442/when-should-i-use-calldata-and-when-should-i-use-memory
        (bool callSuccess, bytes memory dataReturned) = payable(msg.sender)
            .call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    // customizied modifier
    modifier onlyOwner() {
        require(msg.sender == owner, "Sender is not owner!");
        _;
    }
}
