# 2. Implement Web Application Using JSF

Date: 2023-01-09

## Status

Accepted

## Summary

*In the context of* delivering an interactive web application,  
*facing* the need for complex backend logic,  
*we decided* to implement the web application in JSF,  
*to achieve* easier integration with a Java backend,  
*accepting* the greater complexity of building JSF applications compared to some other web development frameworks.

## Context

- An interactive web interface is required for the project.
- Project sponsor wants a rich user experience.
- Marketing department wants a similar experience across platforms.
- Development team has experience using Java.
- Backend logic will be implemented in Java to cater for complex processing and database transactions ([ADR0001](0001-independent-business-logic.md)).
- There are many JavaScript libraries available for web applications.
- There are many web development frameworks available to create web applications.
- Several popular frameworks are under rapid development and changes.

## Decision

JSF will be used to deliver the web frontend behaviour.
It is a stable platform for development, which has a proven performance record.
Integrating with the Java backend is simplified through contexts and dependency injection (CDI).
We can use JavaScript libraries for frontend behaviour, while writing much of the behaviour in Java.

JavaScript-based web development frameworks, such as Angular or React
would provide similar rich interfaces to JSF.
The advantage of these frameworks are their popularity and familiarity with many developers.
One drawback is their rate of change.
The 3d interaction requirement still requires using an external library with these frameworks.

## Consequences

Advantages
- Data from the Java backend can easily be used in JSF through Java beans and CDI.
- Development team has more familiarity with Java than JavaScript.

Neutral
- Communication between the web frontend and the backend can be implemented via RMI if they are on separate computing devices.

Disadvantages
- JSF is less popular amongst developers, which may lead to greater maintenance costs.
