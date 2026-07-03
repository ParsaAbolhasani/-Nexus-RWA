// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract PriceOracle is AccessControl {
    bytes32 public constant UPDATER_ROLE = keccak256("UPDATER_ROLE");

    mapping(address => AggregatorV3Interface) public priceFeeds;
    mapping(address => uint256) public lastPrice;
    mapping(address => uint256) public lastUpdateTime;

    uint256 public constant PRICE_DECIMALS = 1e18;
    uint256 public constant STALENESS_THRESHOLD = 1 days;

    event PriceUpdated(address indexed asset, uint256 price, uint256 timestamp);
    event PriceFeedSet(address indexed asset, address indexed feed);

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(UPDATER_ROLE, msg.sender);
    }

    function setPriceFeed(address asset, address feed)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        require(feed != address(0), "Oracle: invalid feed address");
        priceFeeds[asset] = AggregatorV3Interface(feed);
        emit PriceFeedSet(asset, feed);
    }

    function getPrice(address asset) public view returns (uint256) {
        AggregatorV3Interface feed = priceFeeds[asset];
        require(address(feed) != address(0), "Oracle: price feed not set");

        (, int256 price, , uint256 updatedAt, ) = feed.latestRoundData();
        require(price > 0, "Oracle: invalid price");
        require(block.timestamp - updatedAt < STALENESS_THRESHOLD, "Oracle: stale price");

        return uint256(price) * PRICE_DECIMALS / 1e8;
    }

    function updatePrice(address asset) external onlyRole(UPDATER_ROLE) {
        uint256 price = getPrice(asset);
        lastPrice[asset] = price;
        lastUpdateTime[asset] = block.timestamp;
        emit PriceUpdated(asset, price, block.timestamp);
    }
}
