// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./week2-4.sol";

contract ERC20_Week2_5 is ERC20_Week2_1 {

    address private owner;
    uint256 public tokensPerEther = 1000;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        revert("Use buyTokens() to buy tokens");
    }

   fallback() external payable {
        revert("Unknown function called");
    }

    function mint(address account, uint256 amount) override external returns(bool) {
        require(msg.sender == owner);
        require(totalSupply + amount < 1000000 * 10 ** decimals, "Exceeds maximum supply");
        _mint(account, amount);
        return true;
    }

    function buyTokens() external payable virtual returns(bool) {

        // 1 ether buys tokensPerEther * 10e18
        // 1 wei (1/10e18 eth) buys (tokensPerEther * 10e18)/10e18 = tokensPerEther
        // msg.value is in wei
        uint256 tokensToBuy = msg.value * tokensPerEther;

        require(tokensToBuy > 0, "Not enough ether sent for minimum purchase");

        // if there's supply left mint new tokens
        if ( totalSupply + tokensToBuy <= 1000000 * 10 ** decimals ) {

            _mint(msg.sender, tokensToBuy);
            return true;
        }
        // if there's no supply left, but the contract owns enough tokens, sell the contract's tokens
        else if ( balanceOf[address(this)] <= tokensToBuy ) {
        
            _transfer(address(this), msg.sender, tokensToBuy);
            return true;
        }
        else {

            revert("Exceeds maximum supply");
        }
    }

    function sellTokens(uint256 amount) external returns(bool) {

        require(allowance[msg.sender][address(this)] >= amount);
        require(balanceOf[msg.sender] >= amount);
        
        // amount is integer representation with 18 decimal places (1e18)
        // seller receives 0.5 ether = 5e17 wei for each 1000 tokens (1000*1e18)
        // 1000*1e18 * paymentFactor = 5e17
        // paymentFactor = (1000*1e18)/5e17
        // paymentFactor = 2000
        // seller receives amount / paymentFactor in wei
        uint256 payment = amount / 2000;

        require(address(this).balance >= payment);
        payable(msg.sender).transfer(payment);

        _transferFrom(msg.sender, address(this), amount);
        return true;
    }


    function withdraw() external returns(bool) {
        require(msg.sender == owner);

        payable(owner).transfer(address(this).balance);
        return true;
    }

    function checkContractBalancer() external view returns (uint256) {
        return address(this).balance;
    }
}