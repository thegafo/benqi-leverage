//SPDX-License-Identifier: MIT
pragma solidity >=0.8.2;

interface IQiToken {
  function underlying() external view returns (address);
  function mint(uint mintAmount) external returns (uint);
  function redeem(uint redeemTokens) external returns (uint);
  function borrow(uint borrowAmount) external returns (uint);
  function repayBorrow(uint repayAmount) external returns (uint);
  function borrowBalanceCurrent(address account) external returns (uint);
  function borrowBalanceStored(address account) external view returns (uint);
  function balanceOf(address owner) external view returns (uint);
  function balanceOfUnderlying(address owner) external view returns (uint);
  function borrowRatePerTimestamp() external view returns (uint);
  function supplyRatePerTimestamp() external view returns (uint);
  function exchangeRateCurrent() external returns (uint);
}
