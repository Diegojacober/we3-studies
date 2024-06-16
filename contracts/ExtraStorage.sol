// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22 <0.9.0;

import "./SimpleStorage.sol";

contract ExtraStorage is SimpleStorage {
    // + 5
    // override
    // virtual override
    function store(uint256 _favoriteNumber) override public {
        favoriteNumber = _favoriteNumber + 5;
    }
}