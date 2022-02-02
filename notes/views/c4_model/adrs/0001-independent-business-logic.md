# 1. Independent Business Logic

Date: 2022-01-06

## Status

Accepted

## Summary

*In the context of* delivering an application with multiple platform interfaces,  
*facing* budget constraints on development costs,  
*we decided* to implement all business logic in an independent tier of the software architecture,  
*to achieve* consistent logical behaviour across platforms,  
*accepting* potential complexity of interfaces to different platforms.

## Context

- The system is to have both mobile and web application frontends.
- Marketing department wants a similar user experience across platforms.
- Delivering functional requirements requires complex processing and database transactions.
    - Product recommendations based on both a customer's history and on purchasing behaviour of similar customers.
    - Recording all customer interactions in the application.
- Sales department wants customers to be able to change between using mobile and web applications without interrupting their sales experience.
- Development team has experience using Java.

## Decision

All business logic will be implemented in its own tier of the software architecture.
Web and mobile applications will implement the interaction tier.
They will communicate with the backend to perform all logic processing.
This provides clear separation of concerns and ensures consistency of business logic across frontend applications.
It means the business logic only needs to be implemented once.
This follows good design practices and common user interface design patterns.

The business logic will be implemented in Java.
This suits the current development team's experience and is a common environment.
Java has good performance characteristices.
Java has good support for interacting with databases, to deliver the data storage and transaction processing requirements.

## Consequences

Advantages
- Separation of concerns, keeping application logic and interface logic separate.
- Ensures consistency, if business logic is only implemented in one place.
- Business logic can execute in a computing environment optimised for processing and transactions.
    - Also makes load balancing easier to implement.

Neutral
- Multiple interfaces are required for different frontend applications.
  These can be delivered through different Java libraries.

Disadvantages
- Additional complexity for the overall architecture of the system.
