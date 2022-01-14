//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

abstract contract FeeTakersERC20 is Ownable{
    struct FeeTaker {
        address addr;
        uint points;
    }
    FeeTaker[] _feeTakers;

    event FeeSent(address to, uint amount);    

    //manage where profit is sent to
    function getFeeTakersERC20Length() public view onlyOwner returns(uint) {
        return _feeTakers.length;
    }
    function getFeeTakerERC20At(uint index) public view onlyOwner returns(FeeTaker memory) {
        return _feeTakers[index];
    }
    function addToFeeTakersERC20(address addr, uint points) public onlyOwner {
        _feeTakers.push(FeeTaker(addr, points));
    }
    function removeFromFeeTakersERC20(uint index) public onlyOwner {
        _feeTakers[index] = _feeTakers[_feeTakers.length - 1];
        _feeTakers.pop();
    }

    function _distributeFeeERC20(IERC20 token, uint fee) internal {
        uint feePoints;
        uint feePerPoint;
        for(uint i; i < _feeTakers.length; i ++) {
            feePoints += _feeTakers[i].points;
        }
        if(feePoints > 0) {
            feePerPoint = fee / feePoints;
        }
        for(uint i; i < getFeeTakersERC20Length(); i ++) {
            FeeTaker storage feeTaker = _feeTakers[i];
            address feeTakerAddr = feeTaker.addr;
            uint toSend = feeTaker.points * feePerPoint;
            token.transfer(feeTakerAddr, toSend);
            emit FeeSent(feeTakerAddr, toSend);
        }
    }
}