pragma solidity >=0.4.25;
pragma experimental ABIEncoderV2;
import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract FlightSuretyData {
    using SafeMath for uint256;

    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/

    address private contractOwner;                                      // Account used to deploy contract
    bool private operational = true;                                    // Blocks all state changes throughout the contract if false
    //bool private registered = true;
    
    struct airlineProfile{
        uint256 id;
        bool isRegistered;
        address newairline;
        uint256 fundMoney;
    }
    uint256 public airCount;
   mapping(uint256 => airlineProfile) airlines;
    //struct for an insuree profile
    struct insureeProfile{
        uint256 id;
        bytes32 flight; 
        bool isInsured;
        string name;
        address wallet_user;
        uint256 insMoney;
        bytes32 note;
        
    }
    uint256 public insCount;
    mapping(uint256 => insureeProfile) public insurees;


    struct flightProfile { // to register the flight for insurance
        uint256 id;
        bytes32 flightID;
        bool isRegistered;
        address airline;
        uint256 fundMoney;       
    }
    uint256 public flightCount;
    mapping(uint256 => flightProfile) flightPro;

    /********************************************************************************************/
    /*                                       EVENT DEFINITIONS                                  */
    /********************************************************************************************/


    /**
    * @dev Constructor
    *      The deploying account becomes contractOwner
    */
    constructor
                                (
                                 
                                ) 
                                public 
    {
        //insCount;
        contractOwner = msg.sender;
    }

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
        require(operational, "Contract is currently not operational");
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
    /*                                       UTILITY FUNCTIONS                                  */
    /********************************************************************************************/

    /**
    * @dev Get operating status of contract
    *
    * @return A bool that is the current operating status
    */      
    function isOperational() 
                            public 
                            view 
                            returns(bool) 
    {
        return operational;
    }
    /* @dev Get operating status of the airline
    *
    * @return A bool that reflects the status of the airline if it is registered or not
    */
    function isAirlineRegistered(
                                    address airline
                                ) 
                                external
                                view
                              returns (bool)
    {
       for (uint8 i=0; i<= airCount; i++){
           if (airlines[i].newairline == airline)
                return airlines[i].isRegistered;}
    }  
    /* @dev Get operating status of the airline
    *
    * @return A bool that reflects the status of the airline if it is registered or not
    */
    function isflightRegistered(
                                    bytes32 flightID
                                ) 
                                external
                                view
                                returns (bool)
    {
       for(uint8 i = 0; i<=flightCount; i++){
           if(flightPro[i].flightID == flightID){
                return flightPro[i].isRegistered;}
       }
    }  
    /* @dev Get the status of a person is he/she is insured
    *
    * @return A bool that is the current insurance status
    */
    function isuserInsured  (
                                    bytes32 flight
                                ) 
                                public
                                view
                                returns (bool)
    {
    
             for (uint256 i = 0; i <= insCount; i++){    
                 if(insurees[i].flight == flight){    
                return insurees[i].isInsured;}
        }
    } 
    /* @dev Get the status of a person is he/she is insured
    *
    * @return A bool that is the current insurance status
    */
    function insureeClaimTransfer  (
                                 bytes32 flight,
                                 address insCompany
                                ) 
                                external
                                payable
                                returns (bool)
    {
            bool transfer = false;
            uint256 counter= 0;
            //bytes32 statement = Your_insurance_claim_money_has_been_transferred_to_your_account;
            for (uint256 i = 0; i <= insCount; i++){    
                 if(insurees[i].flight == flight){   
                                        counter = insurees[i].insMoney * 3/2; 
                                        insurees[i].wallet_user.transfer(counter);
                                        insurees[i].note = "Transferred"; 
                transfer = true;
                return transfer;
                }
        }

       
    } 
     /* @dev Get the status of a person is he/she is insured
    *
    * @return A bool that is the current insurance status
    */
    function insureeClaimCheck  (
                                 bytes32 flight, 
                                 address user_wallet

                                ) 
                                external   
                                returns (bytes32)
    {
            for (uint256 i = 0; i <= insCount; i++){    
                 if(insurees[i].flight == flight && insurees[i].wallet_user == user_wallet){   
                                        return insurees[i].note;
                
                }
        }

       
    }         

    /**
    * @dev Sets contract operations on/off
    *
    * When operational mode is disabled, all write transactions except for this one will fail
    */    
    function setOperatingStatus
                            (
                                bool mode
                            ) 
                            external
                            requireContractOwner 
    {
        operational = mode;
    }

    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/

   /**
    * @dev Add an airline to the registration queue
    *      Can only be called from FlightSuretyApp contract
    *
    */   
    function registerAirline
                            (   
                                uint256 id,
                                bool reg,
                                address newAirline,
                                uint256 fundMoney
                            )
                            external
                            payable
                            
    {
                            require(reg == false, "The Airline is registered");
                            airlines[id] = airlineProfile({
                                                            id: id,
                                                            isRegistered: true,
                                                            newairline: newAirline,
                                                            fundMoney: fundMoney
                                                            });
    }
    function registerFlight
                                (
                                    address airline,
                                    bytes32 flight,
                                    uint256 fundMoney
                                )
                                external
                                returns (bool)
    {
        //require(isflightRegistered(flight) == false,"Flight is already registered");
        uint256 id = flightCount;
        flightPro[id] = flightProfile({
                                            id : id,
                                            flightID : flight,
                                            isRegistered : true,
                                            airline : airline,
                                            fundMoney: fundMoney
                                        });
         return flightPro[id].isRegistered;   
         flightCount++;

    }
     /**
    * @dev register a person for insurance against the airline
    * Can only be called from FlightSuretyApp contract
    *
    */   
    function registerInsuree
                            (   uint256 id,
                                bool inStatus,
                                string name,
                                bytes32 flight,
                                uint256 insuranceMoney,
                                address wallet_user
                                
                            )
                            external
                            
                            returns (bool)
                            
    {
    //uint256 id = insCount;
    require(inStatus == false, "The user is already insured");

    insurees[insCount] = insureeProfile({
                                        //
                                        id: insCount,
                                        name: name,
                                        isInsured: true,
                                        flight: flight,
                                        wallet_user: wallet_user,
                                        insMoney: insuranceMoney,
                                        note: ""
                                        }); 

                     
        

       return insurees[insCount].isInsured;
       insCount++;
       

      /* flightINS[flight] = insureeProfile({
                                        id: id,
                                        name: name,
                                        isInsured: true,
                                        flight: flight
                                        });*/
        /*var ins = flightINS[flight];
        ins.id = id;
        ins.name = name;
        ins.isInsured = true;
        insureeList.push(flight);*/

    }

    /*    function updateInsuree
                                (
                                uint256 id,
                                bool inStatus,
                                string name,
                                bytes32 flight,
                                uint256 insuranceMoney

                                )
                                external
    {
        require(insurees[id].isInsured, "Employee is not registered.");

        insurees[id].isInsured = insurees[id].isInsured.add(true);
        insurees[id].name = insurees[id].name.add(name);
        insurees[id].flight = insurees[id].flight.add(flight);
        insurees[id].insuranceMoney = insurees[id].flight.add(insuranceMoney);


    }*/
    function getInsureesforflight (
                                    string flight
                                    )
                                    external
                                    view
                                    returns (string)
    {
            //return flightINS[flight].name;

    }



   /**
    * @dev Buy insurance for a flight
    *
    */   
    function buy
                            (                             
                            )
                            external
                            payable
    {

    }

    /**
     *  @dev Credits payouts to insurees
    */
    function creditInsurees
                                (
                                )
                                external
                                pure
    {
    }
    

    /**
     *  @dev Transfers eligible payout funds to insuree
     *
    */
    function pay
                            (
                            )
                            external
                            pure
    {
    }
       /**
     *  @dev Check if the airline is funded
     *
    */
    function isAirline
                            (
                                address newAirline
                            )
                            external
                            pure
                            returns (bool)
    {
        //return registered;
       
    }

   /**
    * @dev Initial funding for the insurance. Unless there are too many delayed flights
    *      resulting in insurance payouts, the contract should be self-sustaining
    *
    */   
    function fund
                    (   
                      uint256 Ether,
                      uint256 id
                    )
                    external
                            
    {
        airlines[id].fundMoney = Ether;
    }

    function getFlightKey
                        (
                            address airline,
                            //string memory flight,
                            string flight,
                            uint256 timestamp
                        )
                        pure
                        external
                        returns(bytes32) 
    {
        return keccak256(abi.encodePacked(airline, flight, timestamp));
    }

    /**
    * @dev Fallback function for funding smart contract.
    *
    */
    function () 
                            external 
                            payable 
    {
        //fund();
    }

  


}

