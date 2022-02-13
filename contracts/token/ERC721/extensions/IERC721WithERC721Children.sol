//SPDX-License-Identifier: Unlicensed

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

pragma solidity ^0.8.0;

interface IERC721WithERC721Children is IERC721Receiver {

    function depositERC721(uint to, IERC721 token, uint childTokenId) external;

    function withdrawERC721(uint from, address to, IERC721 token, uint childTokenId) external;

    function isOwnerOfERC721Child(uint tokenId, IERC721 token, uint childTokenId) external view returns(bool);

}