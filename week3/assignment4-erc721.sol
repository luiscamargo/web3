// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PupPicsNFT is ERC721 {

    uint256 public tokenSupply = 0;
    uint256 public constant MAX_SUPPLY = 10;
    address public constant ERC20_TOKEN_CONTRACT = address(0x2460d8e19f8d5b7AA0DD640DA02d00a0B43a67c2);

    address immutable deployer;

    constructor() ERC721("PupPicsNFT", "PUPN") {
        deployer = msg.sender;
    }

    function mint() external payable {
        require(tokenSupply < MAX_SUPPLY, "supply used up");
        require(
            IERC20(ERC20_TOKEN_CONTRACT).transferFrom(msg.sender,address(this),10*1e18),
            "requires 10 PUPT tokens to mint"
        );

        _mint(msg.sender, tokenSupply);
        tokenSupply++;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmV1rFLyTaLBpVbZhxSBnW9nJPFbgrVCbQenxWdphpkjY5/";
    }

    function totalSupply() external pure returns (uint256) {
        return MAX_SUPPLY;
    }

}