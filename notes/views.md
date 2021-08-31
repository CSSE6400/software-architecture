---
title: Architecture Views
author:
- Brae Webb
date: 2021
abstract: |
    Architecture views give us a common language to discuss our software.
    Views are used to document the design and implementation of a software architecture.
    Views allow anyone who has a vested interest in the software, including, but not limited to,
    developers, architects, SREs, stakeholders or, network engineers, to communicate about the system.

    There are three primary types of views; module views, component-and-connector views, and allocation views.
    It is important to understand which type of view is most suitable to facilitate communication.
---

# Introduction

The successful implementation of any architecture relies on the ability for the architectural design
to be disseminated to everyone involved in the implementation effort.
For some institutions, the software is simple enough, or the team small enough, that the design
can be communicated through word of mouth.
As software becomes increasingly complex and developers number in the thousands for many companies,
it is critical for design to be communicated as effectively as possible.

Architecture views are a well established method to communicate software architecture design.
Roughly, each type of architectural view communicates the following:
how implementation components of a system are structures,
how individual components communicate with each other,
and how the components are deployed to hardware.
Corresponding to module views, component-and-connector views, and allocation views respectively.

# Module Views

The components of module views are, as expected, modules.
These modules represent static units of functionality,
this could comprise classes, functions, modules, or whole programs.
The defining characteristic of a module is that it represents software which is responsible for some functionality.
For example, a class which converts JSON to XML would be considered a module, as would a function which performs the same task.

The primary function of module views are to communicate the dependencies of a module.
Rarely does software work completely in isolation, often is it constructed with implicit or explicit dependencies.
A module which converts JSON to XML might depend upon a module which parses JSON and a module which can format XML.
Module views make these dependencies explicit.

# Component-and-connector Views

Component-and-connector views focus on the runtime, or dynamic behaviour of a system.
Components are units which perform some computation or operation at runtime.
These components could overlap with the modules of a module view but are often at a higher level of abstraction.
The focus of component-and-connector views is how these components communicate at runtime.
Runtime communication is the connector of components.
For example, a service which registers users to a website might have new registrations communicated via a REST request.
The service may then communicate the new user information to a database via SQL queries.

When we look at software architecture, component-and-connector views are the most commonly used views.
They are common because they contain runtime information which is not easily automatically extracted.
Module views can be generated after the fact, i.e. it is easy enough for a project to generate a UML inheritance diagram.
Component-and-connector views are often something that is maintained manually by architects and developers.


# References
