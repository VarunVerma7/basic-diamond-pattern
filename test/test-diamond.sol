// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Diamond.sol";
import "../src/DiamondCutFacet.sol";
import "../src/LibDiamond.sol";
import "../src/TestFacet1.sol";
import {IDiamondCut} from "../src/DiamondInterfaces.sol";

contract DiamondTest is Test {
    Diamond diamond;
    DiamondCutFacet diamondCutFacet;
    TestFacet1 testFacet;

    function setUp() public {
        // Deploy facets
        diamondCutFacet = new DiamondCutFacet();
        testFacet = new TestFacet1();

        // Create cuts array
        IDiamond.FacetCut[] memory cuts = new IDiamond.FacetCut[](2);

        // DiamondCutFacet cut
        bytes4[] memory diamondCutSelectors = new bytes4[](1);
        diamondCutSelectors[0] = DiamondCutFacet.diamondCut.selector;

        cuts[0] = IDiamond.FacetCut({
            facetAddress: address(diamondCutFacet),
            action: IDiamond.FacetCutAction.Add, // Using 0 for Add
            functionSelectors: diamondCutSelectors
        });

        // TestFacet cut
        bytes4[] memory testSelectors = new bytes4[](4);
        testSelectors[0] = testFacet.setMyAddress.selector;
        testSelectors[1] = testFacet.getMyAddress.selector;
        testSelectors[2] = testFacet.setMyNum.selector;
        testSelectors[3] = testFacet.getMyNum.selector;

        cuts[1] = IDiamond.FacetCut({
            facetAddress: address(testFacet),
            action: IDiamond.FacetCutAction(0), // Using 0 for Add
            functionSelectors: testSelectors
        });

        // Deploy diamond
        DiamondArgs memory args = DiamondArgs({
            owner: address(this),
            init: address(0),
            initCalldata: new bytes(0)
        });

        diamond = new Diamond(cuts, args);
    }
    function test_SetAndGetMyAddress() public {
        // Call setMyAddress via the diamond
        (bool success, ) = address(diamond).call(
            abi.encodeWithSelector(
                TestFacet1.setMyAddress.selector,
                address(this)
            )
        );
        require(success, "setMyAddress failed");

        // Call getMyAddress via the diamond
        (bool success2, bytes memory data) = address(diamond).call(
            abi.encodeWithSelector(TestFacet1.getMyAddress.selector)
        );
        require(success2, "getMyAddress failed");

        // Decode the result
        address myAddress = abi.decode(data, (address));
        assertEq(myAddress, address(this));
    }

    function test_SetAndGetMyNum() public {
        // Call setMyNum via the diamond
        (bool success, ) = address(diamond).call(
            abi.encodeWithSelector(TestFacet1.setMyNum.selector, 42)
        );
        require(success, "setMyNum failed");

        // Call getMyNum via the diamond
        (bool success2, bytes memory data) = address(diamond).call(
            abi.encodeWithSelector(TestFacet1.getMyNum.selector)
        );
        require(success2, "getMyNum failed");

        // Decode the result
        uint256 myNum = abi.decode(data, (uint256));
        assertEq(myNum, 42);
    }
}
