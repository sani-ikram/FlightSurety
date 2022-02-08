import FlightSuretyApp from '../../build/contracts/FlightSuretyApp.json';
import Config from './config.json';
import Web3 from 'web3';

export default class Contract {
    constructor(network, callback) {

        let config = Config[network];
        this.web3 = new Web3(new Web3.providers.HttpProvider(config.url));
        this.flightSuretyApp = new this.web3.eth.Contract(FlightSuretyApp.abi, config.appAddress);
        this.initialize(callback);
        this.owner = null;
        this.airlines = [];
        this.passengers = [];
    }

    initialize(callback) {
        this.web3.eth.getAccounts((error, accts) => {
           
            this.owner = accts[0];

            let counter = 1;
            
            while(this.airlines.length < 5) {
                this.airlines.push(accts[counter++]);
            }

            while(this.passengers.length < 5) {
                this.passengers.push(accts[counter++]);
            }

            callback();
        });

    }

    isOperational(callback) {
       let self = this;
       self.flightSuretyApp.methods
            .isOperational()
            .call({ from: self.owner}, callback);
    }

    fetchFlightStatus(flight, callback) {
        let self = this;
        let payload = {
            airline: self.airlines[0],
            flight: flight,
            timestamp: Math.floor(Date.now() / 1000)
        } 
        self.flightSuretyApp.methods
            .fetchFlightStatus(payload.airline, payload.flight, payload.timestamp)
            .send({ from: self.owner}, (error, result) => {
                callback(error, payload);
            });
            
    }
    registerAirline(airlineAddr,fundMoney,callback) {
        let self = this;
        let payload = {
            //airline: self.airlines[0],
            airlineAddr: airlineAddr,
            fundMoney: fundMoney
            //timestamp: Math.floor(Date.now() / 1000)
        } 
        self.flightSuretyApp.methods
            .registerAirline(payload.airlineAddr, payload.fundMoney)
            .send({ from: self.owner}, (error, result) => {
                callback(error, payload);
            });
            
    }
    registerFlight(airlineAddr,flight,fundMoney,callback) {
        let self = this;
        let payload = {
            //airline: self.airlines[0],
            airlineAddr: airlineAddr,
            flight: flight,
            fundMoney: fundMoney
            //timestamp: Math.floor(Date.now() / 1000)
        } 
        self.flightSuretyApp.methods
            .registerAirline(payload.airlineAddr,payload.flight, payload.fundMoney)
            .send({ from: self.owner}, (error, result) => {
                callback(error, payload);
            });
            
    }
    buy(name,flight,insMoney, callback) {
        let self = this;
        let payload = {
            //airline: self.airlines[0],
            name: name,
            flight: flight,
            insMoney:insMoney
            //timestamp: Math.floor(Date.now() / 1000)
        } 
        self.flightSuretyApp.methods
            .buy(payload.name, payload.flight, payload.insMoney)
            .send({ from: self.owner}, (error, result) => {
                callback(error, payload);
            });
            
    }
    checkInsurance(flight,walletaddress,callback) {
        let self = this;
        let payload = {

            flight: flight,
            walletaddress: walletaddress

        } 

            self.flightSuretyApp.methods
            .checkInsurance(payload.flight, payload.walletaddress)
            .send({from: self.owner}, (error, result) =>{
                callback(error, payload);
            })
    
            
    }
    registerOracle(callback) {
        let self = this;
        let valueEther = web3.utils.toWei(web3.utils.toBN(1));
        let payload = {

        } 
            self.flightSuretyApp.methods
            .registerOracle()
            .send({from: self.owner, value: valueEther}, (error, result) =>{
                callback(error, payload);
            })
    }
    getMyIndexes(callback) {
        let self = this;
        let payload = {

        } 
            self.flightSuretyApp.methods
            .getMyIndexes()
            .send({from: self.owner}, (error, result) =>{
                callback(error, payload);
            })
    }
   /* fetchFlightStatus(airlineAddr, flight, timestamp, callback){
        let self = this;
        let payload = {
            airlineAddr: airlineAddr,
            flight: flight,
            timestamp: timestamp
        }
        self.flightSuretyApp.methods
        .fetchFlightStatus(payload.airlineAddr, payload.flight, payload.timestamp)
        .send({from: self.owner}, (error, result) =>{
            callback(error, payload);
        })

    }*/
    submitOracleResponse(oracleIndexes, airline1Addr, flight, timestamp, statusCode, callback){
        let self = this;
        let payload = {
            oracleIndexes: oracleIndexes,
            airline1Addr: airline1Addr,
            flight: flight,
            timestamp: timestamp,
            statusCode: statusCode
        }
        .submitOracleResponse(payload.oracleIndexes, payload.airline1Addr, payload.timestamp, payload.statusCode)
        .send({from: self.owner}, (error, result) =>{
            callback(error, payload);
        })
    }
}