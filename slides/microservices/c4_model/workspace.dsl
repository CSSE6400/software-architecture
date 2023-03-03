workspace "Microservices" "Simple microservices architecture example" {

    model {
        enterprise "Microservices Example" {
            example = softwareSystem "Microservices Example" {
                api = container "API Layer" "Interface to external services." "" "api" {
                    service1API = component "Service 1 API"
                    service2API = component "Service 2 API"
                    service3API = component "Service 3 API"
                }
                
                service1 = container "Service 1" {
                    s1part1 = component "Component 1"
                    s1part2 = component "Component 2"
                }
                
                service1DB = container "Service 1 DB" "" "" "db"
                
                service2 = container "Service 2" {
                    s2part1 = component "Component 1"
                    s2part2 = component "Component 2"
                }
                
                service2DB = container "Service 2 DB" "" "" "db"
                
                service3 = container "Service 3" {
                    s3part1 = component "Component 1"
                    s3part2 = component "Component 2"
                }
                
                service3DB = container "Service 3 DB" "" "" "db"
            }
            
            client1App = softwareSystem "Client 1 App" {
                client1 = container "Client 1" "" "" "external"
            }
            
            client2App = softwareSystem "Client 2 App" {
                client2 = container "Client 2" "" "" "external"
            }
        }
        
        client1 -> service1API
        client1 -> service2API
        client2 -> service2API
        client2 -> service3API
        
        service1API -> s1part1
        service1API -> s1part2
        service2API -> s2part1
        service2API -> s2part2
        service3API -> s3part1
        service3API -> s3part2
        
        s1part1 -> service1DB
        s1part2 -> service1DB
        s2part1 -> service2DB
        s2part2 -> service2DB
        s3part1 -> service3DB
        s3part2 -> service3DB
        
        deploymentEnvironment "Deployment" {
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
    }

    views {
        deployment * "Deployment" "deployment_diagram" {
            include *
#            autoLayout tb
        }
        
        container example "microservices_container_diagram" {
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

        styles {
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
            element mobile {
                shape MobileDevicePortrait
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
            element api {
                shape Component
                background #f7c1f7
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
