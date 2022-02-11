//SPDX-License-Identifier: Unlicensed

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./IERC721WithChildren.sol";

pragma solidity ^0.8.0;

abstract contract ERC721WithChildren is IERC721WithChildren, ERC721 {

    using Counters for Counters.Counter;

    mapping(uint => ERC721Reference[]) _ownedTokensOfTokens;
    mapping(IERC721 => mapping(uint => uint)) _ownedTokensToParentTokens;
    mapping(IERC721 => mapping(uint => uint)) _ownedTokensIndexes;
    mapping(uint => Counters.Counter) _ownedTokensCounts;

    function getOwnedTokensOfToken(uint tokenId) public view returns(ERC721Reference[] memory) {
        return _ownedTokensOfTokens[tokenId];
    }

    function ownerOfChild(ERC721Reference memory token) public view returns(address) {
        return ownerOf(_ownedTokensToParentTokens[token.token][token.tokenId]);
    }

    function depositToken(uint to, ERC721Reference memory token) public {

        token.token.transferFrom(msg.sender, address(this), token.tokenId);

        _ownedTokensOfTokens[to].push(token);

        _ownedTokensToParentTokens[token.token][token.tokenId] = to;
        _ownedTokensIndexes[token.token][token.tokenId] = _ownedTokensOfTokens[to].length - 1;

        _ownedTokensCounts[to].increment();

    }

    function withdrawToken(ERC721Reference memory token) public {

        require(msg.sender == ownerOfChild(token), "Not owner of child token.");

        uint parentTokenId = _ownedTokensToParentTokens[token.token][token.tokenId];

        uint ownedTokenIndex = _ownedTokensIndexes[token.token][token.tokenId];
        uint ownedTokensLastIndex = _ownedTokensOfTokens[parentTokenId].length - 1;

        ERC721Reference memory lastOwnedToken = _ownedTokensOfTokens[parentTokenId][ownedTokensLastIndex];

        _ownedTokensOfTokens[parentTokenId][ownedTokenIndex] = _ownedTokensOfTokens[parentTokenId][ownedTokensLastIndex];

        _ownedTokensOfTokens[parentTokenId].pop();

        _ownedTokensIndexes[lastOwnedToken.token][lastOwnedToken.tokenId] = ownedTokenIndex;

        _ownedTokensCounts[parentTokenId].decrement();

    }

}