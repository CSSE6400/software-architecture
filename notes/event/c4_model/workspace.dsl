workspace "Event-Driven" "Example diagrams for an event-driven architecture." {

    model {
        # General Broker Topology Example        
        client = softwareSystem "Client" "Initiates an event handled by the event-driven system." "external" {
            initiator = container "Initiator" "Initiates an event handled by the system." "" "external" {
                initEvent = component "Initiating Event" "Event that starts a process in the system."
            }
        }

        # Broker Topology
        brokerTopology = softwareSystem "Broker Topology" "Structure of the broker topology for an event-driven architecture." {
            broker = container "Event Broker" "Contains the event channels managing the event flow." "" "broker" {
                channel1 = component "Initiating Event Channel" "" "" "channel"
                channel2 = component "Processing Event 1 Channel" "" "" "channel"
                channel3 = component "Processing Event 2 Channel" "" "" "channel"
            }
            handler1 = container "Event Handler A" "Handles an Initiating Event" "" "processor" {
                procInitEvent = component "Processing Initiating Event" "" "" "event"
            }
            handler2 = container "Event Handler B" "Handles a Processing Event 1" "" "processor" {
                procEvent1 = component "Processing Event 1" "" "" "event"
            }
            handler3 = container "Event Handler C" "Handles a Processing Event 1." "" "processor" {
                procEvent2 = component "Processing Event 2" "" "" "event"
            }
        }
        
        initEvent -> channel1 "Sends Initiating Event"
        channel1 -> handler1 "Forwards Initiating Event"
        procInitEvent -> channel2 "Sends Processing Event 1"
        channel2 -> handler2 "Fowards Processing Event 1"
        channel2 -> handler3 "Forwards Processing Event 1"
        procEvent2 -> channel3 "Sends Processing Event 2"

        # Broker Topology with Facade
        brokerFacadeTopology = softwareSystem "Broker Topology with Façade" "Structure of the broker topology, with an event broker facade, for an event-driven architecture." {
            brokerWithFacade = container "Event Broker" "Façade manages the interface to the event channels, which manage the event flow." "" "broker" {
                facade = component "Event Broker Façade" "" "" "channel"
                channel1F = component "Initiating Event Channel" "" "" "channel"
                channel2F = component "Processing Event 1 Channel" "" "" "channel"
                channel3F = component "Processing Event 2 Channel" "" "" "channel"
            }
            handler1F = container "Event Handler A" "Handles an Initiating Event" "" "processor" {
                procInitEventF = component "Processing Initiating Event" "" "" "event"
            }
            handler2F = container "Event Handler B" "Handles a Processing Event 1" "" "processor" {
                procEvent1F = component "Processing Event 1" "" "" "event"
            }
            handler3F = container "Event Handler C" "Handles a Processing Event 1." "" "processor" {
                procEvent2F = component "Processing Event 2" "" "" "event"
            }
        }
        
        handler1F -> facade "Register as Init Event Handler"
        facade -> channel1F "Register Init Event Handler"
        handler2F -> facade "Register as Processing Event 1 Handler"
        facade -> channel2F "Register Event 1 Handlers"
        handler3F -> facade "Register as Processing Event 1 Handler"
#        facade -> channel2F "Register Event 1 Handler"
        initEvent -> facade "Sends Initiating Event"
        facade -> channel1F "Forwards Initiating Event"
        channel1F -> procInitEventF "Forwards Initiating Event"
        handler1F -> facade "Sends Processing Event 1"
# Not sure why component to component relationship doesn't appear in component diagram.
#        procInitEventF -> facade "Sends Processing Event 1"
        facade -> channel2F "Forwards Processing Event 1"
        channel2F -> procEvent1F "Fowards Processing Event 1"
        channel2F -> procEvent2F "Forwards Processing Event 1"
        handler3F -> facade "Sends Processing Event 2"
        facade -> channel3F "Forwards Processing Event 2"

        # Conceptual physical architecture of an event-driven architecture.
        deploymentEnvironment "Conceptual Architecture" {
            deploymentNode "Client" "Initiates an Event" {
                clientInstance = containerInstance initiator
            }

            deploymentNode "Event Broker" "" {
                brokerInstance = containerInstance broker
            }

            deploymentNode "Event Handler 1" "" {
                handler1Instance = containerInstance handler1
            }

            deploymentNode "Event Handler 2" "" {
                handler2Instance = containerInstance handler2
            }
        }
        

        # Mediator Topology
        mediatorTopology = softwareSystem "Mediator Topology" "Structure of the mediator topology for an event-driven architecture." {
            eventMediator = container "Event Mediator" "Coordinates the flow of events in the system." "" "mediator" {
                mediator = component "Event Mediator" "Controls the flow of events to implement a business process." "Java" "mediator"
                eventQueue = component "Event Queue" "" "" "queue"
                mediatorChannel1 = component "Processing Event 1 Channel" "" "" "channel"
                mediatorChannel2 = component "Processing Event 2 Channel" "" "" "channel"
                mediatorChannel3 = component "Processing Event 3 Channel" "" "" "channel"
                # Comment out the following four components for basic mediator topology diagram.
                BPELQueue = component "BPEL Event Queue" "" "" "queue"
                BPMQueue = component "BPM Event Queue" "" "" "queue"
                BPELMediator = component "BPEL Event Mediator" "BPEL describes the flow of events to implement a business process." "Oracle BPEL Process Manager" "mediator"
                BPMMediator = component "BPM Event Mediator" "BPM description of the business process, which controls the flow of events." "jBPM" "mediator"
# Mediator Processing Events commented out so they do not appear in component diagram.
#                mediatorProcEvent1 = component "Processing Event 1" "" "" "event"
#                mediatorProcEvent2 = component "Processing Event 2" "" "" "event"
#                mediatorProcEvent3 = component "Processing Event 3" "" "" "event"
            }
            mediatorHandler1 = container "Event Handler A" "Handles a Processing Event 1" "" "processor"
            mediatorHandler2 = container "Event Handler B" "Handles a Processing Event 2" "" "processor"
            mediatorHandler3 = container "Event Handler C" "Handles a Processing Event 2" "" "processor"
            mediatorHandler4 = container "Event Handler D" "Handles a Processing Event 3" "" "processor"
        }

        # Basic Mediator Topology        
        initEvent -> eventQueue "Sends Initiating Event"
        mediator -> eventQueue "Dequeues Initiating Event"
        mediator -> mediatorChannel1 "Sends Processing Event 1"
        mediatorChannel1 -> mediatorHandler1 "Fowards Processing Event 1"
        # Comment out the following five relationships for complex mediator topology diagram.
#        mediator -> mediatorChannel2 "Sends Processing Event 2"
#        mediatorChannel2 -> mediatorHandler2 "Fowards Processing Event 2"
#        mediatorChannel2 -> mediatorHandler3 "Fowards Processing Event 2"
#        mediator -> mediatorChannel3 "Sends Processing Event 3"
#        mediatorChannel3 -> mediatorHandler4 "Fowards Processing Event 3"

        # Complex Mediator Topology - Comment out the following relationships for basic mediator topology diagram.
        mediator -> BPELQueue "Forwards Initiating Event"
        mediator -> BPMQueue "Forwards Initiating Event"
        BPELMediator -> BPELQueue "Dequeues Initiating Event"
        BPMMediator -> BPMQueue "Dequeues Initiating Event"
        BPELMediator -> mediatorChannel2 "Sends Processing Event 2"
        mediatorChannel2 -> mediatorHandler2 "Fowards Processing Event 2"
        BPMMediator -> mediatorChannel3 "Sends Processing Event 3"
        mediatorChannel3 -> mediatorHandler3 "Fowards Processing Event 3"

        
        # Auction Example - Based on Broker Topology
        bidder = person "Bidder" "Someone who bids on an item."
        group "Auction System" {
            auctionSite = softwareSystem "Auction Site" "Allows customers to find items and bid on them." {
                auctionApp = container "Auction Pages" "Web pages from which customers can view and bid on items." "JavaScript" "browser" {
                    bidEvent = component "Bid Event"
                }
                auctionBroker = container "Auction Event Broker" "Manages the flow of events in the auction system." "" "broker" {
                    bidChannel = component "Bid Event Channel" "" "" "channel"
                    highBidChannel = component "High Bid Event Channel" "" "" "channel"
                }
                bidHandler = container "Bid Processor" "Checks bid against current high bid and determines new high bid." "" "processor" {
                    highBidEvent = component "High Bid Event"
                }
                pageUpdateHandler = container "Page Updater" "Sends new high bid to all pages displaying the item." "" "processor"
                bidNotificationHandler = container "Bid Notifier" "Notifies the bidder of the result of their bid and the new high bid." "" "processor"
                rebidNotificationHandler = container "Rebid Notifier" "Notifies the previous high bidder if they are no longer the high bidder." "" "processor"
            }
        }
        
        bidder -> auctionApp "Bids on item."
        auctionApp -> bidChannel "Sends Bid Event"
        bidChannel -> bidHandler "Forwards Bid Event"
        bidHandler -> highBidChannel "Sends High Bid Event"
        highBidChannel -> pageUpdateHandler "Forwards High Bid Event"
        highBidChannel -> bidNotificationHandler "Forwards High Bid Event"
        highBidChannel -> rebidNotificationHandler "Forwards High Bid Event"

        # Physical architecture for the auction example.
        deploymentEnvironment "Auction Architecture" {
            deploymentNode "Auction Pages" "" {
                auctionPagesInstance = containerInstance auctionApp
            }

            deploymentNode "Auction Event Broker" {
                auctionBrokerInstance = containerInstance auctionBroker
            }

            deploymentNode "Bid Event Handler" {
                bidHandlerInstance = containerInstance bidHandler
            }

            deploymentNode "Page Updater" {
                pageUpdateHandlerInstance = containerInstance pageUpdateHandler
            }

            deploymentNode "Bid Notifier" {
                bidNotificationHandlerInstance = containerInstance bidNotificationHandler
            }

            deploymentNode "Rebid Notifier" {
                rebidNotificationHandlerInstance = containerInstance rebidNotificationHandler
            }
        }


        # Sahara eCommerce enterprise-wide system.
        # Actors
        customer = person "Customer" "Someone who shops at the Sahara on-line store."
        orderPersonnel = person "Order Personnel" "Manages inventory and ordering products."
        # External Systems
        paymentProvider = softwareSystem "Payment Provider" "External service providing payment facilities." "external"

        # Software Systems, Containers and Components
        group "Sahara eCommerce" {
            onlineStore = softwareSystem "On-line Store" "Allows customers to browse and search for items and to order them." {
                inventoryApp = container "Inventory Application" "Interface to manage inventory." "React" "browser" {
                }
                mobileApp = container "Mobile Application" "Mobile apps on iPhone and Android providing shopping experience." "React Native" "mobile"
                webApp = container "Web Application" "Delivers the web front-end for the on-line store." "J2EE Server" {
#                    signIn = component "Sign In" "Allows customers to sign into the on-line store. Also provides customer registration." "JSF"
                    acctMgt = component "Account Management" "Allows customers to manage their account." "JSF"
                    register = component "Register Account" "Register a new customer account." "JSF"
                    browsing = component "Product Browsing" "Customers can search and browse for products, and add them to their shopping cart." "JSF"
                    cartView = component "Shopping Cart View" "Customers can view the contents of their shopping cart and checkout." "JSF"
                }
                browserApp = container "Interactive Web Pages" "Provides the environment in which customers can view products" "JSF & JavaScript" "browser" {
                    productAnimator = component "Product Animator" "Provides interactive 3d views of products." "JavaScript"
                }
                sarahaBroker = container "Event Broker" "Event channels managing the flow of events." "" "broker" {
                    orderPlaced = component "Order Placed Channel" "" "" "channel"
                    orderCreated = component "Order Created Channel" "" "" "channel"
                    paymentApproved = component "Payment Approved Channel" "" "" "channel"
                    paymentDenied = component "Payment Denied Channel" "" "" "channel"
                    orderFulfilled = component "Order Fulfilled Channel" "" "" "channel"
                    orderShipped = component "Order Shipped Channel" "" "" "channel"
                    inventoryUpdated = component "Inventory Updated Channel" "" "" "channel"
                    inventoryLow = component "Inventory Low Channel" "" "" "channel"
                    notificationSent = component "Notification Sent Channel" "" "" "channel"
                }

                # From service-based architecture model.
                productBrowsing = container "Product Browsing" "Provides backend logic for browsing or searching for products." "Java" {
                    browsingFacade = component "Product Browsing Façade" "Provides interface to retrieve product information based on search criteria" "JSF"
                    search = component "Search for Product" "Finds products based on search criteria." "Java"
                    browse = component "Browse for Product" "Finds products based on user navigation." "Java"
                    suggest = component "Suggest Products" "Suggest products user may be interested in." "Java"
                    cartMgt = component "Shopping Cart Management" "Add and remove items from user's shopping cart." "Java"
                }
                orderPlacement = container "Order Placement" "Creates and saves orders from shopping cart content." "Java" {
                    cartController = component "Shopping Cart Controller" "Provides RESTful interface to use a Shopping Cart." "Java Control Class"
                }
                payment = container "Payment" "Sends payment details to Payment Provider and saves payment result." "Java" 
                productFulfilment = container "Product Fulfilment" "Provides backend logic for fulfilling orders." "Java" {
                }
                custAcctMgt = container "Customer Account Management" "Provides backend logic for managing customer accounts." "Java" {
                }
                inventoryMgt = container "Inventory Management" "Provides backend logic for managing inventory." "Java" {
                }
                warehouse = container "Warehouse" "Manages physical inventory and ordering of products." "Java" 
                appDB = container "Application Database" "Stores customer credentials, products and orders." "MySQL" "db" {
                    cust = component "Customer" "Details about a customer." "SQL"
                    product = component "Product" "Details about a product." "SQL"
                    cart = component "Shopping Cart" "Holds products that customer may purchase." "SQL"
                    order = component "Order" "Record of completed orders." "SQL"
                }
            }
            dataMining = softwareSystem "Data Mining Service" "Collects customer visit data and provides product recommendations." "ancillary" {
                dataMiningProcess = container "Data Mining Process" "Performs data mining on collected data." "Java"
                dataMiningIntf = container "Data Mining Interface" "Provides interface to save data to be mined and retrieve mining results." "Java"
                dataWarehouse = container "Data Warehouse" "Stores customer browsing and transaction history." "Oracle" "db"
            }
            
            # Sahara Mediator Topology Example
            saharaMediator = softwareSystem "Sahara Mediator Topology Store" "Allows customers to browse and search for items and to order them." {
#                inventoryApp_Mediator = container "Inventory Application" "Interface to manage inventory." "React" "browser"
#                mobileApp = container "Mobile Application" "Mobile apps on iPhone and Android providing shopping experience." "React Native" "mobile"
                webApp_Mediator = container "Web Application" "Delivers the web front-end for the on-line store." "J2EE Server" {
#                    signIn_Mediator = component "Sign In" "Allows customers to sign into the on-line store. Also provides customer registration." "JSF"
                    acctMgt_Mediator = component "Account Management" "Allows customers to manage their account." "JSF"
                    register_Mediator = component "Register Account" "Register a new customer account." "JSF"
                    browsing_Mediator = component "Product Browsing" "Customers can search and browse for products, and add them to their shopping cart." "JSF"
                    cartView_Mediator = component "Shopping Cart View" "Customers can view the contents of their shopping cart and checkout." "JSF"
                }
#                browserApp_Mediator = container "Interactive Web Pages" "Provides the environment in which customers can view products" "JSF & JavaScript" "browser" {
#                    productAnimator_Mediator = component "Product Animator" "Provides interactive 3d views of products." "JavaScript"
#                }
                customerMediator = container "Customer Event Mediator" "Coordinates customer account activities." "" "mediator" {
                    customerEventQueue = component "Customer Event Queue" "" "" "queue"
                }
                registerCustomer = container "Register Customer" "Stores new customer account." "" "processor"
#                sendValidationEmail = container "Send Validation Email" "Send validation email to new customer." "" "processor"
#                validateEmail = container "Validate Email" "Record that customer's email is valid." "" "processor"
                updateProfile = container "Update Customer Profile" "Stores changes to customer profile." "" "processor"
                browsingMediator = container "Browsing Event Mediator" "Coordinates browsing and searching activities." "" "mediator"
                browseActivity = container "Browse for Products" "Retrieve set of products by selected category." "" "processor"
                searchActivity = container "Search for Product" "Finds products based on search criteria." "" "processor"
                orderMediator = container "Order Event Mediator" "Coordinates product purchasing activities." "" "mediator"
                addToCart = container "Add Product to Cart" "Adds product to shopping cart." "" "processor"
                checkOut = container "Checkout Cart" "Place order by checking products out of cart" "" "processor"
#                inventoryMediator = container "Inventory Event Mediator" "Coordinates inventory management activities." "" "mediator"
#                inventoryLevels = container "Get Inventory Levels" "Check inventory levels for products held by store." "" "processor"
#                orderStock = container "Order Stock" "Order new stock." "" "processor"
            }
            dataMiningMediator = softwareSystem "Data Mining Service Mediator Topology" "Collects customer visit data and provides product recommendations." "ancillary" {
                dataMiningProcess_Mediator = container "Data Mining Process" "Performs data mining on collected data." "Java"
                dataMiningIntf_Mediator = container "Data Mining Interface" "Provides interface to save data to be mined and retrieve mining results." "Java"
                dataWarehouse_Mediator = container "Data Warehouse" "Stores customer browsing and transaction history." "Oracle" "db"
            }
        }
        
        webApp_Mediator -> customerEventQueue "Sends Customer Account Events"
        register_Mediator -> customerEventQueue "Sends Register Customer Event"
        acctMgt_Mediator -> customerEventQueue "Sends Update Profile Event"
        customerMediator -> registerCustomer "Sends Register Customer Event"
        customerMediator -> updateProfile "Sends Update Profile Event"
        webApp_Mediator -> browsingMediator "Sends Browse & Search Events"
        browsing_Mediator -> browsingMediator "Sends Browse Event"
        browsingMediator -> browseActivity "Sends Get Products Event"
        browsingMediator -> searchActivity "Sends Search Event"
        webApp_Mediator -> orderMediator "Sends Order Events"
        orderMediator -> addToCart "Sends Add to Cart Event"
        orderMediator -> checkOut "Sends Checkout Event"
#        inventoryApp_Mediator -> inventoryMediator "Sends Inventory Management Events"
#        inventoryMediator -> inventoryLevels "Sends Stock Level Event"
#        inventoryMediator -> orderStock "Sends Order Product Event"
    }
    
    views {
        container brokerTopology "broker-container" {
            include *
#            autolayout tb
        }
        
        component broker "broker-components" {
            include *
#            autolayout lr
        }
        
        component brokerWithFacade "broker-facade-components" {
            include *
#            autolayout tb
        }
        
        component auctionBroker "auction-broker-components" {
            include *
#            autolayout tb
        }
        
        deployment * "Auction Architecture" "auction-architecture" {
            # Need to find out how to show or capture animations.
            animation {
                auctionApp auctionBroker
                bidHandler
                pageUpdateHandler bidNotificationHandler rebidNotificationHandler
            }
            include *
        }
        
        deployment * "Conceptual Architecture" "conceptual-architecture" {
            include *
        }
        
        component eventMediator "mediator-components" {
            include *
        }

        container saharaMediator "sahara-mediator-container" {
            include *
        }

        styles {
            element external {
                background #09355c
                /* colour is text colour. */
                colour #FFFFFF
            }
            element broker {
                background #629ee3
                /* colour is text colour. */
                colour #FFFFFF
            }
            element mediator {
                background #5b79de
                /* colour is text colour. */
                colour #FFFFFF
            }
            element event {
                background #ffe294
                /* colour is text colour. */
                colour #000000
            }
            element processor {
                background #fffacf
                /* colour is text colour. */
                colour #000000
            }
            element channel {
                background #ffdbcf
                /* colour is text colour. */
                colour #000000
            }
            element queue {
                background #fce5e3
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
    }

}
