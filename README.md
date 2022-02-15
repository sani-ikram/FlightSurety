# FlightSurety

FlightSurety is a sample application project for Udacity's Blockchain course.

This Flight Surety Project is a blockchain based project.This provides the ability to provide the insuree with the 1.5 * the insurance money they paid to register for flight in case of any flight delay or cancellations.

Following addresses are currently assigned. 
Airline 1 : 0x20AD6a08Ca74c3235402fc2215A938230B2D6796(Primary Airline)
Airline 2: 0xc5f3eee44d44d9b530bfc8abb171d06c3bcaabfa

user: 0x8742ff5d6aa94173cc6fad836140f49b4fadad38
insurance Company: 0x88a6a89522cabed146e8f185c3766ca74327a665

Airline can sign up for insurance if they can provide 10 Ethers of fundings
Flights can sign up for insurance if the airline they belong to has already signed up 
and every flight has to provide 1 Ether of funding.

Users can sign up for insurance if the airline and flight already have registered for insurance
Insurees need to pay 1 Ether to sign up for insurance.
In case of any cancellation or delay they will be automatically refunded the 1.5 times the insurance money they paid at the time of insurance.
Insuree can log into the portal using their wallet address and flight No and they will have a notification in the accounnt that their money has been paid.

This whole process ensures that customer gets served efficiently, offers faster insurance claim processing as claims get processed automatically by airlines without requiring end user to initiate the process
Thus resulting higher customer satisfaction and faster delivery of service. 


I have covered all the requirements and the points mentioned in the assignment. All functionalities are working fine and all tests are working. I have added some additional tests as well to check more functionalities. Currently, Data contract is only for storage with no processing taking place there and App contract is the one where all the processing is happening. 
When I was working on web development part, all features are added. However, I am not clear whether we have to add oracle registration part as a backend or we have to create another front end for it to submit the flight information with status codes.

## Install

This repository contains Smart Contract code in Solidity (using Truffle), tests (also using Truffle), dApp scaffolding (using HTML, CSS and JS) and server app scaffolding.

To install, download or clone the repo, then:

`npm install`
`truffle compile`

## Develop Client

To run truffle tests:

`truffle test ./test/flightSurety.js`
`truffle test ./test/oracles.js`

To use the dapp:

`truffle migrate`
`npm run dapp`

To view dapp:

`http://localhost:8000`

## Develop Server

`npm run server`
`truffle test ./test/oracles.js`

## Deploy

To build dapp for prod:
`npm run dapp:prod`

Deploy the contents of the ./dapp folder


## Resources

* [How does Ethereum work anyway?](https://medium.com/@preethikasireddy/how-does-ethereum-work-anyway-22d1df506369)
* [BIP39 Mnemonic Generator](https://iancoleman.io/bip39/)
* [Truffle Framework](http://truffleframework.com/)
* [Ganache Local Blockchain](http://truffleframework.com/ganache/)
* [Remix Solidity IDE](https://remix.ethereum.org/)
* [Solidity Language Reference](http://solidity.readthedocs.io/en/v0.4.24/)
* [Ethereum Blockchain Explorer](https://etherscan.io/)
* [Web3Js Reference](https://github.com/ethereum/wiki/wiki/JavaScript-API)
