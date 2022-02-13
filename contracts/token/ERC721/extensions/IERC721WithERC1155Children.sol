//SPDX-License-Identifier: Unlicensed

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";

pragma solidity ^0.8.0;

interface IERC721WithERC1155Children is IERC1155Receiver {

    function depositERC1155(uint to, IERC1155 token, uint childTokenId, uint amount) external;

    function withdrawERC1155(uint from, address to, IERC1155 token, uint childTokenId, uint amount) external;

    function balanceOfERC1155Child(uint tokenId, IERC1155 token, uint childTokenId) external view returns(uint);

}