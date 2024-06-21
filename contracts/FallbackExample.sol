// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22 <0.9.0;

// fallback() - https://docs.soliditylang.org/en/v0.8.26/contracts.html#fallback-function
// receive() - https://docs.soliditylang.org/en/v0.8.26/contracts.html#receive-ether-function

contract FallbackExample {
    uint256 public result;

    // is a special function, whenever we send eth or make a transation to this contract
    // now, as long as there is no data associated with that transaction, this function will get triggered
    receive() external payable {
        result = 1;
    }

    fallback() external payable { 
        result = 2;
    }

    // https://solidity-by-example.org/fallback/
}
