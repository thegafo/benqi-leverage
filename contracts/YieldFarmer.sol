//SPDX-License-Identifier: MIT
pragma solidity >=0.8.2;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

import './IComptroller.sol';
import './IQiToken.sol';

contract YieldFarmer is Ownable {
  IComptroller comptroller;
  IQiToken qiToken;
  IERC20 underlying;
  uint collateralFactor;

  constructor(
    address _comptroller,
    address _qiToken,
    address _underlying,
    uint256 _collateralFactor
  ) {
    comptroller = IComptroller(_comptroller);
    qiToken = IQiToken(_qiToken);
    underlying = IERC20(_underlying);
    address[] memory qiTokens = new address[](1);
    qiTokens[0] = _qiToken; 
    comptroller.enterMarkets(qiTokens);
    collateralFactor = _collateralFactor;
  }

  fallback () payable external {}

  function openPosition(uint initialAmount, uint256 leverage) external onlyOwner {
    uint nextCollateralAmount = initialAmount;
    for(uint i = 0; i < leverage; i++) {
      nextCollateralAmount = this._supplyAndBorrow(nextCollateralAmount);
    }
  }

  function _supplyAndBorrow(uint collateralAmount) external returns(uint) {
    underlying.approve(address(qiToken), collateralAmount);
    qiToken.mint(collateralAmount);
    uint borrowAmount = (collateralAmount * collateralFactor) / 100;
    qiToken.borrow(borrowAmount);
    return borrowAmount;
  }

  function closePosition() external onlyOwner {
    uint balanceBorrow = qiToken.borrowBalanceCurrent(address(this));
    underlying.approve(address(qiToken), balanceBorrow);
    qiToken.repayBorrow(balanceBorrow);
    uint balanceQiToken = qiToken.balanceOf(address(this));
    qiToken.redeem(balanceQiToken);
  }

  function borrowBalance() external returns (uint256) {
    return qiToken.borrowBalanceCurrent(address(this));
  }  
  
  function borrowBalanceStored() external view returns (uint256) {
    return qiToken.borrowBalanceStored(address(this));
  }

  function underlyingBalance() external view returns (uint256) {
    return underlying.balanceOf(address(this));
  }  

  function balanceOf() external view returns (uint256) {
    return qiToken.balanceOf(address(this));
  }

  function balanceOfUnderlying() external view returns (uint256) {
    return qiToken.balanceOfUnderlying(address(this));
  }

  function getAccountLiquidity() public view returns (uint, uint, uint) {
    return comptroller.getAccountLiquidity(address(this));
  }


  function rates() external view returns (uint256, uint256) {
    return (
      qiToken.supplyRatePerTimestamp(),      
      qiToken.borrowRatePerTimestamp()
    );
  }

  function getUnderlying(address _address) external view returns (address) {
    IQiToken _qiToken = IQiToken(_address);
    return _qiToken.underlying();
  }

  function rates(address _address) external view returns (uint256, uint256) {
    IQiToken _qiToken = IQiToken(_address);
    return (
      _qiToken.supplyRatePerTimestamp(),      
      _qiToken.borrowRatePerTimestamp()
    );
  }

  function withdraw(uint256 amount) external onlyOwner {
    underlying.transfer(msg.sender, amount);
  }

  function drain() external onlyOwner {
    underlying.transfer(msg.sender, this.underlyingBalance());
  }

}
