workspace "Sahara eCommerce" "An example C4 model of an on-line shopping system." {
    model {
        customer = person "Customer" "Someone who shops at the Sahara on-line store."
		
		# Software systems, containers and components for the Sahara eCommerce enterprise-wide system.
		enterprise "Sahara eCommerce" {
			onlineStore = softwareSystem "On-line Store" "Allows customers to browse and search for items and to order them." {
				!docs docs
				!adrs adrs
				webApp = container "Web Application" "Delivers the web front-end for the on-line store." "J2EE Server" {
#					signIn = component "Sign In" "Allows customers to sign into the on-line store. Also provides customer registration." "JSF"
#					acctMgt = component "Account Management" "Allows customers to manage their account." "JSF"
					browsing = component "Product Browsing" "Customers can search and browse for products, and add them to their shopping cart." "JSF"
					cartView = component "Shopping Cart View" "Customers can view the contents of their shopping cart and checkout." "JSF"
				}
				browserApp = container "Interactive Web Pages" "Provides the environment in which customers can view products" "JSF & JavaScript" "browser" {
					productAnimator = component "Product Animator" "Provides interactive 3d views of products." "JavaScript"
				}
				appBackend = container "Application Backend" "Provides backend logic for the on-line store." "Java" {
					cart = component "Shopping Cart" "Holds products that customer may purchase." "JavaBean"
					cust = component "Customer" "Details about a customer." "JavaBean"
					order = component "Order" "Record of completed orders." "JavaBean"
					product = component "Product" "Details about a product." "JavaBean"
					cartController = component "Shopping Cart Controller" "Provides RESTful interface to use a Shopping Cart." "Java Control Class"
				}
				appDB = container "Application Database" "Stores customer credentials, products and orders." "MySQL" "db"
				mobileApp = container "Mobile Application" "Mobile apps on iPhone and Android providing shopping experience." "React Native" "mobile"
			}
			dataMining = softwareSystem "Data Mining Service" "Collects customer visit data and provides product recommendations." "ancillary" {
				dataMiningProcess = container "Data Mining Process" "Performs data mining on collected data." "Java"
				dataMiningIntf = container "Data Mining Interface" "Provides interface to save data to be mined and retrieve mining results." "Java"
				dataWarehouse = container "Data Warehouse" "Stores customer browsing and transaction history." "Oracle" "db"
			}
		}

		# Customer usage relationships.
        customer -> onlineStore "Search, browse and purchase products."
        customer -> webApp "Search, browse and purchase products." "HTTPS"
		customer -> browserApp "View product details and their 3d view."
        customer -> mobileApp "Search, browse and purchase products."
		
		# Web App relationships.
		webApp -> browserApp "Delivers content to the customer's browser." "HTTPS"
		webApp -> productAnimator "Downloads to customer's browser." "HTTPS"
		webApp -> appBackend "Sends messages" "RMI"
		browsing -> cartView "Uses"
		browsing -> cart "Sends messages" "RMI"
		cartView -> cart "Sends messages" "RMI"
		
		mobileApp -> cartController "REST API" "JSON/HTTPS"
		
		# Application backend relationships.
		appBackend -> appDB "Queries & Updates" "JPA"
		cart -> cust "Uses"
		cart -> order "Uses"
		cart -> product "Uses"
		cartController -> cart "Uses"
		order -> appDB "Stores order details" "JPA"
		cust -> appDB "Retrieves customer credentials" "JPA"
		product -> appDB "Retrieves product details" "JPA"
		
		# Data Mining Service relationships.
        onlineStore -> dataMining "Customer Browsing History"
        onlineStore -> dataMining "Get Product Suggestions"
        appBackend -> dataMiningIntf "Customer Browsing History and Product Suggestions" "RMI"
        appBackend -> dataMiningIntf "Get Product Suggestion" "RMI"
		dataMiningIntf -> dataWarehouse "Store Customer Browsing History" "JDBC"
		dataMiningIntf -> dataMiningProcess "Get Product Recommendations"
		dataMiningProcess -> dataWarehouse "Perform Data Mining" "JDBC"

		# Physical architecture of the 'live' system.
		deploymentEnvironment "Live" {
            deploymentNode "Customer's Mobile Device" "" "Apple iOS or Android" {
                liveMobileAppInstance = containerInstance mobileApp
            }

            deploymentNode "Customer's Computer" "" "MS Windows, Apple macOS or Linux" {
                deploymentNode "Web Browser" "" "Chrome, Firefox, Safari or Edge" {
                    liveInteractiveWebPagesInstance = containerInstance browserApp
                }
            }

            deploymentNode "Sahara" "" "Sahara eCommerce Data Centre" {
                deploymentNode "Web Server" "" "Ubuntu 20.04 LTS" "" 4 {
                    deploymentNode "Apache TomEE" "" "Apache TomEE 8.0" {
                        liveWebAppInstance = containerInstance webApp
                    }
                }
				
                deploymentNode "Application Server" "" "Ubuntu 20.04 LTS & Java 17 LTS" "" 8 {
                    liveAppServerInstance = containerInstance appBackend
                }

                deploymentNode "Application Database Server" "" "Ubuntu 20.04 LTS" {
                    primaryDatabaseServer = deploymentNode "MySQL Primary" "" "MySQL 8.0" {
                        liveAppDatabaseInstance = containerInstance appDB
                    }
                }

                deploymentNode "Secondary Database Server" "" "Ubuntu 20.04 LTS" "failover" {
                    secondaryDatabaseServer = deploymentNode "MySQL Secondary" "" "MySQL 8.0" "failover" {
                        liveSeondaryDatabaseInstance = containerInstance appDB
                    }
                }
				
				primaryDatabaseServer -> secondaryDatabaseServer "Replicates Data"
            }
			
            deploymentNode "Data Mining Service" "" "Oracle Cloud Infrastructure" "Oracle Cloud Infrastructure - Cloud Service" {
                deploymentNode "Data Mining API" "" "" "Oracle Cloud Infrastructure - Virtual Machine" {
                    liveDataMiningIntfInstance = containerInstance dataMiningIntf
                }
				
                deploymentNode "Machine Learning Process" "" "" "Oracle Cloud Infrastructure - Oracle Machine Learning" {
                    liveDataMiningProcessInstance = containerInstance dataMiningProcess
                }
				
                deploymentNode "Data Warehouse" "" "" "Oracle Cloud Infrastructure - Autonomous Data Warehouse Cloud Service" {
                    liveDataWarehouseInstance = containerInstance dataWarehouse
				}
			}
        }
    }

    views {
        systemContext onlineStore "context_diagram" {
            include *
#			autoLayout lr
        }
		
		container onlineStore "store_container_diagram" {
			include *
#			autoLayout lr
		}
		
		container dataMining "dataMining_container_diagram" {
			include *
#			autoLayout lr
		}
		
		component webApp "webApp_component_diagram" {
			include *
#			autoLayout lr
		}
		
		component appBackend "appBackend_component_diagram" {
			include *
#			autoLayout lr
		}
		
		component browserApp "browser_component_diagram" {
			include *
			autoLayout lr
		}

        dynamic appBackend "add_to_cart" "Overview of how a customer using the web interface adds a product to their shopping cart." {
            browsing -> cart "Sends product id to be added to cart id" "RMI"
            cart -> appDB "select * from carts where cartid = ?" "JPA"
            cart -> appDB "select * from products where productid = ?" "JPA"
            cart -> appDB "insert into cartProducts values (cartId, productId)" "JPA"
            cart -> browsing "Confirms success of updating cart" "RMI"
#            autoLayout lr
        }
		
		deployment * "Live" "live_deployment_diagram" {
			include *
#			autoLayout lr
		}

		styles {
			element ancillary {
				background #f2c679
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
