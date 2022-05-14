# Downloaded from structurizr.com.
workspace "Sahara eCommerce with Monitoring" "An example of monitoring." {
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
                monitorService = container "Monitoring Service" {
                    monitor = component "Monitor"
                    dashboard = component "Dashboard"
                }
            }
        }

        # Customer usage relationships.
        customer -> onlineStore "Search, browse and purchase products."
        customer -> webApp "Search, browse and purchase products." "HTTPS"
        customer -> browserApp "View product details and their 3d view."

        productPurchasing -> paymentProvider "Process payment."  "REST API JSON/HTTPS"
        
        # Web App relationships.
        webApp -> browserApp "Delivers content to the customer's browser." "HTTPS"
        webApp -> productAnimator "Downloads to customer's browser." "HTTPS"
        webApp -> productPurchasing "Send Purchase Request" "RMI"
        webApp -> productFulfilment "Query Order Status" "RMI"
        webApp -> custAcctMgt "CRUD Customer Account" "RMI"
        browsing -> cartView "Uses"
        browsing -> browsingFacade "Find & Retrieve Product Details" "RMI"

        # Product Browsing relationships.
        browsingFacade -> search "Uses"
        browsingFacade -> browse "Uses"
        browsingFacade -> suggest "Uses"
        browsingFacade -> cartMgt "Uses"

        # Monitoring relationships.
        monitor -> dashboard "Updates"
        monitor -> webApp "Monitor"
        monitor -> productBrowsing "Monitor"
        monitor -> productPurchasing "Monitor"
        monitor -> productFulfilment "Monitor"
        monitor -> custAcctMgt "Monitor"
        monitor -> inventoryMgt "Monitor"

        # Physical architecture of the 'live' system.
        deploymentEnvironment "Live" {
            deploymentNode "Customer's Computer" "" "MS Windows, Apple macOS or Linux" {
                deploymentNode "Web Browser" "" "Chrome, Firefox, Safari or Edge" {
                    liveInteractiveWebPagesInstance = containerInstance browserApp
                }
            }

            deploymentNode "Monitoring System" "" "Ubuntu 20.04 LTS" {
                monitorServiceInstance = containerInstance monitorService
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
#            autoLayout tb
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
