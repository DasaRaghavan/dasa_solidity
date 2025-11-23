// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library ExampleInterface {
    // library cannot have any state variables or constructors
    // function getVersion() public view returns(uint) {
    //     return pricefeed.decimals();
    // } 

    function getConversionRate() internal view returns (uint) { // function needs to be internal in a library
        AggregatorV3Interface pricefeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306); // no state variables in a library - hence pricefeed declared here
        (,int price,,,) = pricefeed.latestRoundData();
        return uint(price)*1e10;
    }

    function getUSDValue(uint _amount) internal view returns(uint) {// function needs to be internal in a library
        uint ethPrice = getConversionRate();
        uint usdValue = (_amount * ethPrice) / 1e36;

        return usdValue;
    }


}