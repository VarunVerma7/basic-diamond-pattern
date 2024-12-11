// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TestFacet1 {
    // Define a unique storage position
    bytes32 constant DIAMOND_STORAGE_POSITION =
        keccak256("diamond.standard.test.storage");

    // Struct for storage
    struct TestState {
        address myAddress;
        uint256 myNum;
    }

    // Internal function to access storage
    function diamondStorage() internal pure returns (TestState storage ds) {
        bytes32 position = DIAMOND_STORAGE_POSITION;
        assembly {
            ds.slot := position
        }
    }

    // Function to set the address in storage
    function setMyAddress(address _myAddress) external {
        TestState storage testState = diamondStorage();
        testState.myAddress = _myAddress;
    }

    // Function to get the address from storage
    function getMyAddress() external view returns (address) {
        TestState storage testState = diamondStorage();
        return testState.myAddress;
    }

    // Function to set a number in storage
    function setMyNum(uint256 _myNum) external {
        TestState storage testState = diamondStorage();
        testState.myNum = _myNum;
    }

    // Function to get the number from storage
    function getMyNum() external view returns (uint256) {
        TestState storage testState = diamondStorage();
        return testState.myNum;
    }
}
