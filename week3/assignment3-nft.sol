// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract OpenZeppelinNFT is ERC721 {

    uint256 public tokenSupply = 0;
    uint256 public constant MAX_SUPPLY = 10;

    address immutable deployer;

    constructor() ERC721("PupPicsNFT", "PUP") {
        deployer = msg.sender;
    }

    function mint() external {
        require(tokenSupply < MAX_SUPPLY, "supply used up");

        _mint(msg.sender, tokenSupply);
        tokenSupply++;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmV1rFLyTaLBpVbZhxSBnW9nJPFbgrVCbQenxWdphpkjY5/";
    }

    function viewBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function withdraw() external  {
        payable(deployer).transfer(address(this).balance);
    }

    function totalSupply() external pure returns (uint256) {
        return MAX_SUPPLY;
    }

}