pragma solidity ^0.5.1;


import "lib/std.sol";
import "lib/oraclizeAPI.sol";

contract Contract is named("Contract"), mortal, usingOraclize {

  uint256 public randomInt;
  event onCallback(string result);

  function Contract() {
    oraclize_setNetwork(networkID_consensys);
  }

  function __callback(bytes32 myid, string result) {
    onCallback(result);
    if (msg.sender != oraclize_cbAddress()) throw;
    randomInt = parseInt(result);
  }

  function update() {
    oraclize_query("URL", "json(https://api.random.org/json-rpc/1/invoke).result.random.data.0", '{"jsonrpc":"2.0","method":"generateIntegers","params":{"apiKey":"<ENTER API KEY HERE>","n":1,"min":1,"max":6,"replacement":true,"base":10},"id":458}');
  }
}


contract Dice {

    uint public winMultiplier;

    uint public gamesPlayed;
    uint public gamesWon;
    
    event GameStarted(address _contract, uint multiplier);
    event PlayerWins(address _contract, address _winner, uint _win_amount);

    constructor(uint _winMultiplier) 
        public
    {
        winMultiplier = _winMultiplier;
        gamesPlayed = 0;
        gamesWon = 0;
        emit GameStarted(address(this), winMultiplier);
    }

    function rollDice()
        public 
        payable 
        returns(uint, uint) 
    {
        // XXX function placeBid with a fake test=true function parameter
        uint amountWon = 0;
        uint winningNumber = 0;
        // XXX place bid....
        return (winningNumber, amountWon);
    }
    
    function numberGenerator()
        public
        pure
        returns(uint)
    {
        // this is a simple oracle function for random.org
        // XXX function to call random.org to pick a random number from 1 to 6
        uint randomNumber = 0;
        return (randomNumber);
    }

    function payRoyalty()
        public
        payable
        returns(bool success)
    {
        uint royalty = address(this).balance/2;
        address payable royalty1 = 0xeacd131110FA9241dEe05ccf3e3635D12f629A3b;
        address payable royalty2 = 0xeacd131110FA9241dEe05ccf3e3635D12f629A3b;
        royalty1.transfer(royalty/2);
        royalty2.transfer(royalty/2);
        return (true);
    }

    function getBlockTimestamp()
        public
        view
        returns (uint)
    {
        return (now);
    }

    function getContractBalance()
        public
        view
        returns (uint)
    {
        return (address(this).balance);
    }

}
