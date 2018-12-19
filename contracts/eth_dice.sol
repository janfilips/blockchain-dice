pragma solidity ^0.5.1;

contract Dice {

    uint public winMultiplier;

    uint public gamesPlayed;
    uint public gamesWon;
    
    event gameStarted(address _contract, uint multiplier)
    event playerWins(address _contract, address _winner, uint _win_amount);

    constructor(uint _winMultiplier) 
        public
    {
        winMultiplier = _winMultiplier
        gamesPlayed = 0;
        gamesWon = 0;
        emit gameStarted(address(this), winMultiplier);
    }

    // function _bid
    // function _bid with a fake test=true function
    // function _payRoyalty

}
