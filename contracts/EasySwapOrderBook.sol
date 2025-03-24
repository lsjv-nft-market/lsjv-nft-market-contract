// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {OrderKey, LibOrder, Price} from "./libraries/LibOrder.sol";
import {IEasySwapVault} from "./interface/IEasySwapVault.sol";
import {IEasySwapOrderBook} from "./interface/IEasySwapOrderBook.sol";

/**
 * @title 这边是业务相关的操作
 * @author
 * @notice
 */
contract EasySwapOrderBook is IEasySwapOrderBook {
    address private _vault;

    constructor(address vault) {
        _vault = vault;
    }
    /**
     * @param newOrders 新的订单
     */

    function makeOrders(LibOrder.Order[] calldata newOrders)
        external
        payable
        returns (OrderKey[] memory newOrderKeys)
    {
        for (uint256 i = 0; i < newOrders.length; i++) {
            OrderKey newOrderKey = _makeOrderTry(newOrders[i]);
            newOrderKeys[i] = newOrderKey;
        }
    }

    function matchOrder(LibOrder.Order calldata sellOrder, LibOrder.Order calldata buyOrder) external payable {}

    function _makeOrderTry(LibOrder.Order calldata order) internal returns (OrderKey newOrderKey) {
        //校验
        require(msg.sender == order.maker, "only maker can make Order"); //这边msg.sender需不需要使用openzeppelin的内置函数呢？
        require(Price.unwrap(order.price) > 0, "price must be positive,and not be 0");
        //业务逻辑
        newOrderKey = LibOrder.hash(order);
        if (LibOrder.Side.List == order.side) {
            IEasySwapVault(_vault).depositNft(newOrderKey, order.nft.collection, order.nft.tokenId, order.maker);
        } else if (LibOrder.Side.Bid == order.side) {
            //IEasySwapVault(_vault).depositEth();
        } else {
            revert("have no this side");
        }
    }
}
