// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PupPicsToken is ERC20 {

    uint256 public constant TOKENS_PER_ETHER = 10000;
    address immutable deployer;

    constructor() ERC20("PupPicsToken", "PUPT") {
        deployer = msg.sender;
    }

    receive() external payable {
        revert("Use buyTokens() to buy tokens");
    }

    fallback() external payable {
        revert("Unknown function called");
    }

    function buyTokens() external payable virtual {

        // 1 ether buys tokensPerEther * 10e18
        // 1 wei (1/10e18 eth) buys (tokensPerEther * 10e18)/10e18 = tokensPerEther
        // msg.value is in wei
        uint256 tokensToBuy = msg.value * TOKENS_PER_ETHER;

        require(tokensToBuy > 0, "Not enough ether sent for minimum purchase");

        // if there's supply left mint new tokens
        if ( totalSupply() + tokensToBuy <= 1000000 * 10 ** decimals() ) {

            _mint(msg.sender, tokensToBuy);
        }
        // if there's no supply left, but the contract owns enough tokens, sell the contract's tokens
        else if ( balanceOf(address(this)) <= tokensToBuy ) {
        
            _transfer(address(this), msg.sender, tokensToBuy);
        }
        else {

            revert("Exceeds maximum supply");
        }
    }


    function withdraw() external  {
        require(msg.sender == deployer, "must be owner");
        payable(deployer).transfer(address(this).balance);
    }
}