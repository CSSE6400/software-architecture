# Downloaded from structurizr workspace.
workspace "Sahara eCommerce" "An example Service-Based Architecture." {
    model {
        # Actors
        customer = person "Customer" "Someone who shops at the Sahara on-line store."
        orderPersonnel = person "Order Personnel" "Manages inventory and ordering products."
        # External Systems
        paymentProvider = softwareSystem "Payment Provider" "External service providing payment facilities." "external"
        
        # Sahara eCommerce enterprise-wide system.
        # Software systems, containers and components.
        enterprise "Sahara eCommerce" {
            onlineStore = softwareSystem "On-line Store" "Allows customers to browse and search for items and to order them." {
                !docs docs
                !adrs adrs
                inventoryApp = container "Inventory Application" "Interface to manage inventory." "React" "browser" {
                }
                webApp = container "Web Application" "Delivers the web front-end for the on-line store." "J2EE Server" {
#                    signIn = component "Sign In" "Allows customers to sign into the on-line store. Also provides customer registration." "JSF"
#                    acctMgt = component "Account Management" "Allows customers to manage their account." "JSF"
                    browsing = component "Product Browsing" "Customers can search and browse for products, and add them to their shopping cart." "JSF"
                    cartView = component "Shopping Cart View" "Customers can view the contents of their shopping cart and checkout." "JSF"
                }
                browserApp = container "Interactive Web Pages" "Provides the environment in which customers can view products" "JSF & JavaScript" "browser" {
                    productAnimator = component "Product Animator" "Provides interactive 3d views of products." "JavaScript"
                }
                productBrowsing = container "Product Browsing" "Provides backend logic for browsing or searching for products." "Java" {
                    browsingFacade = component "Product Browsing Façade" "Provides interface to retrieve product information based on search criteria" "JSF"
                    search = component "Search for Product" "Finds products based on search criteria." "Java"
                    browse = component "Browse for Product" "Finds products based on user navigation." "Java"
                    suggest = component "Suggest Products" "Suggest products user may be interested in." "Java"
                    cartMgt = component "Shopping Cart Management" "Add and remove items from user's shopping cart." "Java"
                }
                productPurchasing = container "Product Purchasing" "Provides backend logic for purchasing products." "Java" {
                    cartController = component "Shopping Cart Controller" "Provides RESTful interface to use a Shopping Cart." "Java Control Class"
                }
                productFulfilment = container "Product Fulfilment" "Provides backend logic for fulfilling orders." "Java" {
                }
                custAcctMgt = container "Customer Account Management" "Provides backend logic for managing customer accounts." "Java" {
                }
                inventoryMgt = container "Inventory Management" "Provides backend logic for managing inventory." "Java" {
                }
                appDB = container "Application Database" "Stores customer credentials, products and orders." "MySQL" "db" {
                    cust = component "Customer" "Details about a customer." "SQL"
                    product = component "Product" "Details about a product." "SQL"
                    cart = component "Shopping Cart" "Holds products that customer may purchase." "SQL"
                    order = component "Order" "Record of completed orders." "SQL"
                }
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
        
        orderPersonnel -> inventoryApp "Monitor inventory and order new stock."
        inventoryApp -> inventoryMgt "Retrieve Stock Levels and Order New Stock" "REST API JSON/HTTPS"
        inventoryApp -> productFulfilment "View Order Details" "REST API JSON/HTTPS"
        
        productPurchasing -> paymentProvider "Process payment."  "REST API JSON/HTTPS"
        
        # Web App relationships.
        webApp -> browserApp "Delivers content to the customer's browser." "HTTPS"
        webApp -> productAnimator "Downloads to customer's browser." "HTTPS"
        webApp -> productPurchasing "Send Purchase Request" "RMI"
        webApp -> productFulfilment "Query Order Status" "RMI"
        webApp -> custAcctMgt "CRUD Customer Account" "RMI"
        browsing -> cartView "Uses"
        browsing -> browsingFacade "Find & Retrieve Product Details" "RMI"

# Hidden to simplify diagram.
#        mobileApp -> productBrowsing "Retrieve Product Details" "REST API JSON/HTTPS"
#        mobileApp -> productPurchasing "Send Purchase Request" "REST API JSON/HTTPS"
#        mobileApp -> productFulfilment "Query Order Status" "REST API JSON/HTTPS"
#        mobileApp -> custAcctMgt "CRUD Customer Account" "REST API JSON/HTTPS"
        
        # Product Browsing relationships.
        browsingFacade -> search "Uses"
        browsingFacade -> browse "Uses"
        browsingFacade -> suggest "Uses"
        browsingFacade -> cartMgt "Uses"
        search -> product "Finds Product" "JPA"
        browse -> product "Finds Product" "JPA"
        cartMgt -> cart "Updates Cart" "JPA"
        search -> dataMiningIntf "Customer Browsing History" "REST API JSON/HTTPS"
        browse -> dataMiningIntf "Customer Browsing History" "REST API JSON/HTTPS"
        suggest -> dataMiningIntf "Get Product Suggestions" "REST API JSON/HTTPS"
        cartMgt -> dataMiningIntf "Record Cart Updates" "REST API JSON/HTTPS"

        # Application backend relationships.
        productPurchasing -> appDB "Queries & Updates" "JPA"
        productPurchasing -> dataMiningIntf "Customer Purchase History" "REST API JSON/HTTPS"
        productFulfilment -> appDB "Queries" "JPA"
        custAcctMgt -> appDB "Queries & Updates" "JPA"
        inventoryMgt -> appDB "Queries & Updates" "JPA"
        cartController -> cart "Updates" "JPA"

        # Data Mining Service relationships.
        onlineStore -> dataMining "Customer Browsing History"
        onlineStore -> dataMining "Get Product Suggestions"
        dataMiningIntf -> dataWarehouse "Store Customer Browsing History" "JDBC"
        dataMiningIntf -> dataMiningProcess "Get Product Recommendations"
        dataMiningProcess -> dataWarehouse "Perform Data Mining" "JDBC"

        # Physical architecture of the 'live' system.
        deploymentEnvironment "Live" {
            deploymentNode "Customer's Mobile Device" "" "Apple iOS or Android" {
                liveMobileAppInstance = containerInstance mobileApp
            }

            deploymentNode "Order Personnel Computer" "" "MS Windows, Apple macOS or Linux" {
                deploymentNode "Web Browser" "" "Chrome, Firefox, Safari or Edge" {
                    liveInventoryMgtInstance = containerInstance inventoryApp
                }
            }

            deploymentNode "Customer's Computer" "" "MS Windows, Apple macOS or Linux" {
                deploymentNode "Web Browser" "" "Chrome, Firefox, Safari or Edge" {
                    liveInteractiveWebPagesInstance = containerInstance browserApp
                }
            }

            deploymentNode "Sahara" "" "Sahara eCommerce Data Centre" {
                deploymentNode "Web Server" "" "Ubuntu 20.04 LTS" "" {
                    deploymentNode "Apache TomEE" "" "Apache TomEE 8.0" {
                        liveWebAppInstance = containerInstance webApp
                    }
                }
                
                deploymentNode "Product Browsing Server" "" "Ubuntu 20.04 LTS & Java 17 LTS" "" {
                    liveBrowsingServerInstance = containerInstance productBrowsing
                }
                
                deploymentNode "Product Purchasing Server" "" "Ubuntu 20.04 LTS & Java 17 LTS" "" {
                    livePurchasingServerInstance = containerInstance productPurchasing
                }
                
                deploymentNode "Product Fulfilment Server" "" "Ubuntu 20.04 LTS & Java 17 LTS" "" {
                    liveFulfilmentServerInstance = containerInstance productFulfilment
                }
                
                deploymentNode "Customer Account Server" "" "Ubuntu 20.04 LTS & Java 17 LTS" "" {
                    liveAcctServerInstance = containerInstance custAcctMgt
                }
                
                deploymentNode "Inventory Management Server" "" "Ubuntu 20.04 LTS & Java 17 LTS" "" {
                    liveInventoryServerInstance = containerInstance inventoryMgt
                }

                deploymentNode "Application Database Server" "" "Ubuntu 20.04 LTS" {
                    primaryDatabaseServer = deploymentNode "MySQL Primary" "" "MySQL 8.0" {
                        liveAppDatabaseInstance = containerInstance appDB
                    }
                }

# Hidden to simplify diagram.
#                deploymentNode "Secondary Database Server" "" "Ubuntu 20.04 LTS" "failover" {
#                    secondaryDatabaseServer = deploymentNode "MySQL Secondary" "" "MySQL 8.0" "failover" {
#                        liveSeondaryDatabaseInstance = containerInstance appDB
#                    }
#                }
                
#                primaryDatabaseServer -> secondaryDatabaseServer "Replicates Data"
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
#            autoLayout lr
        }
        
        container onlineStore "store_container_diagram" {
            include *
#            autoLayout lr
        }
        
        container dataMining "dataMining_container_diagram" {
            include *
#            autoLayout lr
        }
        
        component webApp "webApp_component_diagram" {
            include *
#            autoLayout lr
        }
        
        component productBrowsing "appBackend_component_diagram" {
            include *
#            autoLayout lr
        }
        
        component browserApp "browser_component_diagram" {
            include *
            autoLayout lr
        }

        dynamic productBrowsing "add_to_cart" "Overview of how a customer using the web interface adds a product to their shopping cart." {
            browsing -> browsingFacade "Sends product id to be added to cart id" "RMI"
            browsingFacade -> cartMgt "Add product to cart"
            cartMgt -> cart "select * from carts where cartid = ?" "JPA"
            cartMgt -> product "select * from products where productid = ?" "JPA"
            cartMgt -> cart "insert into cartProducts values (cartId, productId)" "JPA"
            browsingFacade -> browsing "Confirms success of updating cart" "RMI"
#            autoLayout lr
        }
        
        deployment * "Live" "live_deployment_diagram" {
            include *
#            autoLayout lr
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
