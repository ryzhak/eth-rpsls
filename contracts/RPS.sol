pragma solidity ^0.4.23;

contract RPS {

    // the 1st player creating the contract
    address public j1;

    // the 2nd player
    address public j2;

    // possible moves
    enum Move { Null, Rock, Paper, Scissors, Spock, Lizard }

    // commitment of j1
    bytes32 public c1Hash;

    // move of j2. Move.Null before he played
    Move public c2;

    // amount bet by each party
    uint256 public stake;

    // if some party takes more than TIMEOUT to respond, the other can call TIMEOUT to win
    uint256 public TIMEOUT = 5 minutes;

    // the time of the last action. Useful to determine is someone has timed out
    uint256 public lastAction;

    /**
     * @dev Must send the amount at stake.
     * @param _c1Hash Must be equal to keccak256(c1,salt) where c1 is the move of the j1
     */
    constructor(bytes32 _c1Hash, address _j2) public payable {
        stake = msg.value;
        j1 = msg.sender;
        j2 = _j2;
        c1Hash = _c1Hash;
        lastAction = now;
    }

    /**
     * @dev Should be called by j2(player 2) and provided stake
     * @param _c2 The move submitted by j2 
     */
    function play(Move _c2) public payable {
        require(c2 == Move.Null); // j2 has not played yet
        require(msg.value == stake); // j2 has played the stake
        require(msg.sender == j2); // only j2 can call this function

        c2 = _c2;
        lastAction = now;
    }

    /**
     * @dev Called by j1(player1). Reveal the move and the ETH to the winning party or split them.
     * @param _c1 The move played by j1.
     * @param _salt The salt used when submitting the commitment when the constructor was called.
     */
    function solve(Move _c1, uint256 _salt) public {
        require(c2 != Move.Null); // j2 must have played
        require(msg.sender == j1); // j1 can call this
        require(keccak256(_c1, _salt) == c1Hash); // verify the value is the commited one

        // if j1 or j2 throws at fallback it won't get funds and that is his fault
        // despite what the warnings say we should not use transfer as a throwing fallback would be able to block the contract, in case of a tie
        if(win(_c1, c2)) {
            j1.send(2 * stake);
        } else if (win(c2, _c1)) {
            j2.send(2 * stake);
        } else {
            j1.send(stake);
            j2.send(stake);
        }

        stake = 0;
    }

    /**
     * @dev Let j2(player 2) get the funds back if j1(player 1) did not play
     */
    function j1Timeout() public {
        require(c2 != Move.Null); // j2 already played
        require(now > lastAction + TIMEOUT); // timeout has passed
        j2.send(2 * stake);
        stake = 0;
    }

    /**
     * @dev Let j1 take back the funds if j2 never play
     */
    function j2Timeout() public {
        require(c2 == Move.Null); // j2 has never played
        require(now > lastAction + TIMEOUT); // timeout has passed
        j1.send(stake);
        stake = 0;
    }

    /**
     * @dev Is this move winning over the other
     * @param _c1 The 1st move
     * @param _c2 The 2nd move
     * @return w True if c1 beats c2. False if c1 is beaten by c2 or in case of a tie
     */
    function win(Move _c1, Move _c2) private pure returns (bool w) {
        if(_c1 == _c2) { // tie
            return false;
        } else if (_c1 == Move.Null) { // they did not play
            return false;
        } else if(uint(_c1) % 2 == uint(_c2) % 2) {
            return _c1 < _c2;
        } else {
            return _c1 > _c2;
        }
    }

}