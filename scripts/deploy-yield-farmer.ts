import { 
  Contract, 
  ContractFactory,
  utils
} from "ethers"
import { ethers, run } from "hardhat"
import constants from '../constants';
const main = async(): Promise<any> => {

  const comptrollerAddress = constants.testnet.Comptroller;
  const tokenAddress = constants.testnet.QiAVAX;
  const underlyingAddress = constants.testnet.AVAX;
  const collateralFactor = 50;

  const YieldFarmer: ContractFactory = await ethers.getContractFactory("YieldFarmer")
  const farmer: Contract = await YieldFarmer.deploy(
    comptrollerAddress,
    tokenAddress,
    underlyingAddress,
    collateralFactor
  );

  await farmer.deployed()
  console.log(`Farmer deployed to: ${farmer.address}`);

  try {
    console.log(await run('verify:verify', {
      address: farmer.address,
      constructorArguments: [
        comptrollerAddress,
        tokenAddress,
        underlyingAddress,
        collateralFactor
      ]
    }));
  } catch (err) {
    console.log('Verification failed');
    console.log(`npx hardhat verify --contract contracts/YieldFarmer.sol:YieldFarmer ${farmer.address} ${comptrollerAddress} ${tokenAddress} ${underlyingAddress} ${collateralFactor}`);
  }
}

main()
.then(() => process.exit(0))
.catch(error => {
  console.error(error)
  process.exit(1)
})
