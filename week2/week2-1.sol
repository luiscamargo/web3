// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./IERC20.sol";

contract ERC20_Week2_1 is IERC20 {

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    string public name = "Test";
    string public symbol = "TEST";
    uint8 public decimals = 18;

    function _transfer(address from, address to, uint256 amount) internal returns (bool) {
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }

    function transfer(address to, uint256 amount) virtual external returns (bool) {
        return _transfer(msg.sender,to, amount);
    }

    function _approve(address spender, uint256 amount) internal returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function approve(address spender, uint256 amount) virtual external returns (bool) {
        return _approve(spender, amount);
    }

    function _transferFrom(
        address from,
        address to,
        uint256 amount
    ) internal returns (bool) {
        allowance[from][to] -= amount;
        return _transfer(from,to,amount);
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) virtual external returns (bool) {        
        return _transferFrom(from,to,amount);
    }

    function _mint(address account, uint256 amount) internal returns(bool) {
        totalSupply += amount;
        balanceOf[account] += amount;
        emit Transfer(address(0), account, amount);
        return true;
    }

    function mint(address account, uint256 amount) virtual external returns(bool) {
        return _mint(account, amount);
    }

}