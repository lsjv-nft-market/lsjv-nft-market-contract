// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {OrderKey, LibOrder} from "./libraries/LibOrder.sol";

import {OrderKey, LibOrder, Price} from "./libraries/LibOrder.sol";
import {IEasySwapVault} from "./interface/IEasySwapVault.sol";
import {IEasySwapOrderBook} from "./interface/IEasySwapOrderBook.sol";
import {IEasySwapStorage} from "./interface/IEasySwapStorage.sol";
import {LibTransferSafeUpgradeable, IERC721} from "./libraries/LibTransferSafeUpgradeable.sol";

contract EasySwapStorage is IEasySwapStorage {
    mapping(OrderKey => LibOrder.OrderDutch) public hashToOrderDutch;

    function _addOrder(LibOrder.OrderDutch memory newOrder) internal returns (OrderKey orderKey) {
        // 获取订单的hash值
        orderKey = LibOrder.hash(newOrder);

        hashToOrderDutch[orderKey] = newOrder;
    }
}
