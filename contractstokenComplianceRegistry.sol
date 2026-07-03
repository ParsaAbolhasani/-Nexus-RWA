// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract ComplianceRegistry is AccessControl {
    bytes32 public constant VERIFIER_ROLE = keccak256("VERIFIER_ROLE");

    mapping(address => bool) public isVerified;
    mapping(address => bytes32) public identityHashes;

    event IdentityRegistered(address indexed account, bytes32 identityHash);
    event IdentityRevoked(address indexed account);

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(VERIFIER_ROLE, msg.sender);
    }

    function registerIdentity(address account, bytes32 identityHash)
        external
        onlyRole(VERIFIER_ROLE)
    {
        require(account != address(0), "Registry: invalid address");
        isVerified[account] = true;
        identityHashes[account] = identityHash;
        emit IdentityRegistered(account, identityHash);
    }

    function revokeIdentity(address account)
        external
        onlyRole(VERIFIER_ROLE)
    {
        isVerified[account] = false;
        delete identityHashes[account];
        emit IdentityRevoked(account);
    }

    function isVerified(address account) external view returns (bool) {
        return isVerified[account];
    }
}
