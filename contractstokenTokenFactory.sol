// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./RWAToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenFactory is Ownable {
    address public identityRegistry;
    address[] public allTokens;

    event TokenCreated(address indexed token, string name, string symbol);

    constructor(address _identityRegistry) {
        identityRegistry = _identityRegistry;
    }

    function createToken(
        string memory _name,
        string memory _symbol,
        RWAToken.AssetInfo memory _assetInfo
    ) external onlyOwner returns (address) {
        RWAToken token = new RWAToken(
            _name,
            _symbol,
            identityRegistry,
            _assetInfo
        );
        allTokens.push(address(token));
        emit TokenCreated(address(token), _name, _symbol);
        return address(token);
    }

    function getAllTokens() external view returns (address[] memory) {
        return allTokens;
    }
}
