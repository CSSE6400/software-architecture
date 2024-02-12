workspace "Layered Architecture" "An example layered architecture." {
    model {
        group "Monolith Example Architectures" {
    		monolith = softwareSystem "Monolith" "Simple monolithic application." {
    			app = container "Gardens of the Galaxy" "" "" "bus"
    		}
    		
            deploymentEnvironment "Monolith Deployment" {
                deploymentNode "Computer" {
                    appInstance = containerInstance app
                }
            }

    		layered_app = softwareSystem "Application" "Layered monolithic application." {
    			presentation = container "Presentation Layer" "User interaction layer." "" "pres"
    			business = container "Business Layer" "Application logic layer." "" "bus"
    			persistence = container "Persistence Layer" "Data storage management layer." "" "pers"
        		db = container "Database Layer" "Data storage mechanism." "" "db"
    		}
    
    		# Relationships
            presentation -> business 
    		business -> persistence
    		persistence -> db
    
            deploymentEnvironment "Layered Deployment" {
                deploymentNode "Layered Application" {
                    presentationInstance = containerInstance presentation
                    businessInstance = containerInstance business
                    persistenceInstance = containerInstance persistence
                }
    
                deploymentNode "DBMS" {
                    dbmsInstance = containerInstance db
                }
            }
        }
    }

    views {
        deployment * "Monolith Deployment" "monolith_deployment_diagram" {
            include *
            autoLayout tb
        }

        deployment * "Layered Deployment" "layered_deployment_diagram" {
            include *
#            autoLayout tb
        }

		container layered_app "simple_layered" {
			include *
#			autoLayout tb
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
