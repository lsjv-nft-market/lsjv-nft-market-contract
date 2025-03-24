// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

type OrderKey is bytes32;

type Price is bytes32;

library LibOrder {
    enum Side {
        List, //挂单
        Bid //买单

    }

    struct Asset {
        uint256 tokenId;
        address collection;
        uint96 amount;
    }

    struct Order {
        Side side;
        address maker; //下单的人
        Asset nft;
        Price price;
    }

    function hash(Asset memory asset) internal pure returns (bytes32) {
        return keccak256(abi.encode(asset.tokenId, asset.collection, asset.amount));
    }

    function hash(Order memory order) internal pure returns (OrderKey) {
        return OrderKey.wrap(
            keccak256(abi.encodePacked(order.side, order.maker, hash(order.nft), Price.unwrap(order.price)))
        );
    }
}
