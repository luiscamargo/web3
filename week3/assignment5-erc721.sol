// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PupPicsNFT is ERC721 {

    uint256 public tokenSupply = 0;
    uint256 public constant MAX_SUPPLY = 10;
    address public constant ERC20_TOKEN_CONTRACT = address(0x2460d8e19f8d5b7AA0DD640DA02d00a0B43a67c2);
    uint256 public constant PAYMENT_PERIOD_IN_SECONDS = 86400;
    uint256 public constant PAYMENT_AMOUNT_PER_PERIOD = 10;
    mapping(address => mapping(uint256 => uint256)) public stakes;

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

    function stakeNFT(uint256 _tokenId) external {
        require(ownerOf(_tokenId) == msg.sender,"must be NFT owner");
        stakes[msg.sender][_tokenId] = block.timestamp;
        _transfer(msg.sender,address(this),_tokenId);
    }

    function withdrawNFT(uint256 _tokenId) external {
        require(stakes[msg.sender][_tokenId] != 0,"NFT is not staked or not owner");
        delete stakes[msg.sender][_tokenId];
        _transfer(address(this),msg.sender,_tokenId);
    }

    function collectPayment(uint256 _tokenId) external {
        require(stakes[msg.sender][_tokenId] != 0,"NFT is not staked or not owner");

        uint256 currentTime = block.timestamp;
        uint256 elapsedTime =  currentTime - stakes[msg.sender][_tokenId];
        uint256 paymentAmount = elapsedTime / PAYMENT_PERIOD_IN_SECONDS * PAYMENT_AMOUNT_PER_PERIOD * 1e18;

        require(paymentAmount > 0, "no outstanding payment");

        stakes[msg.sender][_tokenId] = currentTime - elapsedTime % PAYMENT_PERIOD_IN_SECONDS;

        require(
            IERC20(ERC20_TOKEN_CONTRACT).transfer(msg.sender,paymentAmount),
            "payment failed"
        );
    }

    function expectedPayment(uint256 _tokenId) external view returns (uint256) {
        require(stakes[msg.sender][_tokenId] != 0,"NFT is not staked or not owner");

        uint256 currentTime = block.timestamp;
        uint256 elapsedTime =  currentTime - stakes[msg.sender][_tokenId];
        uint256 paymentAmount = elapsedTime / PAYMENT_PERIOD_IN_SECONDS * PAYMENT_AMOUNT_PER_PERIOD * 1e18;
        
        return paymentAmount;
    }
}