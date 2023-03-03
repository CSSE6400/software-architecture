workspace "Layered Architecture" "An example layered architecture." {
    model {
		app = softwareSystem "Application" "Layered monolithic application." {
			presentation = container "Presentation Layer" "User interaction layer." "" "pres"
			business = container "Business Layer" "Application logic layer." "" "bus"
			persistence = container "Persistence Layer" "Data storage management layer." "" "pers"
    		db = container "Database Layer" "Data storage mechanism." "" "db"
		}

		# Relationships
        presentation -> business 
		business -> persistence
		persistence -> db

        deploymentEnvironment "Deployment" {
            deploymentNode "Application" {
                presentationInstance = containerInstance presentation
                businessInstance = containerInstance business
                persistenceInstance = containerInstance persistence
            }

            deploymentNode "DBMS" {
                dbmsInstance = containerInstance db
            }
        }
    }

    views {
        deployment * "Deployment" "deployment_diagram" {
            include *
#            autoLayout tb
        }

		container app "simple_layered" {
			include *
			autoLayout tb
		}

		styles {
			element "Container" {
			    shape RoundedBox
			}
			element pres {
				background #ebf1fc
				/* colour is text colour. */
				colour #000000
			}
			element bus {
				background #c5d8fc
				/* colour is text colour. */
				colour #000000
			}
			element pers {
				background #a2c1fc
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
