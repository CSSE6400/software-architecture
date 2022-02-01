## On-line Store Container Diagram

Customers can use either a web or mobile application to access the on-line store.

![](embed:store_container_diagram)

The web application delivers content to the customer's browser.
JSF and JavaScript provide the dynamic behaviour of the web application.

Business logic is implemented in a separate backend tier.
The web and mobile applications provide the presentation tier of the software system.
They use the application backend to deliver logical behaviour.

The application backend stores order transaction details in an SQL database, using JPA.
The backend sends customer browsing history to a data mining service to track customer behaviour.
The data mining service provides product recommendations
that the application backend can use to provide recommendations to the presentation tier.