workspace "Service-Based Architecture" "Structures of service-based architectural styles." {
    model {
        sbaBasic = softwareSystem "Basic Service-Based Architecture" "Basic / simple structure of a service-based architecture." {
            ui = container "User Interface" "Delivers the system's user interface." "" "ui" {
                uiComp1 = component "User Interface Component 1" "One part of the user interface." "" "ui"
                uiComp2 = component "User Interface Component 2" "Another part of the user interface." "" "ui"
            }
            facade1 = container "API Façade 1" "" "" "facade"
            char1 = container "Characteristic 1" "" "" "service1"
            char2 = container "Characteristic 2" "" "" "service1"
            facade2 = container "API Façade 2" "" "" "facade"
            char3 = container "Characteristic 3" "" "" "service2"
            char4 = container "Characteristic 4" "" "" "service2"
            facade3 = container "API Façade 3" "" "" "facade"
            char5 = container "Characteristic 5" "" "" "service3"
            char6 = container "Characteristic 6" "" "" "service3"
            db = container "Database" "Application's database." "" "db"
        }

        partitioning = softwareSystem "Partitioning Examples" "Examples of technical and domain partitioning." {
            apiFacade = container "API Façade Layer"
            business = container "Business Layer"
            persistence = container "Persistence Layer"
            purchApiFacade = container "Purchasing API Façade"
            checkout = container "Checkout"
            payment = container "Payment"
            inventory = container "Inventory Adjustment"
        }

        dbPartitioning = softwareSystem "Database Partitioning Example" "Example of services using shared and separate database resources." {
            shared1 = container "Shared Entities" "Persistent entities that are shared between services." "" "shared"
            invoicing = container "Invoicing Entities" "Invoicing entities that are unique to Service 2." "" "invoicing"
            sharedSchema = container "Shared Entities Schema" "" "" "shared"
            invoicingSchema = container "Invoicing Entities Schema" "" "" "invoicing"
        }
        
        separateDBs = softwareSystem "Separate Databases Example" "Example of having separate databases for each service." {
            sharedEntitiesSchema = container "Shared Entities Schema" "" "" "shared"
            sharedEntities = container "Shared Entities" "Persistent entities that are shared between services." "" "shared"
            s1Entities = container "Service 1 Entities" "Entities that are unique to Service 1." "" "service1"
            s2Entities = container "Service 2 Entities" "Entities that are unique to Service 2." "" "service2"
            s3Entities = container "Service 3 Entities" "Entities that are unique to Service 3." "" "service3"
            s4Entities = container "Service 4 Entities" "Entities that are unique to Service 4." "" "service4"
            s1EntitiesSchema = container "Service 1 Entities Schema" "" "" "service1"
            s2EntitiesSchema = container "Service 2 Entities Schema" "" "" "service2"
            s3EntitiesSchema = container "Service 3 Entities Schema" "" "" "service3"
            s4EntitiesSchema = container "Service 4 Entities Schema" "" "" "service4"
        }

        separateUIs = softwareSystem "Separate User Interfaces" "Example of having separate user interfaces using the APIs." {
            adminUI = container "Admin User Interface" "Delivers the user interface for admin functionality." "" "ui"
            webUI = container "Web  User Interface" "Delivers a web interface for users." "" "ui"
            mobileUI = container "Mobile User Interface" "Delivers a mobile interface for users." "" "ui,mobile"
            adminFacade = container "Admin API Façade" "" "" "facade"
            facadeUI1 = container "API Façade 1" "" "" "facade"
            facadeUI2 = container "API Façade 2" "" "" "facade"
        }

        apiLayers = softwareSystem "API Layer Example" "Example of an API layer to hide system's internal structure." {
            externalUI = container "User Interface" "" "" "ui"
            apiFacade1 = container "API Façade 1" "" "" "apiLayer"
            apiFacade2 = container "API Façade 2" "" "" "apiLayer"
            apiFacade3 = container "API Façade 3" "" "" "apiLayer"
            routing = container "Routing" "" "" "apiLayer"
            s1Facade = container "Service API Façade 1" "" "" "facade"
            s2Facade = container "Service API Façade 2" "" "" "facade"
            s3Facade = container "Service API Façade 3" "" "" "facade"
        }

        # Basic Service-Based Relationships
        ui -> facade1 "Service 1 API"
        ui -> facade2 "Service 2 API"
        ui -> facade3 "Service 3 API"
        facade1 -> char1
        facade1 -> char2
        facade2 -> char3
        facade2 -> char4
        facade3 -> char5
        facade3 -> char6
        char1 -> db "Store & Retrieve"
        char2 -> db "Store & Retrieve"
        char3 -> db "Store & Retrieve"
        char4 -> db "Store & Retrieve"
        char5 -> db "Store & Retrieve"
        char6 -> db "Store & Retrieve"

        # Technical & Domain Partitioning Relationships
        apiFacade -> business
        business -> persistence
        purchApiFacade -> checkout
        purchApiFacade -> payment
        purchApiFacade -> inventory

        # Shared DB Relationships
        shared1 -> sharedSchema
        invoicing -> invoicingSchema

        # Separate DBs Relationships
        sharedEntities -> sharedEntitiesSchema
        s1Entities -> s1EntitiesSchema
        s2Entities -> s2EntitiesSchema
        s3Entities -> s3EntitiesSchema
        s4Entities -> s4EntitiesSchema

        # Separate UIs Relationships
        adminUI -> adminFacade "Admin Service API"
        webUI -> facadeUI1 "Service 1 API"
        webUI -> facadeUI2 "Service 2 API"
        mobileUI -> facadeUI1 "Service 1 API"
        mobileUI -> facadeUI2 "Service 2 API"

        # API Layer Relationships
        externalUI -> apiFacade1 "API1"
        externalUI -> apiFacade2 "API2"
        externalUI -> apiFacade3 "API3"
        apiFacade1 -> routing
        apiFacade2 -> routing
        apiFacade3 -> routing
        routing -> s1Facade "Service 1 API"
        routing -> s2Facade "Service 2 API"
        routing -> s3Facade "Service 3 API"

        deploymentEnvironment "Basic Service-Based Structure" {
            deploymentNode "User Interface" {
                uiInstance = containerInstance ui
            }
            deploymentNode "Service 1" {
                facade1Instance = containerInstance facade1
                characteristc1Instance = containerInstance char1
                characteristc2Instance = containerInstance char2
            }
            deploymentNode "Service 2" {
                facade2Instance = containerInstance facade2
                characteristc3Instance = containerInstance char3
                characteristc4Instance = containerInstance char4
            }
            deploymentNode "Service 3" {
                facade3Instance = containerInstance facade3
                characteristc5Instance = containerInstance char5
                characteristc6Instance = containerInstance char6
            }
            deploymentNode "Database Server" {
                deploymentNode "DBMS" {
                    dbInstance = containerInstance db
                }
            }
        }

        deploymentEnvironment "Technical or Domain Partitioning" {
            deploymentNode "Technical Partitioning" "Example of a service domain using technical partitioning internally." {
                apiFacadeInstance = containerInstance apiFacade
                businessInstance = containerInstance business
                persistenceInstance = containerInstance persistence
            }
            deploymentNode "Domain Partitioning" "Example of a service domain using domain partitioning internally." {
                purchApiFacadeInstance = containerInstance purchApiFacade
                checkoutInstance = containerInstance checkout
                paymentInstance = containerInstance payment
                inventoryInstance = containerInstance inventory
            }
        }

        deploymentEnvironment "Shared Entities" {
            deploymentNode "Service 1" {
                shared1aInstance = containerInstance shared1
            }
            deploymentNode "Service 2" {
                shared1bInstance = containerInstance shared1
                invoicingInstance = containerInstance invoicing
            }
            deploymentNode "Database Server" {
                deploymentNode "DBMS" {
                    sharedSchemaInstance = containerInstance sharedSchema
                    invoicingSchemaInstance = containerInstance invoicingSchema
                }
            }
        }

        deploymentEnvironment "Separate Databases" {
            deploymentNode "Server 1" {
                deploymentNode "Service 1" {
                    shared1mInstance = containerInstance sharedEntities
                    s1EntitiesInstance = containerInstance s1Entities
                }
            }
            deploymentNode "Server 2" {
                deploymentNode "Service 2" {
                    shared1nInstance = containerInstance sharedEntities
                    s2EntitiesInstance = containerInstance s2Entities
                }
            }
            deploymentNode "Server 3" {
                deploymentNode "Service 3" {
                    shared1oInstance = containerInstance sharedEntities
                    s3EntitiesInstance = containerInstance s3Entities
                }
            }
            deploymentNode "Server 4" {
                deploymentNode "Service 4" {
                    shared1pInstance = containerInstance sharedEntities
                    s4EntitiesInstance = containerInstance s4Entities
                }
                deploymentNode "DBMS 3" {
                    s4EntitiesSchemaInstance = containerInstance s4EntitiesSchema
                }
            }
            deploymentNode "Shared Database Server" {
                deploymentNode "Shared DBMS" {
                    sharedEntitiesSchemaInstance = containerInstance sharedEntitiesSchema
                }
            }
            deploymentNode "Database Server 1" {
                deploymentNode "DBMS 1" {
                    s1EntitiesSchemaInstance = containerInstance s1EntitiesSchema
                    s2EntitiesSchemaInstance = containerInstance s2EntitiesSchema
                }
            }
            deploymentNode "Database Server 2" {
                deploymentNode "DBMS 2" {
                    s3EntitiesSchemaInstance = containerInstance s3EntitiesSchema
                }
            }
        }

        deploymentEnvironment "Separate User Interfaces" {
            deploymentNode "Admin UI Platform" {
                adminUIInstance = containerInstance adminUI
            }
            deploymentNode "Web Server" {
                webUIInstance = containerInstance webUI
            }
            deploymentNode "Mobile Device" {
                mobileUIInstance = containerInstance mobileUI
            }
            deploymentNode "Admin Service" {
                adminFacadeInstance = containerInstance adminFacade
            }
            deploymentNode "Service 1" {
                facadeUI1Instance = containerInstance facadeUI1
            }
            deploymentNode "Service 2" {
                facadeUI2Instance = containerInstance facadeUI2
            }
        }

        deploymentEnvironment "API Layer" {
            deploymentNode "UI Platform" {
                externalUIInstance = containerInstance externalUI
            }
            deploymentNode "API Layer" {
                apiFacade1Instance = containerInstance apiFacade1
                apiFacade2Instance = containerInstance apiFacade2
                apiFacade3Instance = containerInstance apiFacade3
                routingInstance = containerInstance routing
            }
            deploymentNode "Service 1" {
                s1FacadeInstance = containerInstance s1Facade
            }
            deploymentNode "Service 2" {
                s2FacadeInstance = containerInstance s2Facade
            }
            deploymentNode "Service 3" {
                s3FacadeInstance = containerInstance s3Facade
            }
        }
    }

    views {
        container sbaBasic "basic_sba" {
            include *
            autoLayout tb
        }

        deployment * "Basic Service-Based Structure" "basic_deploy" {
            include *
#            autoLayout tb
        }

        deployment * "Technical or Domain Partitioning" "partitioning_deploy" {
            include *
#            autoLayout tb
        }

        deployment * "Shared Entities" "shared_entities_deploy" {
            include *
#            autoLayout tb
        }

        deployment * "Separate Databases" "sep_dbs_deploy" {
            include *
#            autoLayout tb
        }

        deployment * "Separate User Interfaces" "sep_uis_deploy" {
            include *
#            autoLayout tb
        }

        deployment * "API Layer" "api_layer_deploy" {
            include *
#            autoLayout tb
        }

        styles {
            element "Component" {
                shape Component
                background #c5d8fc
            }
            element "Container" {
                shape RoundedBox
                background #c5d8fc
            }
            element db {
                shape Cylinder
                background #01057a
                /* colour is text colour. */
                colour #ffffff
            }
            # Service Styles
            element facade {
                background #f7e8c8
            }
            element service1 {
                background #e6f7c8
            }
            element service2 {
                background #d2fae7
            }
            element service3 {
                background #deecfa
            }
            element service4 {
                background #f7f7eb
            }
            element shared {
                background #eee8fa
            }
            element invoicing {
                background #edf5f0
            }
            element apiLayer {
                background #fcf0e6
            }
            element ui {
                background #fadee0
            }
            element mobile {
                shape MobileDevicePortrait
            }
        }
    }   
}
