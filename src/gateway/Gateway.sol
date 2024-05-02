// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract TokenLock is AccessControl {
    bytes32 public constant LOCKER_ROLE = keccak256("LOCKER_ROLE");
    mapping(address => mapping(address => uint256)) public lockedTokens;
    mapping(address => address) public tokenOwners;

    event TokensLocked(address indexed token, address indexed user, address indexed newOwner, uint256 amount);
    event TokensUnlocked(address indexed token, address indexed to, uint256 amount);

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(LOCKER_ROLE, msg.sender);
    }

    // Function to lock tokens with signature verification
    function lockTokens(
        address token,
        address user,
        address newOwner,
        uint256 amount,
        uint256 nonce,
        bytes memory signature
    ) external {
        require(hasRole(LOCKER_ROLE, msg.sender), "Caller does not have permission to lock tokens");
        bytes32 messageHash = getMessageHash(token, user, newOwner, amount, nonce);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        // Verify user's signature
        require(ECDSA.recover(ethSignedMessageHash, signature) == user, "Invalid signature");

        require(IERC20(token).transferFrom(user, address(this), amount), "Failed to transfer tokens");
        lockedTokens[token][newOwner] += amount;
        tokenOwners[token] = newOwner;
        emit TokensLocked(token, user, newOwner, amount);
    }

    function getEthSignedMessageHash(bytes32 messageHash) public pure returns (bytes32) {
        // This mimics the behavior of `toEthSignedMessageHash`
        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        return keccak256(abi.encodePacked(prefix, messageHash));
    }


    // Helper function to create a hash of the message
    function getMessageHash(
        address token,
        address user,
        address newOwner,
        uint256 amount,
        uint256 nonce
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(token, user, newOwner, amount, nonce));
    }

    function unlockTokens(address token, uint256 amount, address to) external {
        address owner = tokenOwners[token];
        require(msg.sender == owner, "Caller is not the owner of the locked tokens");
        require(lockedTokens[token][owner] >= amount, "Insufficient tokens locked");

        lockedTokens[token][owner] -= amount;
        require(IERC20(token).transfer(to, amount), "Failed to transfer tokens");
        emit TokensUnlocked(token, to, amount);
    }

    function grantLockerRole(address account) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Caller is not an admin");
        grantRole(LOCKER_ROLE, account);
    }
}
