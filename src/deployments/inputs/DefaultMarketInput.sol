// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import './MarketInput.sol';

contract DefaultMarketInput is MarketInput {
  function _getMarketInput(
    address deployer
  )
    internal
    pure
    override
    returns (
      Roles memory roles,
      MarketConfig memory config,
      DeployFlags memory flags,
      MarketReport memory deployedContracts
    )
  {
    roles = Roles(
      deployer,
      deployer,
      deployer
    );

    config = MarketConfig(
      0x5bc7Cf88EB131DB18b5d7930e793095140799aD5,
      0xD97F20bEbeD74e8144134C4b148fE93417dd0F96,
      'Lendle Testnet Market',
      8,
      address(0), // ParaswapAugustusRegistry
      address(0), // l2SequencerUptimeFeed
      0, // l2PriceOracleSentinelGracePeriod
      8080,
      0x0,
      0x78c1b0C915c4FAA5FffA6CAbf0219DA63d7f4cb8, // WMNT
      0.0005e4,
      0.0004e4,
      address(0),
      address(0),
      address(0),
      0
    );

    return (roles, config, flags, deployedContracts);
  }
}
