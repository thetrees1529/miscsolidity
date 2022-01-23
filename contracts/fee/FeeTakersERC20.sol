//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

abstract contract FeeTakersERC20 is Ownable{
    struct FeeTakerERC20 {
        address addr;
        uint points;
    }
    FeeTakerERC20[] _feeTakersERC20;

    event FeeSentERC20(address to, uint amount);    

    //manage where profit is sent to
    function getFeeTakersERC20Length() public view onlyOwner returns(uint) {
        return _feeTakersERC20.length;
    }
    function getFeeTakerERC20At(uint index) public view onlyOwner returns(FeeTakerERC20 memory) {
        return _feeTakersERC20[index];
    }
    function addToFeeTakersERC20(address addr, uint points) public onlyOwner {
        _feeTakersERC20.push(FeeTakerERC20(addr, points));
    }
    function removeFromFeeTakersERC20(uint index) public onlyOwner {
        _feeTakersERC20[index] = _feeTakersERC20[_feeTakersERC20.length - 1];
        _feeTakersERC20.pop();
    }

    function _distributeFeeERC20(IERC20 token, uint fee) internal {
        uint feePoints;
        uint feePerPoint;
        for(uint i; i < _feeTakersERC20.length; i ++) {
            feePoints += _feeTakersERC20[i].points;
        }
        if(feePoints > 0) {
            feePerPoint = fee / feePoints;
        }
        for(uint i; i < getFeeTakersERC20Length(); i ++) {
            FeeTakerERC20 storage feeTaker = _feeTakersERC20[i];
            address feeTakerAddr = feeTaker.addr;
            uint toSend = feeTaker.points * feePerPoint;
            token.transfer(feeTakerAddr, toSend);
            emit FeeSentERC20(feeTakerAddr, toSend);
        }
    }
}