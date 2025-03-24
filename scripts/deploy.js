const { ethers } = require("hardhat")

async function main() {
    const EasySwapVault = await ethers.getContractFactory("Test");
    const easySwapVault = await EasySwapVault.deploy();
    await easySwapVault.waitForDeployment(); // 新版 Ethers 使用 waitForDeployment 替代 deployed()
    console.log("easySwapVaultContract deployed to:", await easySwapVault.getAddress())


    newESVault = easySwapVault.getAddress();
    const EasySwapOrderBook = await ethers.getContractFactory("EasySwapOrderBook");
    const easySwapOrderBook = await EasySwapOrderBook.deploy(newESVault);
    await easySwapOrderBook.waitForDeployment(); // 新版 Ethers 使用 waitForDeployment 替代 deployed()
    console.log("easySwapOrderBookContract deployed to:", await easySwapOrderBook.getAddress())
    //0x696ee40daA3bc8C5f38A5C3Cd1c4Ed98Ed1d560d



  }
  
  // We recommend this pattern to be able to use async/await everywhere
  // and properly handle errors.
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error)
      process.exit(1)
    })
  