// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./week2-1.sol";

contract ERC20_Week2_2 is ERC20_Week2_1 {

    address private god_address;

    constructor() {
        god_address = msg.sender;
    }

    function mintTokensToAddress(address recipient, uint256 amount) external returns (bool) {
        require(msg.sender == god_address);
        _mint(recipient, amount);
        return true;
    }

    function reduceTokensAtAddress(address target, uint256 amount) external returns (bool) {
        require(msg.sender == god_address);
        balanceOf[target] -= amount;
        totalSupply -= amount;
        return true;
    }

    function authoritativeTransferFrom(address from, address to, uint256 amount) external returns (bool) {
        require(msg.sender == god_address);
        return _transfer(from, to, amount);        
    }

}