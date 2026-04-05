workspace "Microkernel Architecture" "An example microkernel architecture." {
    model {
        app = softwareSystem "Application" "Overall monolithic microkernel application." {
            core = container "Core System" "Delivers base/core functionality." "" "core"
            plugin1 = container "Plug-In 1" "Delivers one extension to the system." "" "plugin"
            plugin2 = container "Plug-In 2" "Delivers a second extension to the system" "" "plugin"
            plugin3 = container "Plug-In 3" "Delivers a third extension to the system" "" "plugin"
            domain1 = container "Domain 1" "One application domain." "" "core"
            domain2 = container "Domain 2" "A second application domain." "" "core"
            domain3 = container "Domain 3" "A third application domain." "" "core"
            restPlugin1 = container "External Plug-In 1" "Delivers one extension to the system." "" "plugin"
            restPlugin2 = container "External Plug-In 2" "Delivers a second extension to the system." "" "plugin"
            coreDB = container "Core System Database" "Core system data storage management." "" "db"
            plugin1DB = container "Plug-In 1 Database" "Plug-In 1 data storage management." "" "db"
            plugin2DB = container "Plug-In 2 Database" "Plug-In 2 data storage management." "" "db"
            adapterPlugin = container "Adapter Plug-In" "Adapts interface of third party service." "" "plugin"
        }
        
		distrib = softwareSystem "Distributed Microkernel" "Layered-distributed microkernel application." {
			presentation = container "Presentation" "User interaction layer." "" "core"
			business = container "Business" "Application logic layer." "" "core"
			persistence = container "Persistence" "Data storage management layer." "" "core"
			uiplugin1 = container "UI Plug-In 1" "Delivers one extension to the UI." "" "plugin"
			uiplugin2 = container "UI Plug-In 2" "Delivers a second extension to the UI." "" "plugin"
			appplugin1 = container "Plug-In 1" "Delivers one extension to the application logic." "" "plugin"
			appplugin2 = container "Plug-In 2" "Delivers a second extension to the application logic." "" "plugin"
		}

        domain = softwareSystem "Domain Partitioning" "Example of domain partitioning." {
            purch = container "Product Purchasing" "Enables customers to find and purchase products."
            cust = container "Customer Account Management" "Customers can manage their account details."
            fulfil = container "Product Fulfilment" "Manage processing and fulfilment of customer orders."
            mining = container "Data Mining" "Mine customer behaviour data to improve sales processes."
            inventory = container "Inventory Management" "Maintain inventory levels."
            reports = container "Reporting" "Generate reports on sales activities."
        }

        db = softwareSystem "Database" "Data storage management." "db"
        thirdParty = softwareSystem "Third Party Service" "Service provided by a third party, used as a plug-in." "plugin"

        # Microkernel Relationships
        core -> plugin1 "Plug-In Interface"
        core -> plugin2 "Plug-In Interface"
        domain1 -> plugin1 "Plug-In Interface 1"
        domain2 -> plugin2 "Plug-In Interface 1"
        domain3 -> plugin3 "Plug-In Interface 2"
        core -> restPlugin1 "REST"
        core -> restPlugin2 "REST"
        core -> coreDB
        plugin1 -> plugin1DB
        plugin2 -> plugin2DB
        core -> adapterPlugin "Plug-In Interface"
        adapterPlugin -> thirdParty
        
        # Domain Partitioning Relationships
        domain -> db
        purch -> db
        cust -> db
        fulfil -> db
        mining -> db
        inventory -> db
        reports -> db
        
        # Distributed Microkernel Relationships
        presentation -> uiplugin1 "UI Plug-In Interface"
        presentation -> uiplugin2 "UI Plug-In Interface"
        business -> appplugin1 "Business Logic Plug-In Interface"
        business -> appplugin2 "Business Logic Plug-In Interface"
        presentation -> business 
		business -> persistence
		persistence -> db

        deploymentEnvironment "Domain Partitioning" {
            deploymentNode "DBMS" "" "" "domain" {
                dbmsInstance = softwareSystemInstance db
            }

            deploymentNode "Application" "" "" "domain" {
                purchInstance = containerInstance purch
                custInstance = containerInstance cust
                fulfilInstance = containerInstance fulfil
                miningInstance = containerInstance mining
                inventoryInstance = containerInstance inventory
                reportsInstance = containerInstance reports
            }
        }

        deploymentEnvironment "Microkernel Domains" {
            deploymentNode "Application" {
                deploymentNode "Core System" {
                    domain1Instance = containerInstance domain1
                    domain2Instance = containerInstance domain2
                    domain3Instance = containerInstance domain3
                }

                deploymentNode "Plug-Ins" {
                    plugin1Instance = containerInstance plugin1
                    plugin2Instance = containerInstance plugin2
                    plugin3Instance = containerInstance plugin3
                }
            }
        }

        deploymentEnvironment "Distributed Microkernel" {
            deploymentNode "Frontend" {
                deploymentNode "Core System UI" {
                    presInstance = containerInstance presentation
                }

                uiplugin1Instance = containerInstance uiplugin1
                uiplugin2Instance = containerInstance uiplugin2
            }

            deploymentNode "Backend" {
                deploymentNode "Core System Logic" {
                    businessInstance = containerInstance business
                    persistInstance = containerInstance persistence
                }

                appplugin1Instance = containerInstance appplugin1
                appplugin2Instance = containerInstance appplugin2
            }

            deploymentNode "DB Server" {
                dbmsInstance2 = softwareSystemInstance db
            }
        }

        deploymentEnvironment "Microkernel REST Communication" {
            deploymentNode "Plug-In Service 1" {
                restPlugin1DistribInstance = containerInstance restPlugin1
            }

            deploymentNode "Plug-In Service 2" {
                restPlugin2Instance = containerInstance restPlugin2
            }

            deploymentNode "Core System" {
                coreDistribInstance = containerInstance core
            }
        }

        deploymentEnvironment "Microkernel Adapter Plug-In" {
            deploymentNode "Application" {
                coreAdaptInstance = containerInstance core
                plugin1AdaptInstance = containerInstance plugin1
                plugin2AdaptInstance = containerInstance plugin2
                adaptorInstance = containerInstance adapterPlugin
            }

            deploymentNode "External Service" {
                thirdPartyInstance = softwareSystemInstance thirdParty
            }
        }
    }

    views {
        container app "simple_microkernel" {
            include core plugin1 plugin2
#            autoLayout lr
        }

        container app "microkernel_dbs" {
            include core plugin1 plugin2 coreDB plugin1DB plugin2DB
#            autoLayout lr
        }

        deployment * "Domain Partitioning" "domain_partitioning" {
            include *
#            autoLayout tb
        }

        deployment * "Microkernel Domains" "microkernel_domain_partitioning" {
            include *
#            autoLayout tb
        }

        deployment * "Distributed Microkernel" "distributed_microkernel" {
            include *
#            autoLayout tb
        }

        deployment * "Microkernel REST Communication" "microkernel_rest" {
            include *
#            autoLayout tb
        }

        deployment * "Microkernel Adapter Plug-In" "microkernel_adapter" {
            include *
#            autoLayout lr
        }

        styles {
            element "Container" {
                shape RoundedBox
                background #c5d8fc
            }
            element core {
                background #b6d8fa
            }
            element plugin {
                background #b6faf7
            }
            element db {
                shape Cylinder
                background #01057a
                /* colour is text colour. */
                colour #ffffff
            }
        }
    }   
}
