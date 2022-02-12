//SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
pragma solidity ^0.8.0;
struct ERC1155Reference {
    IERC1155 token;
    uint tokenId;
}