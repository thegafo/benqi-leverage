//SPDX-License-Identifier: MIT
pragma solidity >=0.8.2;

interface IComptroller {
  function enterMarkets(address[] calldata cTokens) external returns (uint[] memory);
}
