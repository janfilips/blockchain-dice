pragma solidity ^0.5.0;

import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";


contract Dice is usingOraclize {

    uint betAmount;
    uint minimumBet;

    // The oraclize callback structure: we use several oraclize calls.
    // All oraclize calls will result in a common callback to __callback(...).
    // To keep track of the different querys we have to introduce this struct.

    struct oraclizeCallback {
        address player;
        bool    oraclizeStatus;
        bytes32 oraclizeQueryId;
        uint[]  betNumbers;
        uint    betAmount;
        uint    winningNumber;
    }
    
    // Lookup state from oraclizeQueryIds
    mapping (bytes32 => oraclizeCallback) public oraclizeStructs;
    bytes32[] public oraclizeIndices;

    event GameStarted(address _contract);
    event PlayerBetAccepted(address _contract, address _player, uint[] _numbers, uint _bet);
    event RollDice(address _contract, address _player, string _description);
    event NumberGeneratorQuery(address _contract, bytes32 _oraclizedQueryId);
    event NumberGeneratorCallback(address _contract, address _cbAddress, bytes32 _oraclizedQueryId);
    event WinningNumber(address _contract, uint[] _betNumbers, uint _winningNumber);
    event PlayerWins(address _contract, address _winner, uint _winningNumber, uint _winningAmount);
    event Cashout(address _contract, address _winner, uint _winningNumber, uint _winningAmount);

    uint public gamesPlayed;
    uint public lastWinningNumber;

    constructor() 
        public
    {
        gamesPlayed = 0;
        minimumBet = 0.01 ether;
        emit GameStarted(address(this));
    }


    function rollDice(uint[] memory betNumbers) 
        public 
        payable
        returns (bytes32)
    {
        
        bytes32 oraclizeQueryId;
        
        address player = msg.sender;
        
        betAmount = msg.value;
        

        require(betAmount >= minimumBet);


        emit PlayerBetAccepted(address(this), msg.sender, betNumbers, msg.value);


        if(betNumbers.length != 6) {

            // Making oraclized query to random.org
            
            emit RollDice(address(this), player, "Query to random.org was sent, standing by for the answer..");
            
            oraclizeQueryId = oraclize_query("URL", "https://www.random.org/integers/?num=1&min=1&max=6&col=1&base=16&format=plain&rnd=new");

            // Recording the bet info for future reference

            oraclizeStructs[oraclizeQueryId].oraclizeStatus = false;
            oraclizeStructs[oraclizeQueryId].oraclizeQueryId = oraclizeQueryId;
            oraclizeStructs[oraclizeQueryId].player = msg.sender;
            oraclizeStructs[oraclizeQueryId].betNumbers = betNumbers;
            oraclizeStructs[oraclizeQueryId].betAmount = msg.value;
            oraclizeIndices.push(oraclizeQueryId);

            emit NumberGeneratorQuery(address(this), oraclizeQueryId);

        } else {
            
            // Player bets on every number, we cannot run oraclize service, it's 1-1, player wins.

            msg.sender.transfer(msg.value);

            // The game was played, increase the counter.

            gamesPlayed += 1;

        }
        
        return oraclizeQueryId;

    }


    function __callback(bytes32 myid, string memory result) public {
        
        // All the action takes place on when we receive a new number from random.org

        bool playerWins;
        
        uint winningAmount;
    
        emit NumberGeneratorCallback(address(this), msg.sender, myid);
    
        address player = oraclize_cbAddress();
        require(msg.sender == player);
        
        uint winningNumber = parseInt(result);
        
        uint[] memory betNumbers = oraclizeStructs[myid].betNumbers;
        
        emit WinningNumber(address(this), betNumbers, winningNumber);

        oraclizeStructs[myid].winningNumber = winningNumber;


        for (uint i = 0; i < betNumbers.length; i++) {

            uint betNumber = betNumbers[i];

            if(betNumber == winningNumber) {
                playerWins = true;

            }

        }

        if(playerWins) {
            
            // Calculate how much player wins

            if(betNumbers.length == 1) {
                    winningAmount = (betAmount * 589) / 100;
            }
            if(betNumbers.length == 2) {
                    winningAmount = (betAmount * 293) / 100;
            }
            if(betNumbers.length == 3) {
                    winningAmount = (betAmount * 195) / 100;
            }
            if(betNumbers.length == 4) {
                    winningAmount = (betAmount * 142) / 100;
            }
            if(betNumbers.length == 5) {
                    winningAmount = (betAmount * 107) / 100;
            }
            if(betNumbers.length == 6) {
                    winningAmount = 0;
            }

            emit PlayerWins(address(this), msg.sender, winningNumber, winningAmount);

            if(winningAmount!=0) {

                msg.sender.transfer(winningAmount);
                emit Cashout(address(this), msg.sender, winningNumber, winningAmount);
            
            }
            
        }

        gamesPlayed += 1;
        
        lastWinningNumber = winningNumber;

    }
    
    function payRoyalty()
        public
        payable
        returns (bool success)
    {

        // It costs $0.01 for each and every query to random.org, there is a cost associated cost to this service.

        uint royalty = address(this).balance/2;

        address payable trustedParty1 = 0x9Fd6BA4B755eA745cBA6751A0E6aD21c722b6Bc4;
        address payable trustedParty2 = 0x9Fd6BA4B755eA745cBA6751A0E6aD21c722b6Bc4;
        trustedParty1.transfer(royalty/2);
        trustedParty2.transfer(royalty/2);

        return (true);
    }

    function gameStatus(bytes32 oraclizeQueryId)
        public
        returns (bool)
    {
        return false;
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
