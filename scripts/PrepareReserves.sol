// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Script.sol";
import "../src/contracts/extensions/v3-config-engine/Executor.sol";
import {IAaveV3ConfigEngine} from "../src/contracts/extensions/v3-config-engine/IAaveV3ConfigEngine.sol";

contract PrepareReserves is Script {
    function getEncodedArgs() public pure returns (bytes memory) {
        IAaveV3ConfigEngine.PoolContext memory context = IAaveV3ConfigEngine.PoolContext({
            networkName: "Mantle",
            networkAbbreviation: "Mntl"
        });

        IAaveV3ConfigEngine.Listing[] memory listings = new IAaveV3ConfigEngine.Listing[](2); // change array size based on number of assets

        // USDC
        IAaveV3ConfigEngine.Listing memory usdc = IAaveV3ConfigEngine.Listing({
            asset: 0x09Bc4E0D864854c6aFB6eB9A9cdF58aC190D0dF9,
            assetSymbol: "USDC",
            priceFeed: 0x22b422CECb0D4Bd5afF3EA999b048FA17F5263bD,
            rateStrategyParams: IAaveV3ConfigEngine.InterestRateInputData({
                optimalUsageRatio: 9200,
                baseVariableBorrowRate: 75,
                variableRateSlope1: 625,
                variableRateSlope2: 7500
            }),
            enabledToBorrow: 1,
            borrowableInIsolation: 1,
            withSiloedBorrowing: 0,
            flashloanable: 1,
            ltv: 9000,
            liqThreshold: 9200,
            liqBonus: 750,
            reserveFactor: 1000,
            supplyCap: 1000000,
            borrowCap: 900000,
            debtCeiling: 0,
            liqProtocolFee: 1000
        });

        listings[0] = usdc;

        // WETH
        IAaveV3ConfigEngine.Listing memory weth = IAaveV3ConfigEngine.Listing({
            asset: 0xdEAddEaDdeadDEadDEADDEAddEADDEAddead1111,
            assetSymbol: "WETH",
            priceFeed: 0x5bc7Cf88EB131DB18b5d7930e793095140799aD5,
            rateStrategyParams: IAaveV3ConfigEngine.InterestRateInputData({
                optimalUsageRatio: 9200,
                baseVariableBorrowRate: 75,
                variableRateSlope1: 625,
                variableRateSlope2: 7500
            }),
            enabledToBorrow: 0,
            borrowableInIsolation: 0,
            withSiloedBorrowing: 0,
            flashloanable: 0,
            ltv: 8500,
            liqThreshold: 8700,
            liqBonus: 750,
            reserveFactor: 1000,
            supplyCap: 2000000,
            borrowCap: 1900000,
            debtCeiling: 0,
            liqProtocolFee: 1500
        });

        listings[1] = weth;

        return abi.encode(context, listings);
    }
}