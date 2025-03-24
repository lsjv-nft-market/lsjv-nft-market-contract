// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {OrderKey, LibOrder, Price} from "./libraries/LibOrder.sol";
import {IEasySwapVault} from "./interface/IEasySwapVault.sol";
/**
 * @title 这边放所有和资产相关的逻辑，存放谁的nft、代币放入了这个项目
 * @author
 * @notice
 */

contract EasySwapVault is IEasySwapVault {
    function depositNft(OrderKey newOrderKey, address collection, uint256 tokenId, address maker) external {}
}
