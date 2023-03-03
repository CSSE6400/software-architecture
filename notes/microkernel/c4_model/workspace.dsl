workspace "Microkernel Architecture" "An example microkernel architecture." {
    model {
		app = softwareSystem "Application" "Overall monolithic application." {
			core = container "Core System" "Delivers base/core functionality." "" "core" {
#				event = component "Activity Event" "source" "" "source"
			}
			plugin1 = container "Plug-In 1" "Delivers one extension to the system." "" "plugin" {
			}
			plugin2 = container "Plug-In 2" "Delivers a second extension to the system" "" "plugin" {
			}
		}

		domain = softwareSystem "Domain Partitioning" "Example of domain partitioning." {
			purch = container "Product Purchasing" "Delivers base/core functionality." "" "core" {
#				event = component "Activity Event" "source" "" "source"
			}
			cust = container "Customer Account Management" "Delivers one extension to the system." "" "plugin" {
			}
			fulfil = container "Product Fulfilment" "Delivers a second extension to the system" "" "plugin" {
			}
			mining = container "Data Mining" "Delivers a second extension to the system" "" "plugin" {
			}
			inventory = container "Inventory Management" "Delivers a second extension to the system" "" "plugin" {
			}
			reports = container "Reporting" "Delivers a second extension to the system" "" "plugin" {
			}
		}

		db = softwareSystem "Database" "Delivers a second extension to the system" "db"

		# Microkernel Relationships
        core -> plugin1 "Plug-In Interface"
		core -> plugin2 "Plug-In Interface"
		
		# Domain Partitioning Relationships
		domain -> db
		purch -> db
		cust -> db
		fulfil -> db
		mining -> db
		inventory -> db
		reports -> db

        deploymentEnvironment "Deployment" {
            deploymentNode "DBMS" {
                dbmsInstance = softwareSystemInstance  db
            }

            deploymentNode "Application" {
                purchInstance = containerInstance purch
                custInstance = containerInstance cust
                fulfilInstance = containerInstance fulfil
                miningInstance = containerInstance mining
                inventoryInstance = containerInstance inventory
                reportsInstance = containerInstance reports
            }
        }
    }

    views {
		container app "simple_microkernel" {
			include *
#			autoLayout lr
		}

        deployment * "Deployment" "deployment_diagram" {
            include *
#            autoLayout tb
        }

		styles {
			element "Container" {
			    shape RoundedBox
			}
			element core {
				background #b6d8fa
				/* colour is text colour. */
				colour #000000
			}
			element plugin {
				background #b6faf7
				/* colour is text colour. */
				colour #000000
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
