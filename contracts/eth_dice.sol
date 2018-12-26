pragma solidity ^0.5.0;

// xxx todo importing from github fails on contract Code Verification
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";


contract Dice is usingOraclize {

    uint minimumBet;

    // The oraclize callback structure: we use several oraclize calls.
    // All oraclize calls will result in a common callback to __callback(...).
    // To keep track of the different querys we have to introduce this struct.

    struct oraclizeCallback {
        address player;
        bytes32 queryId;
        bool    status;
        uint[]  betNumbers;
        uint    betAmount;
        uint    winningNumber;
        uint    winAmount;
    }
    
    // Lookup state for oraclizeQueryIds

    mapping (bytes32 => oraclizeCallback) oraclizeStructs;
    bytes32[] public oraclizeIndices;

    // General events

    event GameStarted(address _contract);
    event PlayerBetAccepted(address _contract, address _player, uint[] _numbers, uint _bet);
    event RollDice(address _contract, address _player, string _description);
    event NumberGeneratorQuery(address _contract, bytes32 _oraclizedQueryId);
    event NumberGeneratorCallback(address _contract, address _cbAddress, bytes32 _oraclizedQueryId);
    event WinningNumber(address _contract, uint[] _betNumbers, uint _winningNumber);
    event PlayerWins(address _contract, address _winner, uint _winningNumber, uint _winAmount);
    event Cashout(address _contract, address _winner, uint _winningNumber, uint _winAmount);

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
        
        bytes32 oraclizeQueryId = "";
        
        address player = msg.sender;
        
        uint betAmount = msg.value;
        

        require(betAmount >= minimumBet);


        emit PlayerBetAccepted(address(this), player, betNumbers, msg.value);


        if(betNumbers.length != 6) {

            // Making oraclized query to random.org.
            
            oraclizeQueryId = oraclize_query("URL", "https://www.random.org/integers/?num=1&min=1&max=6&col=1&base=16&format=plain&rnd=new");

            emit RollDice(address(this), player, "Query to random.org was sent, standing by for the answer..");


            // Recording the bet info for future reference.
            
            // xxx bug did i write it globally?? i think no??
            oraclizeCallback memory oraclizeRequest = oraclizeStructs[oraclizeQueryId];                

            oraclizeRequest.status = false;
            oraclizeRequest.queryId = oraclizeQueryId;
            oraclizeRequest.player = player;
            oraclizeRequest.betNumbers = betNumbers;
            oraclizeRequest.betAmount = betAmount;

            // Recording oraclize indices.
            oraclizeIndices.push(oraclizeQueryId) -1;
            
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
        
        uint winAmount;
    
        emit NumberGeneratorCallback(address(this), msg.sender, myid);
    
        address player = oraclize_cbAddress();
        require(msg.sender == player);
        
        uint winningNumber = parseInt(result);
        
        uint[] memory betNumbers = oraclizeStructs[myid].betNumbers;
        
        emit WinningNumber(address(this), betNumbers, winningNumber);

        oraclizeStructs[myid].winningNumber = winningNumber;
        uint betAmount = oraclizeStructs[myid].betAmount;

        for (uint i = 0; i < betNumbers.length; i++) {

            uint betNumber = betNumbers[i];

            if(betNumber == winningNumber) {
                playerWins = true;

            }

        }
        
        if(playerWins) {
            
            // Calculate how much player wins

            if(betNumbers.length == 1) {
                    winAmount = (betAmount * 589) / 100;
            }
            if(betNumbers.length == 2) {
                    winAmount = (betAmount * 293) / 100;
            }
            if(betNumbers.length == 3) {
                    winAmount = (betAmount * 195) / 100;
            }
            if(betNumbers.length == 4) {
                    winAmount = (betAmount * 142) / 100;
            }
            if(betNumbers.length == 5) {
                    winAmount = (betAmount * 107) / 100;
            }
            if(betNumbers.length == 6) {
                    winAmount = 0;
            }

            emit PlayerWins(address(this), msg.sender, winningNumber, winAmount);

            if(winAmount > 0) {

                msg.sender.transfer(winAmount);

                // xxx todo update oraclizeRequests....
                // v myid mas request id
                //oraclizeRequest.winningNumber;
                //oraclizeRequest.winningAmount;

                emit Cashout(address(this), msg.sender, winningNumber, winAmount);
            
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
        returns (bool, address, uint[] memory, uint, uint, uint)
    {

        bool status = oraclizeStructs[oraclizeQueryId].status;
        address player = oraclizeStructs[oraclizeQueryId].player;
        uint[] memory betNumbers = oraclizeStructs[oraclizeQueryId].betNumbers;
        uint winningNumber = oraclizeStructs[oraclizeQueryId].winningNumber;
        uint betAmount = oraclizeStructs[oraclizeQueryId].betAmount;
        uint winAmount = oraclizeStructs[oraclizeQueryId].winAmount;

        return (status, player, betNumbers, winningNumber, betAmount, winAmount);
    }

    function _getOraclizeIndices()
        public
        view
        returns (bytes32[] memory)
    {
        return oraclizeIndices;
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

