// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {OrderKey, LibOrder} from "../libraries/LibOrder.sol";

/**
 * @title 这边是业务相关的操作
 * @author
 * @notice
 */
interface IEasySwapOrderBook {
    /**
     * @param newOrders 新的订单
     */
    function makeOrders(LibOrder.Order[] calldata newOrders)
        external
        payable
        returns (OrderKey[] memory newOrderKeys);

    function matchOrder(LibOrder.Order calldata sellOrder, LibOrder.Order calldata buyOrder) external payable;
}
