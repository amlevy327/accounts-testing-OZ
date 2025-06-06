// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.27;

import {AbstractSigner} from "@openzeppelin/community-contracts/utils/cryptography/AbstractSigner.sol";
import {Account} from "@openzeppelin/community-contracts/account/Account.sol";
import {AccountERC7579} from "@openzeppelin/community-contracts/account/extensions/AccountERC7579.sol";
import {EIP712} from "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import {ERC1155Holder} from "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import {ERC721Holder} from "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import {ERC7739} from "@openzeppelin/community-contracts/utils/cryptography/ERC7739.sol";
import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {PackedUserOperation} from "@openzeppelin/contracts/interfaces/draft-IERC4337.sol";
import {SignerECDSA} from "@openzeppelin/community-contracts/utils/cryptography/SignerECDSA.sol";

contract MyAccount is Initializable, Account, EIP712, ERC7739, AccountERC7579, SignerECDSA, ERC721Holder, ERC1155Holder {
    constructor() EIP712("MyAccount", "1") {}

    function isValidSignature(bytes32 hash, bytes calldata signature)
        public
        view
        override(AccountERC7579, ERC7739)
        returns (bytes4)
    {
        // ERC-7739 can return the ERC-1271 magic value, 0xffffffff (invalid) or 0x77390001 (detection).
        // If the returned value is 0xffffffff, fallback to ERC-7579 validation.
        bytes4 erc7739magic = ERC7739.isValidSignature(hash, signature);
        return erc7739magic == bytes4(0xffffffff) ? AccountERC7579.isValidSignature(hash, signature) : erc7739magic;
    }

    function initializeECDSA(address signer) public initializer {
        _setSigner(signer);
    }

    // The following functions are overrides required by Solidity.

    function _validateUserOp(PackedUserOperation calldata userOp, bytes32 userOpHash)
        internal
        override(Account, AccountERC7579)
        returns (uint256)
    {
        return super._validateUserOp(userOp, userOpHash);
    }

    // IMPORTANT: Make sure SignerECDSA is most derived than AccountERC7579
    // in the inheritance chain (i.e. contract ... is AccountERC7579, ..., SignerECDSA)
    // to ensure the correct order of function resolution.
    // AccountERC7579 returns false for `_rawSignatureValidation`
    function _rawSignatureValidation(bytes32 hash, bytes calldata signature)
        internal
        view
        override(SignerECDSA, AbstractSigner, AccountERC7579)
        returns (bool)
    {
        return super._rawSignatureValidation(hash, signature);
    }
}
