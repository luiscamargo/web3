// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./week2-1.sol";

contract ERC20_Week2_4 is ERC20_Week2_1 {

    address private owner;
    uint256 public tokensPerEther = 1000;

    constructor() {
        owner = msg.sender;
    }

    function mint(address account, uint256 amount) override external returns(bool) {
        require(msg.sender == owner);
        require(totalSupply + amount < 1000000 * 10 ** decimals, "Exceeds maximum supply");
        _mint(account, amount);
        return true;
    }

    function buyTokens() external payable virtual {

        // 1 ether buys tokensPerEther * 1e18
        // 1 wei (1/1e18 eth) buys (tokensPerEther * 1e18)/1e18 = tokensPerEther
        // msg.value is in wei
        uint256 tokensToBuy = msg.value * tokensPerEther;

        require(tokensToBuy > 0, "Not enough ether sent for minimum purchase");
        require(totalSupply + tokensToBuy <= 1000000 * 10 ** decimals, "Exceeds maximum supply");

        _mint(msg.sender, tokensToBuy);
    }

    function withdraw() external {
        require(msg.sender == owner);
        payable(owner).transfer(address(this).balance);
    }
}