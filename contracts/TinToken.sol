// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC20.sol";

contract TinToken is IERC20 {
    uint totalTokens;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowances;
    string public name = "TinToken";
    string public symbol = "TTN";

    constructor(uint initialSupply) {
        mint(initialSupply);
    }

    modifier enoughTokens(address _from, uint _amount) {
        require(balanceOf(_from) >= _amount, "Not enough tokens!");
        _;
    }

    function decimals() public override pure returns(uint) {
        return 0;
    }

    function totalSupply() public override view returns(uint) {
        return totalTokens;
    }

    function balanceOf(address account) public override view returns(uint) {
        return balances[account];
    }

    // списываем со счета отправителя, зачисляем на счет получателя
    function transfer(address to, uint amount) external override enoughTokens(msg.sender, amount) {
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to ,amount);
    }

    // сколько денег владелец может отправить получателю
    function allowance(address owner, address spender) external override view returns(uint) {
        return allowances[owner][spender];
    }

    // принимает адрес получателя и количество токенов
    function approve(address spender, uint amount) external override {
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
    }

    // другие смарт контракты могут переводить деньги, если это разрешено
    function transferFrom(address sender, address recipient, uint amount) external override enoughTokens(sender, amount) {
        allowances[sender][recipient] -= amount;
        balances[sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

    function mint(uint amount) public {
        balances[msg.sender] += amount;
        totalTokens += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint amount) public enoughTokens(msg.sender, amount) {
        balances[msg.sender] -= amount;
        totalTokens -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

    fallback() external payable{

    }

    receive() external payable{

    }
}