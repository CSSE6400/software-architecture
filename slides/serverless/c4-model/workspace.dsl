workspace "Serverless Architecture" "A simple example of serverless architecture." {
    model {
        # Actors
        customer = person "Customer" "Someone who shops at the Sahara on-line store."
        fulfilmentPersonnel = person "Fulfilment Personnel" "Prepares orders for shipping."
        # External Services
        paymentProviderService = softwareSystem "Payment Provider" "Payment facilities provided by Stripe." "external" {
            paymentProvider = container "Payment Provider" "Payment facilities provided by Stripe." "" "external"
        }
        authServiceProvider = softwareSystem "Authorisation Service" "User authentication provided by Auth0." "external" {
            authService = container "Authorisation Service" "User authentication provided by Auth0" "" "external"
        }
        apiGateway = softwareSystem "API Gateway" "AWS API Gateway." "Amazon Web Services - API Gateway" {
            apiGatewayService = container "API Gateway" "AWS API Gateway." "" "Amazon Web Services - API Gateway"
        }
        sqs = softwareSystem "Message Queue" "AWS SQS." "Amazon Web Services - Simple Queue Service SQS" {
            queue = container "Message Queue" "AWS SQS." "" "Amazon Web Services - Simple Queue Service SQS"
        }
        ses = softwareSystem "Email Service" "AWS SES." "Amazon Web Services - Simple Email Service SES" {
            emailService = container "Email Service" "AWS SES." "" "Amazon Web Services - Simple Email Service SES"
        }
        lambdaServiceAWS = softwareSystem "Lambda Service" "AWS Lambda Service." "Amazon Web Services - Lambda" {
            lambdaService = container "Lambda Service" "AWS Lambda Service polls Message Queue and batches messages to send to Lambda Functions." "" "Amazon Web Services - Lambda"
        }
        productDbGoogleHost = softwareSystem "Simple Product Database Host" "Google cloud SQL database storing product details." "Google Cloud Platform - Cloud SQL" {
            googleProductDB = container "Product Database" "Database storing product details." "MySQL 8.0" "Google Cloud Platform - Cloud SQL"
        }
        orderDbGoogleHost = softwareSystem "Simple Order Database Host" "Google cloud SQL database storing orders." "Google Cloud Platform - Cloud SQL" {
            googleOrderDB = container "Order Database" "Database storing orders." "MySQL 8.0" "Google Cloud Platform - Cloud SQL"
        }
        productDbHost = softwareSystem "Product Database Host" "Google cloud SQL database storing product details." "Amazon Web Services - RDS MySQL instance" {
            productDB = container "Product Database" "Database storing product details." "MySQL 8.0" "Amazon Web Services - RDS MySQL instance"
        }
        orderDbHost = softwareSystem "Order Database Host" "Google cloud SQL database storing orders." "Amazon Web Services - RDS MySQL instance" {
            orderDB = container "Order Database" "Database storing orders." "MySQL 8.0" "Amazon Web Services - RDS MySQL instance"
        }
        # Serverless Functions
        searchFunc = softwareSystem "Search for Product" "Find product from customer's query." "Amazon Web Services - Lambda" {
            searchQuery = container "Search for Product" "Find product from customer's query." "Java" "Amazon Web Services - Lambda Lambda Function" {
                searchController = component "Search for Product" "Find product from customer's query." "Java"
            }
        }
        purchaseFunc = softwareSystem "Purchase Products" "Process customer's purchase." "Amazon Web Services - Lambda" {
            purchaseProduct = container "Purchase Products" "Save order and initiate payment processing." "Java" "Amazon Web Services - Lambda Lambda Function" {
                purchaseController = component "Purchase Products" "Save order and initiate payment processing." "Java"
            }
        }
        paymentConfirmedFunc = softwareSystem "Payment Confirmed" "Payment for purchase confirmed." "Amazon Web Services - Lambda" {
            paymentConfirmed = container "Payment Confirmed" "Update order and send 'order paid' event." "Java" "Amazon Web Services - Lambda Lambda Function" {
                paymentConfirmedController = component "Payment Confirmed" "Update order and send 'order paid' event." "Java"
            }
        }
        fulfilmentFunc = softwareSystem "Fulfill Order" "Pick, pack & ship order." "Amazon Web Services - Lambda" {
            fulfilment = container "Fulfill Order" "Send pick list for order to warehouse." "Java" "Amazon Web Services - Lambda Lambda Function" {
                fulfilmentController = component "Fulfill Order" "Send pick list for order to warehouse." "Java"
            }
        }
        orderShippedFunc = softwareSystem "Order Shipped" "Order has been shipped to customer." "Amazon Web Services - Lambda" {
            orderShipped = container "Order Shipped" "Send email to customer with message that order has shipped." "Java" "Amazon Web Services - Lambda Lambda Function" {
                orderShippedController = component "Order Shipped" "Send email to customer with message that order has shipped." "Java"
            }
        }
        orderStatusFunc = softwareSystem "Order Status" "Customer queries order status." "Amazon Web Services - Lambda" {
            orderStatus = container "Order Status" "Respond to customer query with current status of order." "Java" "Amazon Web Services - Lambda Lambda Function" {
                orderStatusController = component "Order Status" "Respond to customer query with current status of order." "Java"
            }
        # Commented out to simplify diagram.
        # More detailed steps in order tracking.
#        orderReadyFunc = softwareSystem "Order Ready to Ship" "Order is ready to ship from warehouse." "Amazon Web Services - Lambda" {
#            orderReady = container "Order Ready to Ship" "Send email to customer with message that order is ready to ship." "Java" "Amazon Web Services - Lambda Lambda Function" {
#                orderReadyController = component "Order Ready to Ship" "Send email to customer with message that order is ready to ship." "Java"
#            }
#        }
#        orderDeliveredFunc = softwareSystem "Order Delivered" "Order has been delivered to customer." "Amazon Web Services - Lambda" {
#            orderDelivered = container "Order Delivered" "Send email to customer with message that order has been delivered." "Java" "Amazon Web Services - Lambda Lambda Function" {
#                orderDeliveredController = component "Order Delivered" "Send email to customer with message that order has  delivered." "Java"
#            }
#        }
        }
        
        enterprise "Simple On-line Store" {
            simpleBaaSStore = softwareSystem "Simple BaaS On-line Store" "Simple app using BaaS to allow customers to browse and search for items and to order them." {
                BaasWebApp = container "Simple BaaS Web Application" "Delivers the web front-end for the on-line store." "React" "browser" {
                    spaSignIn = component "Sign In" "Allows customers to sign into the on-line store. Also provides customer registration." "JS"
                    spaAcctMgt = component "Account Management" "Allows customers to manage their account." "JS"
                    spaBrowsing = component "Product Browsing" "Customers can search and browse for products, and add them to their shopping cart." "JS"
                    spaPurchasing = component "Purchase Product" "Customers can view the contents of their shopping cart and checkout." "JS"
                }
                baasMobileApp = container "Simple BaaS Mobile App" "Allows customers to browse and search for items and to order them." "React Native" "mobile" {
                    smSignIn = component "Sign In" "Allows customers to sign into the on-line store. Also provides customer registration." "JS"
                    smAcctMgt = component "Account Management" "Allows customers to manage their account." "JS"
                    smBrowsing = component "Product Browsing" "Customers can search and browse for products, and add them to their shopping cart." "JS"
                    smPurchasing = component "Purchase Product" "Customers can view the contents of their shopping cart and checkout." "JS"
                }
            }
        }
        
        enterprise "Simple FaaS Store" {
            simpleFaaSStore = softwareSystem "Simple FaaS On-line Store" "Simple app using FaaS to allow customers to browse and search for items and to order them." {
                faasWebApp = container "Simple FaaS Web Application" "Delivers the web front-end for the on-line store." "React" "browser" {
                    faasWebSignIn = component "Sign In" "Allows customers to sign into the on-line store. Also provides customer registration." "JS"
                    faasWebAcctMgt = component "Account Management" "Allows customers to manage their account." "JS"
                    faasWebBrowsing = component "Product Browsing" "Customers can search and browse for products, and add them to their shopping cart." "JS"
                    faasWebPurchasing = component "Purchase Product" "Customers can view the contents of their shopping cart and checkout." "JS"
                }
                faasMobileApp = container "Simple FaaS Mobile App" "Allows customers to browse and search for items and to order them." "React Native" "mobile" {
                    faasMobileSignIn = component "Sign In" "Allows customers to sign into the on-line store. Also provides customer registration." "JS"
                    faasMobileAcctMgt = component "Account Management" "Allows customers to manage their account." "JS"
                    faasMobileBrowsing = component "Product Browsing" "Customers can search and browse for products, and add them to their shopping cart." "JS"
                    faasMobilePurchasing = component "Purchase Product" "Customers can view the contents of their shopping cart and checkout." "JS"
                }
            }
        }

        # Sahara eCommerce enterprise-wide system.
        # Software systems, containers and components.
        enterprise "Sahara eCommerce" {
            onlineStore = softwareSystem "Sahara On-line Store" "Allows customers to browse and search for items and to order them." {
                webApp = container "Sahara Web Application" "Delivers the web front-end for the on-line store." "React" {
                    signIn = component "Sign In" "Allows customers to sign into the on-line store. Also provides customer registration." "JS"
                    acctMgt = component "Account Management" "Allows customers to manage their account." "JS"
                    search = component "Find Product" "Customers can search for products and add them to their shopping cart." "JS"
                    browsing = component "Product Browsing" "Customers can browse for products and add them to their shopping cart." "JS"
                    cartView = component "Shopping Cart View" "Customers can view the contents of their shopping cart and checkout." "JS"
                    purchase = component "Purchase Products in Cart" "Customer purchases products in their shopping cart." "JS"
                    orderQuery = component "Query Order State" "Customers can check on the current status of their order." "JS"
                }
                mobileApp = container "Sahara Mobile App" "Allows customers to browse and search for items and to order them." "React Native" "mobile" {
                    mobileSignIn = component "Sign In" "Allows customers to sign into the on-line store. Also provides customer registration." "JS"
                    mobileAcctMgt = component "Account Management" "Allows customers to manage their account." "JS"
                    mobileSearch = component "Find Product" "Customers can search for products and add them to their shopping cart." "JS"
                    mobileBrowsing = component "Product Browsing" "Customers can search and browse for products, and add them to their shopping cart." "JS"
                    mobilePurchase = component "Purchase Product" "Customers can view the contents of their shopping cart and checkout." "JS"
                }
                fulfilmentApp = container "Fulfilment App" "Coordinates fulfliment of orders." "React Native" "mobile"
                productFulfilment = container "Product Fulfilment" "Provides backend logic for fulfilling orders." "Java" {
                }
                inventoryMgt = container "Inventory Management" "Provides backend logic for managing inventory." "Java"
            }
        }
        
        # Simple BaaS Store relationships.
        spaSignIn -> authService "Authenticate user." "REST API JSON/HTTPS"
        smSignIn -> authService "Authenticate user." "REST API JSON/HTTPS"
        spaBrowsing -> googleProductDB "Search for products." "REST API JSON/HTTPS"
        smBrowsing -> googleProductDB "Search for products." "REST API JSON/HTTPS"
        spaPurchasing -> paymentProvider "Pay for purchases." "REST API JSON/HTTPS"
        spaPurchasing -> googleOrderDB "Save order." "REST API JSON/HTTPS"
        smPurchasing -> paymentProvider "Pay for purchases." "REST API JSON/HTTPS"
        smPurchasing -> googleOrderDB "Save order." "REST API JSON/HTTPS"
        
        # Simple FaaS Store relationships.
        # Authentication hidden to focus on FaaS.
#        faasWebSignIn -> authService "Authenticate user." "REST API JSON/HTTPS"
#        faasMobileSignIn -> authService "Authenticate user." "REST API JSON/HTTPS"
        faasWebBrowsing -> apiGatewayService "Search for products." "REST API JSON/HTTPS"
        faasMobileBrowsing -> apiGatewayService "Search for products." "REST API JSON/HTTPS"
        apiGatewayService -> searchQuery "Send Search Query" "REST API JSON/HTTPS"
        faasWebPurchasing -> apiGatewayService "Purchase products." "REST API JSON/HTTPS"
        faasMobilePurchasing -> apiGatewayService "Purchase products." "REST API JSON/HTTPS"
        apiGatewayService -> purchaseProduct "Send Purchase Request" "REST API JSON/HTTPS"

        # Sahara Customer usage relationships.
        customer -> webApp "Search, browse and purchase products."
        customer -> mobileApp "Search, browse and purchase products."
        fulfilmentPersonnel -> fulfilmentApp "Pick, pack and post orders."

        # Sahara Web App relationships.
        # Need to fix protocol for lambda functions.
        webApp -> apiGatewayService "Send Function Requests" "REST API JSON/HTTPS"
        signIn -> authService "Authenticate Customer" "REST API JSON/HTTPS"
        acctMgt -> authService "CRUD Customer Account" "REST API JSON/HTTPS"
        webApp -> productFulfilment "Query Order Status" "RMI"
        browsing -> cartView "Uses"
        search -> cartView "Uses"
        cartView -> purchase "Uses"
        browsing -> productDB "Find & Retrieve Product Details" "REST API JSON/HTTPS"
        search -> apiGatewayService "Send Search Query to Backend" "REST API JSON/HTTPS"
        purchase -> apiGatewayService "Send Purchase Request to Backend" "REST API JSON/HTTPS"
        apiGatewayService -> purchaseProduct "Send Purchase Request" "REST API JSON/HTTPS"
        purchaseProduct -> orderDB "Store Order" "REST API JSON/HTTPS"
        purchaseProduct -> paymentProvider "Process Payment" "REST API JSON/HTTPS"
        paymentProvider -> apiGatewayService "Payment Confirmed" "REST API JSON/HTTPS"
        apiGatewayService -> paymentConfirmed "Payment Confirmed" "REST API JSON/HTTPS"
        paymentConfirmed -> orderDB "Update Order" "REST API JSON/HTTPS"
        paymentConfirmed -> queue "Order Paid Event" "Message"
        apiGatewayService -> searchQuery "Send Search Query" "REST API JSON/HTTPS"
        searchQuery -> productDB "Search Query" "REST API JSON/HTTPS"
        # Order Fulfilment.
        lambdaService -> queue "Poll for Messages"
        lambdaService -> fulfilment "Ship Order Message Batch"
        fulfilment -> orderDB "Query Order Details" "REST API JSON/HTTPS"
        fulfilment -> queue "Order Picking Event" "Message"
        fulfilment -> fulfilmentApp "Send Pick List" "HTTPS"
        fulfilmentApp -> apiGatewayService "Order Shipped" "REST API JSON/HTTPS"
        apiGatewayService -> orderShipped "Order Shipped" "REST API JSON/HTTPS"
        orderShipped -> orderDB "Update Order Details" "REST API JSON/HTTPS"
        orderShipped -> emailService "Send Order Shipped Message"
        orderShipped -> queue "Order Shipped Event" "Message"
        orderQuery -> apiGatewayService "Query Order Status" "REST API JSON/HTTPS"
        apiGatewayService -> orderStatus "Query Order Status"
        orderStatus -> orderDB "Query Order Status" "REST API JSON/HTTPS"
        orderStatus -> orderQuery "Order Status" "REST API JSON/HTTPS"

        # Sahara Mobile App relationships.
        # Commented out to simplify diagrams.
#        mobileSignIn -> authService "Authenticate customer." "REST API JSON/HTTPS"
#        mobileAcctMgt -> authService "CRUD Customer Account" "REST API JSON/HTTPS"
#        mobileBrowsing -> productDB "Find & Retrieve Product Details" "REST API JSON/HTTPS"
#        mobileSearch -> apiGatewayService "Send Search Query to Backend" "REST API JSON/HTTPS"
#        mobilePurchase -> apiGatewayService "Send Purchase Request to Backend" "REST API JSON/HTTPS"

        # Physical architecture of the simple FaaS on-line store.
        deploymentEnvironment "FaaS" {
            deploymentNode "Customer's Computer" "" "MS Windows, Apple macOS or Linux" {
                deploymentNode "Web Browser" "" "Chrome, Firefox, Safari or Edge" {
                    faasWebAppInstance = containerInstance faasWebApp
                }
            }

            deploymentNode "Customer's Mobile Device" "" "Android or iOS" {
                faasMobileAppInstance = containerInstance faasMobileApp
            }

            deploymentNode "AWS Services" "" "" "Amazon Web Services - Cloud" {
                deploymentNode "API Gateway" "" "" "Amazon Web Services - API Gateway" {
                    faasApiGatewayInstance = containerInstance apiGatewayService
                }
                
                deploymentNode "Purchase Products Function" "" "Java" "Amazon Web Services - Lambda" {
                    faasPurchaseFuncInstance = containerInstance purchaseProduct
                }
                
                deploymentNode "Product Search Function" "" "Java" "Amazon Web Services - Lambda" {
                    faasSearchFuncInstance = containerInstance searchQuery
                }

                deploymentNode "Product Database" "" "" "Amazon Web Services - RDS MySQL instance" {
                    faasProductDBInstance = containerInstance productDB
                }
                
                deploymentNode "Order Database" "" "" "Amazon Web Services - RDS MySQL instance" {
                    faasOrderDBInstance = containerInstance orderDB
                }
            }
        }

        # Physical architecture of the Sahara eCommerce system (Browse, Search & Purchase).
        deploymentEnvironment "Browse & Purchase" {
            deploymentNode "Customer's Computer" "" "MS Windows, Apple macOS or Linux" {
                deploymentNode "Web Browser" "" "Chrome, Firefox, Safari or Edge" {
                    bpWebAppInstance = containerInstance webApp
                }
            }

            # Commented out to simplify diagram.
#            deploymentNode "Customer's Mobile Device" "" "Android or iOS" {
#                bpMobileAppInstance = containerInstance mobileApp
#            }

            deploymentNode "Payment Provider" "" "" {
                bpPaymentProviderInstance = containerInstance paymentProvider
            }

            deploymentNode "Authorisation Service" "" "" {
                bpAuthServiceInstance = containerInstance authService
            }

            deploymentNode "AWS Services" "" "" "Amazon Web Services - Cloud" {
                deploymentNode "API Gateway" "" "" "Amazon Web Services - API Gateway" {
                    bpApiGatewayInstance = containerInstance apiGatewayService
                }
                
                deploymentNode "Purchase Products Function" "" "Java" "Amazon Web Services - Lambda" {
                    bpPurchaseFuncInstance = containerInstance purchaseProduct
                }
                
                deploymentNode "Payment Confirmed Function" "" "Java" "Amazon Web Services - Lambda" {
                    bpPaymentConfirmedFuncInstance = containerInstance paymentConfirmed
                }
                
                deploymentNode "Message Queue" "" "" "Amazon Web Services - Simple Queue Service SQS" {
                    bpSQSInstance = containerInstance queue
                }
                
                deploymentNode "Product Search Function" "" "Java" "Amazon Web Services - Lambda" {
                    bpSearchFuncInstance = containerInstance searchQuery
                }

                deploymentNode "Product Database" "" "" "Amazon Web Services - RDS MySQL instance" {
                    bpProductDBInstance = containerInstance productDB
                }
                
                deploymentNode "Order Database" "" "" "Amazon Web Services - RDS MySQL instance" {
                    bpOrderDBInstance = containerInstance orderDB
                }
            }

#            deploymentNode "Sahara" "" "Sahara eCommerce Data Centre" {
#                deploymentNode "Inventory Management Server" "" "Ubuntu 20.04 LTS & Java 17 LTS" "" {
#                    bpInventoryServerInstance = containerInstance inventoryMgt
#                }
#            }
        }

        # Physical architecture of the Sahara eCommerce system (Order Fulfilment).
        deploymentEnvironment "Order Fulfilment" {
            deploymentNode "Customer's Computer" "" "MS Windows, Apple macOS or Linux" {
                deploymentNode "Web Browser" "" "Chrome, Firefox, Safari or Edge" {
                    ofWebAppInstance = containerInstance webApp
                }
            }

            # Commented out to simplify diagram.
#            deploymentNode "Customer's Mobile Device" "" "Android or iOS" {
#                ofMobileAppInstance = containerInstance mobileApp
#            }

            deploymentNode "Fulfilment Mobile Device" "" "Android or iOS" {
                ofFulfilmentAppInstance = containerInstance fulfilmentApp
            }

            deploymentNode "Authorisation Service" "" "" {
                ofAuthServiceInstance = containerInstance authService
            }

            deploymentNode "AWS Services" "" "" "Amazon Web Services - Cloud" {
                deploymentNode "API Gateway" "" "" "Amazon Web Services - API Gateway" {
                    ofApiGatewayInstance = containerInstance apiGatewayService
                }

                deploymentNode "Message Queue" "" "" "Amazon Web Services - Simple Queue Service SQS" {
                    ofSQSInstance = containerInstance queue
                }

                deploymentNode "Email Service" "" "" "Amazon Web Services - Simple Email Service SES" {
                    ofSESInstance = containerInstance emailService
                }

                deploymentNode "Lambda Service" "" "" "Amazon Web Services - Lambda" {
                    ofLambdaServiceInstance = containerInstance lambdaService
                }
                
                deploymentNode "Fulfill Order Function" "" "Java" "Amazon Web Services - Lambda" {
                    ofFulfilmentFuncInstance = containerInstance fulfilment
                }
                
                deploymentNode "Order Shipped Function" "" "Java" "Amazon Web Services - Lambda" {
                    ofOrderShippedFuncInstance = containerInstance orderShipped
                }
                
                deploymentNode "Order Status Query Function" "" "Java" "Amazon Web Services - Lambda" {
                    ofOrderStatusFuncInstance = containerInstance orderStatus
                }

                deploymentNode "Order Database" "" "" "Amazon Web Services - RDS MySQL instance" {
                    ofOrderDBInstance = containerInstance orderDB
                }
            }

#            deploymentNode "Sahara" "" "Sahara eCommerce Data Centre" {
#                deploymentNode "Inventory Management Server" "" "Ubuntu 20.04 LTS & Java 17 LTS" "" {
#                    bpInventoryServerInstance = containerInstance inventoryMgt
#                }
#            }
        }
    }

    views {
        # Simple BaaS On-line Store Views
        systemContext simpleBaaSStore "baas_store_context_diagram" {
            include *
#            autoLayout lr
        }
        
        container simpleBaaSStore "baas_store_container_diagram" {
            include *
#            autoLayout tb
        }

        # Simple FaaS On-line Store Views
        systemContext simpleFaaSStore "faas_store_context_diagram" {
            include *
            autoLayout lr
        }
        
        container simpleFaaSStore "faas_store_container_diagram" {
            include *
            autoLayout tb
        }

        deployment * "FaaS" "faas_deployment_diagram" {
            include *
#            autoLayout lr
        }

        # Sahara eCommerce Views
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

        deployment * "Browse & Purchase" "browse-purchase_deployment_diagram" {
            include *
#            autoLayout lr
        }

        deployment * "Order Fulfilment" "order_fulfilment_deployment_diagram" {
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
            element "Google Cloud Platform - Cloud SQL" {
                /* Set text colour to white. */
                colour #FFFFFF
            }
            element "Amazon Web Services - RDS MySQL instance" {
                background #c4f5f2
            }
            element "Amazon Web Services - API Gateway" {
                background #c4f5f2
            }
            element "Amazon Web Services - Simple Queue Service SQS" {
                background #c4f5f2
            }
            element "Amazon Web Services - Simple Email Service SES" {
                background #c4f5f2
            }
            element "Amazon Web Services - Lambda" {
                background #c4f5f2
            }
            element "Amazon Web Services - Lambda Lambda Function" {
                background #c4f5f2
            }
        }

        themes default https://static.structurizr.com/themes/amazon-web-services-2020.04.30/theme.json https://static.structurizr.com/themes/google-cloud-platform-v1.5/theme.json
    }
}