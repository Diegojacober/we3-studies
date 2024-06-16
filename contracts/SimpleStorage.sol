// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22 <0.9.0;

contract SimpleStorage {
    // boolean, unit, int, address, bytes
    // bool hasFavoriteNumber = true;
    uint256 favoriteNumber;
    // string favoriteNumberInTeste = "Five";
    // int256 favoriteInt = -5;
    // address myAddress = 0x3f449F7116Ee1eda1d7f12abBC49e69E474Ae584;
    // bytes32 favoriteBytes = "Dog";

    People[] public people;

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    //A mapping is a data structure where a key is "mapped" to a single value, like dictionary
    mapping (string => uint256) public nameToFavoriteNumber;


    function store(uint256 _favoriteNumber) virtual public {
        favoriteNumber = _favoriteNumber;
    }

    function retrieve() public view returns (uint256) {
        return favoriteNumber;
    }

    function add() public pure returns (uint256) {
        return (1 + 1);
    }

    //calldata, memory -> the variable is only gonna exist temporarily, during this transaction, calldata is read-only
    // storage -> variable exist even outside of just the function executing 
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        People memory newPerson = People({favoriteNumber: _favoriteNumber, name: _name});
        people.push(newPerson);
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}
