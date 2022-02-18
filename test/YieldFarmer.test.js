const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("YieldFarmer", function () {
  let YieldFarmer, yieldFarmer, owner, addr1, addr2, addr3;

  beforeEach(async function () {
    [owner, addr1, addr2, addr3] = await ethers.getSigners();

    YieldFarmer = await ethers.getContractFactory("YieldFarmer");
    yieldFarmer = await YieldFarmer.deploy(
      addr1, addr2, addr3, 70
    );

    await token.deployed();
  });

  describe("Deployment", function () {
    it("Should initialize with correct collateralFactor", async function () {
      const collateralFactor = await yieldFarmer.collateralFactor();
      expect(collateralFactor).to.equal(70);
    });
  });
});