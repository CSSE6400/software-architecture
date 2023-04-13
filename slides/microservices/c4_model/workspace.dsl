workspace "Microservices" "Simple microservices architecture example" {

    model {
        group "Microservices Examples" {
            topology = softwareSystem "Microservices Topology" {
                client1 = container "Client 1" "" "" "client"
                client2 = container "Client 2" "" "" "client"

                ui = container "Monolithic User Interface" "" "" "ui" {
                    uiMonolith = component "Integrated User Interface" "" "" "ui"
                    uiPart1 = component "User Interface Component 1" "" "" "ui"
                    uiPart2 = component "User Interface Component 2" "" "" "ui"
                    uiPart3 = component "User Interface Component 3" "" "" "ui"
                }

                api = container "API Layer" "Interface to external services." "" "api" {
                    service1API = component "Service 1 API" "" "" "api"
                    service2API = component "Service 2 API" "" "" "api"
                    service3API = component "Service 3 API" "" "" "api"
                }
                
                service1 = container "Service 1" "" "" "service1" {
                    s1facade = component "Service 1 Façade" "" "" "facade"
                    s1part1 = component "Component 1" "" "" "service1" 
                    s1part2 = component "Component 2" "" "" "service1" 
                }
                service1DB = container "Service 1 DB" "" "" "db"
                
                service2 = container "Service 2" "" "" "service2"  {
                    s2facade = component "Service 2 Façade" "" "" "facade"
                    s2part1 = component "Component 3" "" "" "service2"
                    s2part2 = component "Component 4" "" "" "service2"
                }
                service2DB = container "Service 2 DB" "" "" "db"
                
                service3 = container "Service 3" "" "" "service3" {
                    s3facade = component "Service 3 Façade" "" "" "facade"
                    s3part1 = component "Component 5" "" "" "service3"
                    s3part2 = component "Component 6" "" "" "service3"
                }
                service3DB = container "Service 3 DB" "" "" "db"
                
                msgQueue = container "Message Queue" "" "" "queue" {
                    eventBroker = component "Event Broker"
                }
            }
            
            client1App = softwareSystem "Client 1 App" "" "external" {
            }
            
            client2App = softwareSystem "Client 2 App" "" "external" {
            }
        }


        # Microservices Topology Relationships

        # Client -> API Layer Relationships for General Topology Deployment Diagram
        # Comment out following block to produce other diagrams.
#        client1 -> service1API "APIs"
#        client2 -> service2API "APIs"

        # Client Relationships for General Topology Diagrams
        # Comment out following block to produce General Topology Deployment diagram.
        client1 -> service1API "API 1"
        client1 -> service2API "API 2"
        client2 -> service2API "API 2"
        client2 -> service3API "API 3"
        
        service1API -> s1facade "Service 1 API"
        service2API -> s2facade "Service 2 API"
        service3API -> s3facade "Service 3 API"
        
        s1facade -> s1part1
        s1facade -> s1part2
        s2facade -> s2part1
        s2facade -> s2part2
        s3facade -> s3part1
        s3facade -> s3part2

        s1part1 -> service1DB
        s1part2 -> service1DB
        s2part1 -> service2DB
        s2part2 -> service2DB
        s3part1 -> service3DB
        s3part2 -> service3DB


        # Monolithic UI Relationships

        uiMonolith -> uiPart1
        uiMonolith -> uiPart2
        uiMonolith -> uiPart3

        # Comment out following block to produce Microservices Topology - API Layer component diagram.
        ui -> api "APIs"
        uiPart1 -> service1API "API 1"
        uiPart2 -> service2API "API 2"
        uiPart3 -> service3API "API 3"

        
        # Event Broker Coordination Relationships

        # Comment out following block to produce Microservices Topology - container diagram & Service component diagrams.
        s1part2 -> eventBroker
        s2part2 -> eventBroker
        s3part2 -> eventBroker


        deploymentEnvironment "Microservices Topology" {
            deploymentNode "Client 1" "e.g. Mobile App" "" {
                client1Instance = containerInstance client1
            }
            deploymentNode "Client 2" "e.g. Web App" "" {
                client2Instance = containerInstance client2
            }
            deploymentNode "API Layer" {
                apiInstance = containerInstance api
            }
            deploymentNode "Service 1" {
                service1Instance = containerInstance service1
                db1Server = deploymentNode "DB 1 Server" {
                    db1Instance = containerInstance service1DB
                }
            }
            deploymentNode "Service 2" {
                service2Instance = containerInstance service2
                db2Server = deploymentNode "DB 2 Server" {
                    db2Instance = containerInstance service2DB
                }
            }
            deploymentNode "Service 3" {
                service3Instance = containerInstance service3
                db3Server = deploymentNode "DB 3 Server" {
                    db3Instance = containerInstance service3DB
                }
            }
        }
        
        deploymentEnvironment "Monolithic User Interface" {
            deploymentNode "UI Platform" "" "" {
                uiMonolithInstance = containerInstance ui
            }
            deploymentNode "API Layer" {
                apiInstance2 = containerInstance api
            }
            deploymentNode "Service 1" {
                service1Instance2 = containerInstance service1
                db1Server2 = deploymentNode "DB 1 Server" {
                    db1Instance2 = containerInstance service1DB
                }
            }
            deploymentNode "Service 2" {
                service2Instance2 = containerInstance service2
                db2Server2 = deploymentNode "DB 2 Server" {
                    db2Instance2 = containerInstance service2DB
                }
            }
            deploymentNode "Service 3" {
                service3Instance2 = containerInstance service3
                db3Server2 = deploymentNode "DB 3 Server" {
                    db3Instance2 = containerInstance service3DB
                }
            }
        }
    }


    views {
        deployment * "Microservices Topology" "topology_deployment_diagram" {
            include *
#            autoLayout tb
        }
        
        deployment * "Monolithic User Interface" "monolithic_ui_deployment_diagram" {
            include *
#            autoLayout tb
        }
        
        container topology "topology_container_diagram" {
            include *
#            autoLayout tb
        }
        
        component ui "monolithic_ui_component_diagram" {
            include *
#            autoLayout tb
        }
        
        component api "api_component_diagram" {
            include *
#            autoLayout tb
        }
        
        component service1 "service1_component_diagram" {
            include *
#            autoLayout tb
        }
        
        component service2 "service2_component_diagram" {
            include *
#            autoLayout lr
        }
        
        component service3 "service3_component_diagram" {
            include *
#            autoLayout lr
        }

        styles {
            element "Software System" {
                shape Box
            }
            element "Container" {
                shape RoundedBox
            }
            element "Component" {
                shape Component
            }
            element ancillary {
                background #f2c679
                /* colour is text colour. */
                colour #000000
            }
            element external {
                background #09355c
                /* colour is text colour. */
                colour #FFFFFF
            }
            element client {
                background #0f3d87
                /* colour is text colour. */
                colour #FFFFFF
            }
            element facade {
                background #f7e8c8
            }
            element api {
                background #f7c1f7
                /* colour is text colour. */
                colour #000000
            }
            element service1 {
                background #e6f7c8
                /* colour is text colour. */
                colour #000000
            }
            element service2 {
                background #d2fae7
                /* colour is text colour. */
                colour #000000
            }
            element service3 {
                background #deecfa
                /* colour is text colour. */
                colour #000000
            }
            element ui {
                background #fadee0
                /* colour is text colour. */
                colour #000000
            }
            element mobile {
                shape MobileDevicePortrait
                background #b3deff
                /* colour is text colour. */
                colour #000000
            }
            element db {
                shape Cylinder
                background #027812
                /* colour is text colour. */
                colour #FFFFFF
            }
            element browser {
                shape WebBrowser
                background #b3deff
                /* colour is text colour. */
                colour #000000
            }
            element queue {
                shape Pipe
                background #f7c383
                /* colour is text colour. */
                colour #000000
            }
            element failover {
                opacity 45
            }
        }

        themes default
    }

}
