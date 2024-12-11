// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract TestFacet2 {
    // Define a unique storage position
    bytes32 constant DIAMOND_STORAGE_POSITION =
        keccak256("diamond.standard.test.storage.2");

    // Struct for storage
    struct TestState {
        string myString;
        uint256 counter;
    }

    // Internal function to access storage
    function diamondStorage() internal pure returns (TestState storage ds) {
        bytes32 position = DIAMOND_STORAGE_POSITION;
        assembly {
            ds.slot := position
        }
    }

    // Function to set a string in storage
    function setMyString(string calldata _myString) external {
        TestState storage testState = diamondStorage();
        testState.myString = _myString;
    }

    // Function to get the string from storage
    function getMyString() external view returns (string memory) {
        TestState storage testState = diamondStorage();
        return testState.myString;
    }

    // Function to increment the counter
    function incrementCounter() external {
        TestState storage testState = diamondStorage();
        testState.counter += 1;
    }

    // Function to get the current counter value
    function getCounter() external view returns (uint256) {
        TestState storage testState = diamondStorage();
        return testState.counter;
    }
}
