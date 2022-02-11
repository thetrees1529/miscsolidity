//SPDX-License-Identifier: Unlicensed

import "../structs/ERC721Reference.sol";

pragma solidity ^0.8.0;

interface IERC721WithChildren {

    function getOwnedTokensOfToken(uint tokenId) external view returns(ERC721Reference[] memory);

    function ownerOfChild(ERC721Reference memory token) external view returns(address);

    function depositToken(uint to, ERC721Reference memory token) external;

    function withdrawToken(ERC721Reference memory token) external;

}