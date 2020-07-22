// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

pragma experimental ABIEncoderV2;

contract Forex {

    address public owner;

    struct Pair {
        string rate;
        string timestamp;
    }

    mapping(address => bool) users;
    mapping(bytes32 => Pair) pairs;


    constructor() public {
        owner = msg.sender;
    }

    modifier restricted() {
        if (msg.sender == owner) _;
    }

    modifier authorized() {
        if (users[msg.sender]) _;
    }

    function authorize(address user) public restricted {
        users[user] = true;
    }

    function set(string memory name, Pair memory pair) public authorized {

        bytes32 nameHash = keccak256(abi.encode(name));
        pairs[nameHash] = pair;
    }

    function get(string memory name) public view returns (Pair memory) {

        bytes32 nameHash = keccak256(abi.encode(name));
        return pairs[nameHash];
    }
}
