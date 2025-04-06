workspace "SOA" "Service Oriented Architecture"  {

    model {
        client1 = softwareSystem "Client 1" {}
        client2 = softwareSystem "Client 2" {}
        soaSystem = softwareSystem "SOA System" {
            serviceA = container "Service A" "" "" "service" {
                serviceAComp1 = component "Service A Component 1" "" "" "service"
                DBa = component "Service A DB" "" "" "db"
            }
            serviceB = container "Service B" "" "" "service" {
                serviceBComp1 = component "Service B Component 1" "" "" "service"
                DBb = component "Service B DB" "" "" "db"
            }
            serviceC = container "Service C" "" "" "service" {
                serviceCComp1 = component "Service C Component 1" "" "" "service"
                DBc = component "Service C DB" "" "" "db"
            }
            serviceD = container "Service D" "" "" "service" {
                serviceDComp1 = component "Service D Component 1" "" "" "service"
                DBd = component "Service D DB" "" "" "db"
            }
#            commonDB = container "Shared Database" "Common data storage" "" "db"
        }

        client1 -> serviceA ""
        client1 -> serviceB ""
        client1 -> serviceD ""
        client2 -> serviceA ""
        client2 -> serviceB ""
        client2 -> serviceC ""
        
        serviceAComp1 -> DBa ""
        serviceBComp1 -> DBb ""
        serviceCComp1 -> DBc ""
        serviceDComp1 -> DBd ""

        # Entity Service Anit-Pattern Containers
        antiPattern = softwareSystem "Entity Service Anti-Pattern" {
            customer = container "Customer Service" "" "" "antiPattern"
            order = container "Order Service" "" "" "antiPattern"
            cart = container "Shopping Cart Service" "" "" "antiPattern"
            product = container "Product Service" "" "" "antiPattern"
            pricing = container "Pricing Service" "" "" "antiPattern"
        }
        
        customer -> order
        customer -> cart
        cart -> product
        order -> product
        product -> pricing
    }

    views {
        systemContext soaSystem "context" {
            include *
        }

        container soaSystem "soaSystem" {
            include *
        }

        container antiPattern "esaAntiPattern" {
            include *
        }

        styles {
            element computer {
                    shape Window
                    background #b3deff
                    /* colour is text colour. */
                    colour #000000
            }
            element db {
                    shape Cylinder
                    background #bfffda
                    /* colour is text colour. */
                    colour #000000
            }
            element antiPattern {
                    background #f2ebb8
                    colour #000000
            }
            element browser {
                    shape WebBrowser
                    background #b3deff
                    /* colour is text colour. */
                    colour #000000
            }
            element smb {
                    shape Folder
                    background #e6f7c8
                    colour #000000
            }
            element service {
                    background #f7e8c8
                    colour #000000
            }
            element ldap {
                    background #deecfa
                    colour #000000
            }
            element sso {
                    background #fcf0e6
                    colour #000000
            }
            element queue {
                    shape Pipe
                    background #b6faf7
                    color #000000
                    icon https://raw.githubusercontent.com/tupadr3/plantuml-icon-font-sprites/master/devicons2/redis.png
            }
            element failover {
                    opacity 45
            }
        }

        themes default
    }

}
