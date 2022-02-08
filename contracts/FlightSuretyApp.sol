pragma solidity >=0.4.25;
pragma experimental ABIEncoderV2;



// It's important to avoid vulnerabilities due to numeric overflow bugs
// OpenZeppelin's SafeMath library, when used correctly, protects agains such bugs
// More info: https://www.nccgroup.trust/us/about-us/newsroom-and-events/blog/2018/november/smart-contract-insecurity-bad-arithmetic/

import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

/************************************************** */
/* FlightSurety Smart Contract                      */
/************************************************** */
contract FlightSuretyApp {
    using SafeMath for uint256; // Allow SafeMath functions to be called for all uint256 types (similar to "prototype" in Javascript)

    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/

    // Flight status codees
    uint8 private constant STATUS_CODE_UNKNOWN = 0;
    uint8 private constant STATUS_CODE_ON_TIME = 10;
    uint8 private constant STATUS_CODE_LATE_AIRLINE = 20;
    uint8 private constant STATUS_CODE_LATE_WEATHER = 30;
    uint8 private constant STATUS_CODE_LATE_TECHNICAL = 40;
    uint8 private constant STATUS_CODE_LATE_OTHER = 50;
    
    //Airline Registration Variables
    uint256  AIRLINE_COUNT = 0;
    address[] private AIRLINE;
    uint256  M = 0; //Consensys Participation Minimum Threshold
    address[] multiCalls = new address[](0); // Allocating an array for the addresses to get addded in array for consensys
    address firstAirline; 
    address insCompany = 0x88a6a89522cabed146e8f185c3766ca74327a665;
    //insCompany = 0x88a6a89522cabed146e8f185c3766ca74327a665;

   //Insurance Registration Variables
   uint256 public insID;
    
    address private contractOwner;          // Account used to deploy contract
    FlightSuretyData flightsuretydata;
    uint256 public constant REGISTRATION_FUND = 1 ether; //Settin up registration fund for the airline 
    uint256 public INSURANCE_PURCHASE = 1;
    uint256 public AIR_INSURANCE_PURCHASE = 10;

    
    struct Flight { // to register the flight for the airline
        uint256 id;
        bytes32 flightID;
        bool isRegistered;
        uint8 statusCode;
        uint256 updatedTimestamp;        
        
    }
    uint256 flightProCount; 
    mapping(uint256 => Flight) private flights;



    event insPurchased (string name);
    /********************************************************************************************/
    /*                                       FUNCTION MODIFIERS                                 */
    /********************************************************************************************/

    // Modifiers help avoid duplication of code. They are typically used to validate something
    // before a function is allowed to be executed.

    /**
    * @dev Modifier that requires the "operational" boolean variable to be "true"
    *      This is used on all state changing functions to pause the contract in 
    *      the event there is an issue that needs to be fixed
    */
    modifier requireIsOperational() 
    {
         // Modify to call data contract's status
        require(true, "Contract is currently not operational");  
        _;  // All modifiers require an "_" which indicates where the function body will be added
    }

   
    /**
    * @dev Modifier that requires the "ContractOwner" account to be the function caller
    */
    modifier requireContractOwner()
    {
        require(msg.sender == contractOwner, "Caller is not contract owner");
        _;
    }
      

    /********************************************************************************************/
    /*                                       CONSTRUCTOR                                        */
    /********************************************************************************************/

    /**
    * @dev Contract constructor
    *
    */
    constructor
                                (
                                    address dataContract
                                ) 
                                
                                public
    {
        contractOwner = msg.sender;
        
        //flightsuretydata = flightSuretyData(dataContract);
        flightsuretydata = FlightSuretyData(dataContract);

    }

    /********************************************************************************************/
    /*                                       UTILITY FUNCTIONS                                  */
    /********************************************************************************************/

    function isOperational() 
                            public 
                            pure 
                            returns(bool) 
    {
        return true;  // Modify to call data contract's status
    }

    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/
       /**
    * @dev Airlines to carry out consensus when registered flight count goes to 5 or more. 50% of flights should apply for consensys
    *
    */    
     
    function registerAirlineConsensys
                                    (
                                    bool airlineStatus,
                                    bool mode
                                    )
                                    internal
                                    returns(bool)
        {       
        require(mode != airlineStatus, "Consensys has already taken place for this airline");
        require(AIRLINE_COUNT >=4, "Atleast four airlines must be registered to vote in consensys");
        M = AIRLINE_COUNT / 2;
        bool isDuplicate = false;
        for (uint a=0; a<multiCalls.length; a++){
            if(multiCalls[a] == msg.sender){
                isDuplicate = true;
                break;
            }
        }
        require(!isDuplicate, "Consensys has already been passed to this function");
        bool registered;
        multiCalls.push(msg.sender);
        if(multiCalls.length >= M){
             registered = mode;
             multiCalls = new address[](0);
             return registered;
            }      

        }

  
   /**
    * @dev Add an airline to the registration queue
    *
    */   
    function registerAirline
                            (  
                               address newairline,
                               uint256 fundMoney
                            )
                            external
                            payable
                            returns(bool success, uint votes)
    {
        
        bool airlineStatus = false;
        bool consensysreturn = false;
        uint256 id = AIRLINE_COUNT;
        success = false;

        airlineStatus = flightsuretydata.isAirlineRegistered(newairline);
        require(fundMoney >= AIR_INSURANCE_PURCHASE, "Registration funding of 10 Ether is required" );// Reject further processing if the funding hasn't been provided by the airline
        require(airlineStatus == false, "Airline is already registered" ); //Reject further processing if the airline is already registered
            if (AIRLINE_COUNT == 0){        // This is when its the first Airline that in case hasn't been registered then it will registered by default) 
                                
                                flightsuretydata.registerAirline(id,airlineStatus,msg.sender,fundMoney);
                                firstAirline = msg.sender;
                                success = true;
                                return (success, 0);
                                AIRLINE_COUNT++;
            }else if( (AIRLINE_COUNT > 0 && AIRLINE_COUNT < 4)) {
                                require(msg.sender == firstAirline, "First Airline has authority to register flights");
                                flightsuretydata.registerAirline(id,airlineStatus,newairline,fundMoney);
                                success = true;
                                return (success, 0);
                                AIRLINE_COUNT++;
            } {
                
                //flightsuretydata.fund(msg.value);
                consensysreturn = registerAirlineConsensys(airlineStatus,true);
                flightsuretydata.registerAirline(id,consensysreturn,newairline,fundMoney);
                return(success,M);
                AIRLINE_COUNT++;
        }

       
    }

        //Function for passengertobuy Insurance
    function buy
                            (      
                                string name,
                                bytes32 flight,
                                uint256 insMoney     
                            )
                            external
                            payable
                            returns(bool)
                            
    {
        
       // bool purchased = false;
        bool purchased;
        bool inStatus = false;
        address user_wallet = msg.sender;
        

        require(insMoney >= INSURANCE_PURCHASE,"You need to spend 1 ether to buy insurance");
        
        inStatus = flightsuretydata.isuserInsured(flight);
        flightsuretydata.registerInsuree(insID, inStatus, name, flight, insMoney, user_wallet);
        purchased = flightsuretydata.isuserInsured(flight);
        return purchased; 
        insCompany.transfer(insMoney); 
        insID++;
    }



   /**
    * @dev Register a future flight for insuring.
    *
    */  
    function registerFlight
                                (
                                    address airline,
                                    bytes32 flight,
                                    uint256 fundMoney
                                )
                                external
                                payable
                                returns (bool)
    {
        require(fundMoney > INSURANCE_PURCHASE, "Funding is required to register for Insurance");
        //require(flightsuretydata.isAirlineRegistered(airline) == true , "Airline of the flight is not registered");
        require(flightsuretydata.isflightRegistered(flight) == false, "Flight is already registered");
        bool reg = false;
        reg = flightsuretydata.registerFlight(airline, flight, fundMoney);
        return reg;                        
        insCompany.transfer(fundMoney);
    }

    function checkInsurance
                                (
                                    bytes32 flight,
                                    address user_wallet
                                )
                                public
                                returns (bytes32)
                                
        {   

            
            require(flightsuretydata.insureeClaimCheck(flight, user_wallet) == "Transferred", "Please customer contact service to process payment on this account");
            bytes32 note;
            note =  flightsuretydata.insureeClaimCheck(flight, user_wallet);
            return note;


    }


   /**
    * @dev Called after oracle has updated flight status
    */
     
    function processFlightStatus
                                (
                                    
                                    address airline,
                                    bytes32 flight,
                                    uint256 timestamp,
                                    uint8 statusCode
                                )
                                internal
                                returns (bool)
                                
    {       //uint256 id = flightProCount;
            flights[flightProCount] = Flight({
                                id : flightProCount,
                                flightID : flight,
                                isRegistered : true,
                                statusCode: statusCode,
                                updatedTimestamp : timestamp        
                                });   
            
            bool transfer = false;
            require(flightsuretydata.isflightRegistered(flight));
            require(flights[flightProCount].statusCode != 10, "Flight has been on time without any disruption");
            transfer = flightsuretydata.insureeClaimTransfer(flight, insCompany);
           
            flightProCount++;
    }
    



    // Generate a request for oracles to fetch flight information
    function fetchFlightStatus
                        (
                            address airline,
                            bytes32 flight,
                            uint256 timestamp                            
                        )
                        external
                        returns (bytes32)
    {
        uint8 index = getRandomIndex(msg.sender);


        // Generate a unique key for storing the request
        bytes32 key = keccak256(abi.encodePacked(index, airline, flight, timestamp));
        bytes32 sender= key;
        return sender;
        oracleResponses[key] = ResponseInfo({
                                                requester: msg.sender,
                                                isOpen: true
                                            });

        emit OracleRequest(index, airline, flight, timestamp);
    } 


// region ORACLE MANAGEMENT

    // Incremented to add pseudo-randomness at various points
    uint8 private nonce = 0;    

    // Fee to be paid when registering oracle
    uint256 public constant REGISTRATION_FEE = 1 ether;

    // Number of oracles that must respond for valid status
    uint256 private constant MIN_RESPONSES = 1;


    struct Oracle {
        bool isRegistered;
        uint8[3] indexes;        
    }

    // Track all registered oracles
    mapping(address => Oracle) private oracles;

    // Model for responses from oracles
    struct ResponseInfo {
        address requester;                              // Account that requested status
        bool isOpen;                                    // If open, oracle responses are accepted
        mapping(uint8 => address[]) responses;          // Mapping key is the status code reported
                                                        // This lets us group responses and identify
                                                        // the response that majority of the oracles
    }

    // Track all oracle responses
    // Key = hash(index, flight, timestamp)
    mapping(bytes32 => ResponseInfo) private oracleResponses;

    // Event fired each time an oracle submits a response
    event FlightStatusInfo(address airline, bytes32 flight, uint256 timestamp, uint8 status);

    event OracleReport(address airline, bytes32 flight, uint256 timestamp, uint8 status);

    // Event fired when flight status request is submitted
    // Oracles track this and if they have a matching index
    // they fetch data and submit a response
    event OracleRequest(uint8 index, address airline, bytes32 flight, uint256 timestamp);


    // Register an oracle with the contract
    function registerOracle
                            (
                            )
                            external
                            payable
    {
        // Require registration fee
        require(msg.value >= REGISTRATION_FEE, "Registration fee is required");
        uint8[3] memory indexes = generateIndexes(msg.sender);
        oracles[msg.sender] = Oracle({
                                        isRegistered: true,
                                        indexes: indexes
                                    });
    }

    function getMyIndexes
                            (
                            )
                            view
                            external
                            returns(uint8[3])
    {
        require(oracles[msg.sender].isRegistered, "Not registered as an oracle");

        return oracles[msg.sender].indexes;
    }




    // Called by oracle when a response is available to an outstanding request
    // For the response to be accepted, there must be a pending request that is open
    // and matches one of the three Indexes randomly assigned to the oracle at the
    // time of registration (i.e. uninvited oracles are not welcome)
    function submitOracleResponse
                        (
                            uint8 index,
                            address airline,
                            bytes32 flight,
                            uint256 timestamp,
                            uint8 statusCode
                        )
                        external
                        returns (bytes32)
                        
                        
    { 
      require((oracles[msg.sender].indexes[0] == index) || (oracles[msg.sender].indexes[1] == index) || (oracles[msg.sender].indexes[2] == index), "Index does not match oracle request");

        
        bytes32 key = keccak256(abi.encodePacked(index, airline, flight, timestamp)); 
        
        //require(oracleResponses[key].isOpen, "Flight or timestamp do not match oracle request");

        oracleResponses[key].responses[statusCode].push(msg.sender);

        // Information isn't considered verified until at least MIN_RESPONSES
        // oracles respond with the *** same *** information
        emit OracleReport(airline, flight, timestamp, statusCode);
        
        if (oracleResponses[key].responses[statusCode].length >= MIN_RESPONSES) {
          
            emit FlightStatusInfo(airline, flight, timestamp, statusCode);
            //return key;
            // Handle flight status as appropriate
            processFlightStatus(airline, flight, timestamp, statusCode);
            return key;
        //oracle = true;
        //return oracle;
        
        }

    }


    
    function getFlightKey
                        (
                            address airline,
                            bytes32 flight,
                            uint256 timestamp
                        )
                        pure
                        internal
                        returns(bytes32) 
    {
        return keccak256(abi.encodePacked(airline, flight, timestamp));
    }
    
    // Returns array of three non-duplicating integers from 0-9
    function generateIndexes
                            (                       
                                address account         
                            )
                            internal
                            returns(uint8[3])
    {
        uint8[3] memory indexes;
        indexes[0] = getRandomIndex(account);
        
        indexes[1] = indexes[0];
        while(indexes[1] == indexes[0]) {
            indexes[1] = getRandomIndex(account);
        }

        indexes[2] = indexes[1];
        while((indexes[2] == indexes[0]) || (indexes[2] == indexes[1])) {
            indexes[2] = getRandomIndex(account);
        }

        return indexes;
    }

    // Returns array of three non-duplicating integers from 0-9
    function getRandomIndex
                            (
                                address account
                            )
                            internal
                            returns (uint8)
    {
        uint8 maxValue = 10;

        // Pseudo random number...the incrementing nonce adds variation
        uint8 random = uint8(uint256(keccak256(abi.encodePacked(blockhash(block.number - nonce++), account))) % maxValue);

        if (nonce > 250) {
            nonce = 0;  // Can only fetch blockhashes for last 256 blocks so we adapt
        }

        return random;
    }
}


// endregion
contract FlightSuretyData{
    function fund(uint256 fundMoney, uint256 id) external;
    function registerAirline(uint256 id, bool consensysreturn,address airline,uint256 fundMoney)external; // registering an airline 
    function isAirlineRegistered(address airline) external returns (bool reg); //Checking if airline is registered
    function registerInsuree(uint256 id,bool status, string name, bytes32 flight,uint256 insuranceMoney, address user_wallet)external returns(uint256);// to register the user for insurance
    function isuserInsured(bytes32 flight) public returns (bool reg); //to check if the user already have insurance
    function insureeClaimCheck (bytes32 Flight, address user_wallet) external returns (bytes32);
    function insureeClaimTransfer(bytes32 flight, address insCompany) external payable returns (bool reg); //to check the insuree's name
    function registerFlight(address airline, bytes32 flight, uint256 fundMoney)external returns (bool reg); // registering an airline 
    function isflightRegistered(bytes32 flight) external returns (bool reg); // Check to see if the flight is registered

}

