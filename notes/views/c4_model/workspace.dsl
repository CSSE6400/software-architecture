workspace {
    model {
        customer = person "Customer" "Someone who shops at the on-line store."
		
		enterpriseBoundary = group "Saraha eCommerce" {
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
				appServer = container "Application Backend" "Provides backend logic for the on-line store." "Java" {
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

        customer -> onlineStore "Search, browse and purchase products."
        customer -> webApp "Search, browse and purchase products." "HTTPS"
		customer -> browserApp "View product details and their 3d view."
        customer -> mobileApp "Search, browse and purchase products."
		
		webApp -> browserApp "Delivers content to the customer's browser." "HTTPS"
		webApp -> productAnimator "Downloads to customer's browser." "HTTPS"
		webApp -> appServer "Sends messages" "RMI"
		browsing -> cartView "Uses"
		browsing -> cart "Sends messages" "RMI"
		cartView -> cart "Sends messages" "RMI"
		
#		mobileApp -> appServer "REST API" "JSON/HTTPS"
		mobileApp -> cartController "REST API" "JSON/HTTPS"
		
		appServer -> appDB "Queries & Updates" "JPA"
		cart -> cust "Uses"
		cart -> order "Uses"
		cart -> product "Uses"
		cartController -> cart "Uses"
		order -> appDB "Stores order details" "JPA"
		cust -> appDB "Retrieves customer credentials" "JPA"
		product -> appDB "Retrieves product details" "JPA"
		
        onlineStore -> dataMining "Customer Browsing History"
        onlineStore -> dataMining "Get Product Suggestions"
        appServer -> dataMiningIntf "Customer Browsing History and Product Suggestions" "RMI"
        appServer -> dataMiningIntf "Get Product Suggestion" "RMI"
		dataMiningIntf -> dataWarehouse "Store Customer Browsing History" "JDBC"
		dataMiningIntf -> dataMiningProcess "Get Product Recommendations"
		dataMiningProcess -> dataWarehouse "Perform Data Mining" "JDBC"
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
		
		component appServer "appServer_component_diagram" {
			include *
#			autoLayout lr
		}
		
		component browserApp "browser_component_diagram" {
			include *
			autoLayout lr
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
		}

        theme default
    }
    
}
