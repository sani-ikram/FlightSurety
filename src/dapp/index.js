
import DOM from './dom';
import Contract from './contract';
import './flightsurety.css';
const ethers = require('ethers');
const utils = ethers.utils;


(async() => {

    let result = null;

    let contract = new Contract('localhost',async () => {
       /* const TEST_ORACLES_COUNT = 10;
        let flight= 'ND1309'; // Course number
        let flightinBytes = utils.formatBytes32String(flight_num);  
        let timestamp = Math.floor(Date.now() / 1000); // timestamp to calculate the key 
        let statusCode = 40; // flight not on time
        let airline1 = 0x20AD6a08Ca74c3235402fc2215A938230B2D6796;
        
        for(let a=1; a<TEST_ORACLES_COUNT; a++) {     
            await contract.getMyIndexes.call();
            let indexes = await contract.getMyIndexes.call();
            for(let idx=0;idx<3;idx++) {
                await config.flightSuretyApp.submitOracleResponse.call(indexes[idx], airline1, flightinBytes, timestamp,statusCode);
                }
        }
            */
        // Read transaction
        contract.isOperational((error, result) => {
            console.log(error,result);
            display('Operational Status', 'Check if contract is operational', [{ label: 'Operational Status', error: error, value: result}]);
        });

    
        // User-submitted transaction
        DOM.elid('submit-oracle').addEventListener('click', () => {
            let flight = DOM.elid('flight-number').value;
            let flightinBytes = utils.formatBytes32String(flight); 
            // Write transaction
            contract.fetchFlightStatus(flightinBytes, (error, result) => {
                display('Oracles', 'Trigger oracles', [ { label: 'Fetch Flight Status', error: error, value: flight + ' ' + result.timestamp} ]);
            });
        })
        DOM.elid('submit-to-register-airline').addEventListener('click', () => {
            let airlineAddr = DOM.elid('airline-address').value;
            let fundMoney = DOM.elid('airline-fund').value;       
            // Write transaction
            contract.registerAirline(airlineAddr, fundMoney, (error, result) => {
                display('Insurance Submission', 'Result', [ { label: "Register an Airline for Insurance", error: error, value: result.airlineAddr + ' is insured for the flight'} ]);
            });
        })
        DOM.elid('submit-toInsure').addEventListener('click', () => {
            let name = DOM.elid('insuree-name').value;
            let flight = DOM.elid('flight-number').value;
            let flightinBytes = utils.formatBytes32String(flight); 
            let insMoney = DOM.elid('insurance-money').value;
            // Write transaction
            contract.buy(name, flightinBytes,insMoney, (error, result) => {
                display('Flight Insurance Registration', 'Result', [{ label: "Register for Insurance", error: error, value:'You are insured for the flight'} ]);
            });
        })
        DOM.elid('submit-flightinsurance').addEventListener('click', () => { 
            let fundMoney = DOM.elid('fundMoney').value;
            let airline = DOM.elid('airline-address').value;
            let flight = DOM.elid('flight-number').value;
            let flightinBytes = utils.formatBytes32String(flight); 

            // Write transaction
            contract.checkInsurance( airline,flightinBytes,fundMoney, (error, result) => {
                display('Flight Insurance Registration', 'Result', [ { error: error, value: flight + 'is insured'} ]);
            });
        })
        DOM.elid('submit-insuranceCheck').addEventListener('click', () => {
            let flight = DOM.elid('flight-number').value;
            let flightinBytes = utils.formatBytes32String(flight);
            let walletAddr = DOM.elid('wallet-address').value; 

            // Write transaction
            contract.checkInsurance(flightinBytes,walletAddr,(error, result) => {
                display('Insurance Check', 'Result', [{error: error, value: result}]);
            });
        })
    
    });
    

})();


function display(title, description, results) {
    let displayDiv = DOM.elid("display-wrapper");
    let section = DOM.section();
    section.appendChild(DOM.h2(title));
    section.appendChild(DOM.h5(description));
    results.map((result) => {
        let row = section.appendChild(DOM.div({className:'row'}));
        row.appendChild(DOM.div({className: 'col-sm-4 field'}, result.label));
        row.appendChild(DOM.div({className: 'col-sm-8 field-value'}, result.error ? String(result.error) : String(result.value)));
        section.appendChild(row);
    })
    displayDiv.append(section);

}







