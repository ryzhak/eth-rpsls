pragma solidity ^0.4.23;

contract Hasher {

    /**
     * @dev Returns the commitment. Must only be called locally
     * @param _c The move
     * @param _salt The salt to increase entropy
     */
    function hash(uint8 _c, uint256 _salt) public pure returns(bytes32) {
        return keccak256(_c, _salt);
    }
}