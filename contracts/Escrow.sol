// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Escrow {
    address public depositor;
    address public beneficiary;
    address public arbiter;
    event Approved(uint);

    constructor(address _arbiter, address _beneficiary) payable {
        depositor = msg.sender;
        arbiter = _arbiter;
        beneficiary = _beneficiary;
    }

    function approve() external onlyArbiter {
        uint sentValue = address(this).balance;
        (bool s, ) = beneficiary.call{ value: sentValue }("");
        require(s);
        emit Approved(sentValue);
    }

    modifier onlyArbiter {
		require(arbiter == msg.sender, "only arbiter can access this function");
		_;
	}
}