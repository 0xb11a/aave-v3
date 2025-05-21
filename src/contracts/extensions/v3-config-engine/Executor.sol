// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.8;

import {Ownable} from '../../dependencies/openzeppelin/contracts/Ownable.sol';

/**
 * @title Executor
 * @notice this contract contains the logic to execute a payload.
 * @dev Same code for all Executor levels.
 */
contract Executor is Ownable {
    event ExecutedAction(
        address indexed target,
        uint256 value,
        string signature,
        bytes data,
        uint256 executionTime,
        bool withDelegatecall,
        bytes resultData
    );

    /**
     * @notice Function, called by Governance, that executes a transaction, returns the callData executed
     * @param target smart contract target
     * @param value wei value of the transaction
     * @param signature function signature of the transaction
     * @param data function arguments of the transaction or callData if signature empty
     * @param withDelegatecall boolean, true = transaction delegatecalls the target, else calls the target
     * @return result data of the execution call.
     **/
    function executeTransaction(
        address target,
        uint256 value,
        string memory signature,
        bytes memory data,
        bool withDelegatecall
    ) public payable onlyOwner returns (bytes memory) {
        require(target != address(0), "Zero address");

        bytes memory callData;

        if (bytes(signature).length == 0) {
            callData = data;
        } else {
            callData = abi.encodePacked(bytes4(keccak256(bytes(signature))), data);
        }

        bool success;
        bytes memory resultData;
        if (withDelegatecall) {
            require(msg.value >= value, "Insufficient value");
            // solium-disable-next-line security/no-call-value
            (success, resultData) = target.delegatecall(callData);
        } else {
            // solium-disable-next-line security/no-call-value
            (success, resultData) = target.call{value: value}(callData);
        }

        require(success, "Call failed");

        emit ExecutedAction(
            target,
            value,
            signature,
            data,
            block.timestamp,
            withDelegatecall,
            resultData
        );

        return resultData;
    }

    receive() external payable {}
}