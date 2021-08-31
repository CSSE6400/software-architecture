---
title: Layered Architecture
author:
- Brae Webb
date: 2021
abstract: |
    Layered
---

## Overview

Layered architecture (sometimes referred to as multi-tier or tiered architecture) is a type of software architecture often found within monolithic applications.
The intention of a layered architecture is to create superficial boundaries between software components.

This architecture attempts to bring some of the advantages of isolation to monolithic applications.
Often component boundaries aren't enforced by the technology but by architectural policy.

The isolated components of a layered architecture are technically partitioned rather than domain partitioned.

## Standard Form

Layered architecture has a couple of common forms.

One of the more common forms of the layered architecture is a four-tier architecture.
Here, our system is composed of a presentation layer, business layer, persistence layer, and database layer.

![Four-Layered Architecture](images/architectures.layered/monolithic.png)

The presentation layer takes data in a form which a programming language is able to understand and formats it in a way that is sensible for humans.
For command line applications, the presentation layer would accept user input and print formatted messages for the user.
For traditional GUI applications, the presentation layer would use a GUI library to communicate with the user.

One of the key benefits afforded by a layered application is each layer should be interchangeable.
An application which starts as a command line application can be adapted to a GUI application by only replacing the presentation layer.

TODO: explain business and persistence


## Deployment Forms

While the layered architecture is popular with monolithic applications, as it allows monoliths to simulate physical isolation,
a layered architecture does not have to be monolithic.

Each layered can be physically deployed on different systems.
The most common variant of distributed deployment is separating the database layer.
Since databases have well defined contracts and are language independent, the database layer is a natural first choice for physical separation.

![Separated Database Layer](images/architectures.layered/separate-db.png)

Of course, in a well designed system, any layer of the system could be physically separated.
The presentation is another common target.
Physically separating the presentation layer gives users the ability to only install the presentation layer and allow communication to
other software components to occur over network communication.

![Separated Database and Presentation Layers](images/architectures.layered/distributed.png)

This deployment form is very typical of web applications.
The presentation layer is deployed as HTML/CSS/JavaScript which makes network requests to the remote business/persistence layer.
The business/persistence layer then validates requests and makes any appropriate database updates.

