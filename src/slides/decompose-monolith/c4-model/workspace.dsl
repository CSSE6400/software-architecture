workspace "Monolith Decomposition" "Example decomposition of a monolith." {
    model {
        # Actors
        client = person "Client" ""

        group "Monolith Decomposition" {
            application = softwareSystem "Application" "" {
                monolith = container "Monolith" "Monolith being decomposed." "" ""
                db = container "Application Database" "" "MySQL" "db"
                ui = container "Web UI" "UI for the application." "React" "browser"
                api = container "API" "API to separate UI from application and route traffice to monolith or services." "" ""
                service1 = container "Service 1" "Service implementing a part of the monolith's behaviour."
                service1DB = container "Service 1 DB" "" "MySQL" "db"
                service2 = container "Service 2" "Service implementing a part of the monolith's behaviour."
                service2DB = container "Service 2 DB" "" "MySQL" "db"
            }
        }

        client -> ui
        ui -> api
        api -> monolith
        api -> service1
        api -> service2
        monolith -> db
        service1 -> service1DB
        service2 -> service2DB

        # Physical architecture of the 'live' system.
        deploymentEnvironment "Production" {
            deploymentNode "Client's Computer" "" "MS Windows, Apple macOS or Linux" {
                deploymentNode "Web Browser" "" "Chrome, Firefox, Safari or Edge" {
                    uiInstance = containerInstance ui
                }
            }

            deploymentNode "Application" "" "Application Data Centre" {
                deploymentNode "API Server" "" "" "" {
                    apiInstance = containerInstance api
                }
                
                deploymentNode "Monolith Server" "" "" "" {
                    monolithInstance = containerInstance monolith
                }
                
                deploymentNode "Monolith Database Server" "" "" {
                    monolithDBServer = deploymentNode "MySQL Server" "" "MySQL 8.0" {
                        dbInstance = containerInstance db
                    }
                }
                
                deploymentNode "Service 1" "" "" {
                    service1Server = deploymentNode "Service 1" "" "" {
                        service1Instance = containerInstance service1
                    }
                    service1DBServer = deploymentNode "MySQL Server" "" "MySQL 8.0" {
                        service1DBInstance = containerInstance service1DB
                    }
                }
                
                deploymentNode "Service 2" "" "" {
                    service2Server = deploymentNode "Service 2" "" "" {
                        service2Instance = containerInstance service2
                    }
                    service2DBServer = deploymentNode "MySQL Server" "" "MySQL 8.0" {
                        service2DBInstance = containerInstance service2DB
                    }
                }
            }
        }
    }

    views {
        systemContext application "context_diagram" {
            include *
            autoLayout lr
        }
        
        container application "container_diagram" {
            include *
#            autoLayout lr
        }

        deployment * "Production" "deployment_diagram" {
            include *
            autoLayout lr
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
            element failover {
                opacity 45
            }
        }

        themes default https://static.structurizr.com/themes/oracle-cloud-infrastructure-2021.04.30/theme.json
    }
    
}
