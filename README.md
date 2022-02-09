# FlightSurety - Blockchin based Insurance Project
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
This project consist of 

1. Data Contract 
2. App Contract 

Data Contract acts like a Database, where all the information related to airlines, flight and insurees are being stored.
App contract is where all the functionalities are being defined from the business operations view point.
