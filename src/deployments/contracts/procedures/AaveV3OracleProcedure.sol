// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

import '../../interfaces/IMarketReportTypes.sol';
import {Oracle} from '../../../contracts/misc/Oracle.sol';

contract AaveV3OracleProcedure {
  function _deployOracle(
    uint16 oracleDecimals,
    address poolAddressesProvider
  ) internal returns (address) {
    address[] memory emptyArray;

    address oracle = address(
      new Oracle(
        IPoolAddressesProvider(poolAddressesProvider),
        emptyArray,
        emptyArray,
        address(0),
        address(0),
        10 ** oracleDecimals
      )
    );

    return oracle;
  }
}
