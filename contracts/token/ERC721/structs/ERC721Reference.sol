//SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
pragma solidity ^0.8.0;
struct ERC721Reference {
    IERC721 token;
    uint tokenId;
}