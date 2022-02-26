//SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
pragma solidity ^0.8.0;

interface IWithdraw {
    function WITHDRAW_ERC20_ROLE() external view returns(bytes32);
    function withdrawERC20(IERC20 token, address to, uint value) external;
}