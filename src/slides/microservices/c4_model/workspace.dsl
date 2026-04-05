workspace "Microservices" "Simple microservices architecture example" {

    model {
        group "Microservices Examples" {
            topology = softwareSystem "Microservices Topology" {
                client1 = container "Client 1" "e.g. Mobile Interface" "" "client" {
                    client1UI = component "Client 1 Integrated UI" "" "e.g. React Native" "ui"
                    client1S1UI = component "Service 1 UI" "" "e.g. React Native" "ui"
                    client1S2UI = component "Service 2 UI" "" "e.g. React Native" "ui"
                }
                
                client2 = container "Client 2" "e.g. Web Interface" "" "client" {
                    client2UI = component "Client 2 Integrated UI" "" "" "ui"
                    client2S2UI = component "Service 2 UI" "" "" "ui"
                    client2S3UI = component "Service 3 UI" "" "" "ui"
                }

                # Probably Delete All of the Monolithic UI Detail
                ui = container "Monolithic User Interface" "" "" "ui" {
                    uiMonolith = component "Integrated UI" "" "" "ui"
                    uiPart1 = component "Service 1 UI" "" "" "ui"
                    uiPart2 = component "Service 2 UI" "" "" "ui"
                    uiPart3 = component "Service 3 UI" "" "" "ui"
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
        }


        # Microservices Topology Relationships

        # Client -> API Layer Relationships for Deployment Diagrams
        # Comment out following block to produce other diagrams.
#        client1 -> service1API "APIs"
#        client2 -> service2API "APIs"

        # Client Relationships for General Topology Diagrams
        # Comment out following block to produce General Topology Deployment diagram.
        client1S1UI -> service1API "API 1"
        client1S2UI -> service2API "API 2"
        client2S2UI -> service2API "API 2"
        client2S3UI -> service3API "API 3"
        
        # Client UIs Internal Relationships
        client1UI -> client1S1UI
        client1UI -> client1S2UI
        client2UI -> client2S2UI
        client2UI -> client2S3UI
        
        # API Layer Internal Relationships
        service1API -> s1facade "Service 1 API"
        service2API -> s2facade "Service 2 API"
        service3API -> s3facade "Service 3 API"
        
        # API Layer to Services Relationships
        s1facade -> s1part1
        s1facade -> s1part2
        s2facade -> s2part1
        s2facade -> s2part2
        s3facade -> s3part1
        s3facade -> s3part2

        # Services Internal Relationships
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
#        ui -> api "APIs"
#        uiPart1 -> service1API "API 1"
#        uiPart2 -> service2API "API 2"
#        uiPart3 -> service3API "API 3"

        
        # Event Broker Coordination Relationships

        # Comment out following block to produce Microservices Topology - container diagram & Service component diagrams.
        s1part2 -> eventBroker "Queue API"
        s2part2 -> eventBroker "Queue API"
        s3part2 -> eventBroker "Queue API"


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
            }
            db1Server = deploymentNode "DB 1 Server" {
                db1Instance = containerInstance service1DB
            }
            deploymentNode "Service 2" {
                service2Instance = containerInstance service2
            }
            db2Server = deploymentNode "DB 2 Server" {
                db2Instance = containerInstance service2DB
            }
            deploymentNode "Service 3" {
                service3Instance = containerInstance service3
            }
            db3Server = deploymentNode "DB 3 Server" {
                db3Instance = containerInstance service3DB
            }
        }

        deploymentEnvironment "Microservices with Event Queue" {
            deploymentNode "Client 1" "e.g. Mobile App" "" {
                client1EventInstance = containerInstance client1
            }
            deploymentNode "Client 2" "e.g. Web App" "" {
                client2EventInstance = containerInstance client2
            }
            deploymentNode "API Layer" {
                apiEventInstance = containerInstance api
            }
            deploymentNode "Service 1" {
                service1EventInstance = containerInstance service1
            }
            db1EventServer = deploymentNode "DB 1 Server" {
                db1EventInstance = containerInstance service1DB
            }
            deploymentNode "Service 2" {
                service2EventInstance = containerInstance service2
            }
            db2EventServer = deploymentNode "DB 2 Server" {
                db2EventInstance = containerInstance service2DB
            }
            deploymentNode "Service 3" {
                service3EventInstance = containerInstance service3
            }
            db3EventServer = deploymentNode "DB 3 Server" {
                db3EventInstance = containerInstance service3DB
            }
            deploymentNode "Message Queue" {
                msgQueueInstance = containerInstance msgQueue
            }
        }
        
        deploymentEnvironment "Monolithic User Interface" {
            deploymentNode "UI Platform" "e.g. Mobile App" "" {
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
        
        deployment * "Microservices with Event Queue" "event_queue_deployment_diagram" {
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
        
        component client1 "client1_component_diagram" {
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
