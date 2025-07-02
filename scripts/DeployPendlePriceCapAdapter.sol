// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Script.sol";
import {IPendlePriceCapAdapter, PendlePriceCapAdapter} from "src/contracts/misc/price-adapters/PendlePriceCapAdapter.sol";

contract DeployPendlePriceCapAdapter is Script {
    function run() external {
        vm.startBroadcast();

        // IPendlePriceCapAdapter.PendlePriceCapAdapterParams memory params = IPendlePriceCapAdapter.PendlePriceCapAdapterParams(
        //     0x5bc7Cf88EB131DB18b5d7930e793095140799aD5,
        //     0x698eB002A4Ec013A33286f7F2ba0bE3970E66455,
        //     405000000000000000,
        //     40760000000000000,
        //     0x950837dC7Fcb1468b0BE0FD6A72461DFB9a9E1c5,
        //     "PT Capped cmETH (WETH) linear discount 18SEPT2025"
        // );

        // new PendlePriceCapAdapter(params);

        int256 answer = PendlePriceCapAdapter(0xF15B195a3Db20E1973Da01959C7878121cc5074f).latestAnswer();
        console.log("answer: ", answer);

        vm.stopBroadcast();
    }
}
