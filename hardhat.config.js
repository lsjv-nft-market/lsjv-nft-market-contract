require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-verify");

const { config: dotenvConfig } = require("dotenv")
const { resolve } = require("path")
dotenvConfig({ path: resolve(__dirname, "./.env") })


const SEPOLIA_ALCHEMY_AK = process.env.SEPOLIA_ALCHEMY_AK
const SEPOLIA_PK_ONE = process.env.SEPOLIA_PK_ONE
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.28",
  sourcify: {
    enabled: true
  },
  etherscan: {
    apiKey: {
      sepolia: `${ETHERSCAN_API_KEY}` // 确保与 .env 变量名一致
    },
  },
  networks: {
   
    sepolia: {
      url: `https://eth-sepolia.g.alchemy.com/v2/${SEPOLIA_ALCHEMY_AK}`,
      accounts: [`${SEPOLIA_PK_ONE}`],
      
      timeout: 120000 
    },
    // optimism: {
    //   url: `https://rpc.ankr.com/optimism`,
    //   accounts: [`${MAINNET_PK}`],
    // },
  },
}
