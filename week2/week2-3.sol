// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./week2-1.sol";

contract ERC20_Week2_3 is ERC20_Week2_1 {

    address private gov_address;
    mapping(address => bool) private blacklist;

    constructor() {
        gov_address = msg.sender;
    }

    function addToBlacklist(address entry) external {
        require(msg.sender == gov_address);
        blacklist[entry] = true;
    }

    function removeFromBlacklist(address entry) external {
        require(msg.sender == gov_address);
        if (blacklist[entry])
            delete blacklist[entry];
    }

    function _allowedToTransfer(address entry) internal view returns(bool) {
        return ! blacklist[entry];
    }

    function transfer(address to, uint256 amount) override external returns (bool) {
        require(_allowedToTransfer(msg.sender) && _allowedToTransfer(to));
        return _transfer(msg.sender,to, amount);
    }

    function approve(address spender, uint256 amount) override external returns (bool) {
        require(_allowedToTransfer(msg.sender) && _allowedToTransfer(spender));
        return _approve(spender, amount);
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) override external returns (bool) {
        require(_allowedToTransfer(msg.sender) && _allowedToTransfer(from) && _allowedToTransfer(to));
        allowance[from][msg.sender] -= amount;
        return _transfer(from,to,amount);
    }


}