// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {OrderKey, LibOrder, Price} from "./libraries/LibOrder.sol";
import {IEasySwapVault} from "./interface/IEasySwapVault.sol";
import {IEasySwapOrderBook} from "./interface/IEasySwapOrderBook.sol";
import {EasySwapStorage} from "./EasySwapStorage.sol";
import {LibTransferSafeUpgradeable, IERC721} from "./libraries/LibTransferSafeUpgradeable.sol";

/**
 * @title 这边是业务相关的操作
 * @author
 * @notice
 */
contract EasySwapOrderBook is IEasySwapOrderBook, EasySwapStorage {
    address private _vault;

    event MakeOrderAuction(address indexed collection, uint256 id, bytes32 indexed hash, address seller);

    event BuyItNowAuction(
        address indexed collection, uint256 id, bytes32 indexed hash, address bidder, uint256 bidPrice
    );

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

    //下面是rcc以外的功能

    function makeOrderDutch(LibOrder.OrderDutch calldata newOrder)
        public
        payable
        override
        returns (OrderKey newOrderKey)
    {
        newOrderKey = LibOrder.hash(newOrder);
        _addOrder(newOrder);
        emit MakeOrderAuction(newOrder.nft.collection, newOrder.nft.tokenId, OrderKey.unwrap(newOrderKey), msg.sender);
    }

    function buyItNowDutch(OrderKey _orderKey) external payable override {
        LibOrder.OrderDutch storage or = hashToOrderDutch[_orderKey];
        uint256 currentPrice = getCurrentPrice(_orderKey);
        if (msg.value >= currentPrice) {
            payable(msg.sender).send(currentPrice);
            //还钱TODO，用户多付的钱要还回去
        }
        IERC721(or.nft.collection).safeTransferFrom(address(this), msg.sender, or.nft.tokenId);
        emit BuyItNowAuction(or.nft.collection, or.nft.tokenId, OrderKey.unwrap(_orderKey), msg.sender, currentPrice);
    }

    function getCurrentPrice(OrderKey _orderKey) public view returns (uint256) {
        LibOrder.OrderDutch storage o = hashToOrderDutch[_orderKey];

        uint256 _startPrice = uint256(Price.unwrap(o.startPrice));
        uint256 _endPrice = uint256(Price.unwrap(o.endPrice));
        uint256 _startBlock = o.startBlock;
        uint256 tickPerBlock = (_startPrice - _endPrice) / (o.endBlock - _startBlock);
        return _startPrice - ((block.number - _startBlock) * tickPerBlock);
    }
    // function englishAuction(address _token, uint256 _id, uint256 _startPrice, uint256 _endBlock) public {
    //     // _makeOrderAuction(2, _token, _id, _startPrice, 0, _endBlock);
    // } //ep=0. for gas saving.

    // function fixedPrice(address _token, uint256 _id, uint256 _price, uint256 _endBlock) public {
    //     // _makeOrderAuction(0, _token, _id, _price, 0, _endBlock);
    // } //ep=0. for gas saving.

    // function buyItNowAuction(OrderKey newOrderKey) external payable override {}

    // function bidAuction(OrderKey newOrderKey) external payable override {}
}
