// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./TinToken.sol";

contract MarketPlace {
    IERC20 public token;
    address owner;
    address public thisAddr = address(this);

    event Bought(address indexed buyer, uint amount);
    event Sell(address indexed seller, uint amount);

    constructor(IERC20 _token) {
        token = _token;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner!");
        _;
    }

    function marketBalance() public view returns(uint) {
        return thisAddr.balance;
    }

    function buy() public payable {
        require(msg.value >= _rate(), "Incorrect sum");
        uint tokensAvailable = token.balanceOf(thisAddr);
        uint tokensToBuy = msg.value / _rate();
        require(tokensToBuy <= tokensAvailable, "Not enouth tokens!");
        token.transfer(msg.sender, tokensToBuy);
        emit Bought(msg.sender, tokensToBuy);
    }

    function sell(uint amount) public {
        require(amount > 0, "Tokens must be greater than 0");
        uint allowance = token.allowance(msg.sender, thisAddr);
        require(allowance >= amount, "Wrong allowance");
        token.transferFrom(msg.sender, thisAddr, amount);
        payable(msg.sender).transfer(amount * _rate());
        emit Sell(msg.sender, amount);
    }

    function withdraw(uint amount) public onlyOwner {
        require(amount <= marketBalance(), "Not enough funds!");
        payable(msg.sender).transfer(amount);
    }

    function _rate() private pure returns(uint) {
        return 1 ether; 
    }
}