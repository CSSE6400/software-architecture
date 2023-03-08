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
            globalDB = container "Shared DBMS" {
                sharedEntitiesSchema = component "Shared Entities Schema"
            }
            serv1 = container "Service 1" {
                sharedEntities1 = component "Shared Entities"
                s1Entities = component "Service 1 Entities"
            }
            serv2 = container "Service 2" {
                sharedEntities2 = component "Shared Entities"
                s2Entities = component "Service 2 Entities"
            }
            serv3 = container "Service 3" {
                sharedEntities3 = component "Shared Entities"
                s3Entities = component "Service 3 Entities"
            }
            serv4 = container "Service 4" {
                sharedEntities4 = component "Shared Entities"
                s4Entities = component "Service 4 Entities"
            }
            db1 = container "DBMS 1" {
                s1EntitiesSchema = component "Service 1 Entities Schema"
                s2EntitiesSchema = component "Service 2 Entities Schema"
            }
            db2 = container "DBMS 2" {
                s3EntitiesSchema = component "Service 3 Entities Schema"
            }
            db3 = container "DBMS 3" {
                s4EntitiesSchema = component "Service 4 Entities Schema"
            }
        }

        separateUIs = softwareSystem "Separate User Interfaces" "Example of having separate user interfaces using the APIs." {
            admin = container "Admin Interface" "Delivers the user interface for admin functionality." "" "ui" {
                adminUI = component "Admin User Interface" "" "" "ui"
            }
            web = container "Web Interface" "Delivers a web interface for users." "" "ui" {
                webUI = component "Web  User Interface" "" "" "ui"
            }
            mobile = container "Mobile Interface" "Delivers a mobile interface for users." "" "ui" {
                mobileUI = component "Mobile User Interface" "" "" "ui"
            }
            adminService = container "Admin Service" "" "" "service3" {
                adminFacade = component "Admin API Façade" "" "" "facade"
            }
            service1UI = container "Service 1" "" "" "service1" {
                facadeUI1 = component "API Façade 1" "" "" "facade"
            }
            service2UI = container "Service 2" "" "" "service2" {
                facadeUI2 = component "API Façade 2" "" "" "facade"
            }
        }

        apiLayers = softwareSystem "API Layer Example" "Example of an API layer to hide system's internal structure." {
            externalUI = container "User Interface" "" "" "ui" {
                exUiComp = component "User Interface Component" "" "" "ui"
            }
            apiLayer = container "API Layer" "Delivers a web interface for users." "" "ui" {
                apiFacade1 = component "API Façade 1" "" "" "facade"
                apiFacade2 = component "API Façade 2" "" "" "facade"
                apiFacade3 = component "API Façade 3" "" "" "facade"
                routing = component "Routing"
            }
            apilServ1 = container "Service 1" "" "" "service1" {
                s1Facade = component "Service API Façade 1" "" "" "facade"
            }
            apilServ2 = container "Service 2" "" "" "service2" {
                s2Facade = component "Service API Façade 2" "" "" "facade"
            }
            apilServ3 = container "Service 3" "" "" "service3" {
                s3Facade = component "Service API Façade 3" "" "" "facade"
            }
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
        sharedEntities1 -> sharedEntitiesSchema
        sharedEntities2 -> sharedEntitiesSchema
        sharedEntities3 -> sharedEntitiesSchema
        sharedEntities4 -> sharedEntitiesSchema
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
        exUiComp -> apiFacade1
        exUiComp -> apiFacade2
        exUiComp -> apiFacade3
        apiFacade1 -> routing
        apiFacade2 -> routing
        apiFacade3 -> routing
        routing -> s1Facade
        routing -> s2Facade
        routing -> s3Facade

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

        component serv1 "sep_db_service1_component" {
            include *
            autoLayout tb
        }

        component serv2 "sep_db_service2_component" {
            include *
            autoLayout tb
        }

        component serv3 "sep_db_service3_component" {
            include *
            autoLayout tb
        }

        component serv4 "sep_db_service4_component" {
            include *
            autoLayout tb
        }

        component globalDB "sep_db_global_db_component" {
            include *
#            autoLayout tb
        }

        container separateDBs "sep_dbs_context" {
            include *
#            autoLayout tb
        }

        container separateUIs "sep_uis_context" {
            include *
#            autoLayout tb
        }

        container apiLayers "api_layer_context" {
            include *
#            autoLayout tb
        }

        component apiLayer "api_layer_component" {
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
            element shared {
                background #eee8fa
            }
            element invoicing {
                background #edf5f0
            }
            element ui {
                background #fadee0
            }
        }
    }   
}
