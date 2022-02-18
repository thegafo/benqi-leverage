import { 
  Contract, 
  ContractFactory,
  utils
} from "ethers"
import { ethers, run } from "hardhat"

const main = async(): Promise<any> => {
  const TestToken: ContractFactory = await ethers.getContractFactory("TestToken")
  const token: Contract = await TestToken.deploy('GG', 'GGG', utils.parseUnits('1000', 18));

  await token.deployed()
  console.log(`Token deployed to: ${token.address}`);

  try {
    console.log(await run('verify:verify', {
      address: token.address,
      constructorArguments: [
        'GG', 'GGG', utils.parseUnits('1000', 18)
      ]
    }));
  } catch (err) {
    console.log('Verification failed');
    console.log(`npx hardhat verify --contract contracts/TestToken.sol:TestToken ${token.address} GG GGG ${utils.parseUnits('1000', 18).toString()}`);
  }
}

main()
.then(() => process.exit(0))
.catch(error => {
  console.error(error)
  process.exit(1)
})
