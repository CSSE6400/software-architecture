workspace "Blackboard" "Simplified architecture of old version of Blackboard."  {

    model {
        student = person "UQ Student"
        staff = person "UQ Staff"
        blackboard = softwareSystem "Blackboard" {
            !docs docs

            webApp = container "Monolith" "Delivers the web front-end and services API requests" "Java Spring" "spring"

            lb = container "Load Balancer" "Load balances requests to the web application" "F5" "f5"

            browserApp = container "Interactive Web Pages" "Provides the online interface" "HTML/JavaScript" "browser"

            blackboardDB = container "Database" "Store course configuration data" "OracleDB" "db"
            fileStore = container "File Share" "Store course resources, files, videos, etc." "SMB" "smb"
        }

        student -> blackboard "Partake in UQ courses"
        staff -> blackboard "Develop and manage UQ courses"

        datahub = softwareSystem "Datahub" "Monolithic data store for UQ"
        ldap = softwareSystem "LDAP" "Store user account information" "ldap"
        sinet = softwareSystem "SI-Net" "Manage student course enrolment" "sinet"

        sso = softwareSystem "UQ Single Sign-on" "Authenticate UQ accounts" "sso"

        browserApp -> lb "Request page content"
        lb -> sso "Authenticate incoming requests with sign-on as required"
        lb -> webApp "Load balanced requests"

        webApp -> blackboardDB "Retrieve and update course configuration"
        webApp -> fileStore "Retrieve and update course resources"

        ldap -> blackboardDB "Hourly synchronisation of user data"
        sinet -> blackboardDB "At least daily synchronisation of enrolment data"

        datahub -> ldap "Populate user information"
        sinet -> datahub "Populate user enrolment information"

        deploymentEnvironment "UQ Infrastructure" {
            deploymentNode "On-Premises" {
                deploymentNode "Hypervisor" "" "VMWare" {
                    deploymentNode "Blackboard VM" "" "Oracle Linux" "" 8 {
                        monolithInstance = containerInstance webApp
                    }
                    deploymentNode "LDAP VM" "" "Oracle Linux" "" 4 {
                        ldapInstance = softwareSystemInstance ldap
                    }
                    deploymentNode "SSO VM" "" "Oracle Linux" "" 4 {
                        ssoInstance = softwareSystemInstance sso
                    }
                }
                deploymentNode "F5 Appliance" {
                    lbInstance = containerInstance lb
                }
                deploymentNode "SMB Appliance" {
                    fileStoreInstance = containerInstance fileStore
                }
                deploymentNode "Oracle Server" {
                    blackboardDBInstance = containerInstance blackboardDB
                }
            }

            deploymentNode "AWS" {
                deploymentNode "TradeSecrets™" {
                    datahubInstance = softwareSystemInstance datahub
                }
            }

            deploymentNode "User's Device" "" "" {
                deploymentNode "Web Browser" "" "" {
                    liveInteractiveWebPagesInstance = containerInstance browserApp
                }
            }
        }
    }

    views {
        systemContext blackboard "context" {
            include *
        }

        container blackboard "blackboard" {
            include *
        }

        deployment * "UQ Infrastructure" "UQI" {
            include *
        }

        styles {
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
            element smb {
                    shape Folder
                    background #e6f7c8
                    colour #000000
            }
            element f5 {
                    background #f7e8c8
                    colour #000000
            }
            element sinet {
                    background #d2fae7
                    colour #000000
            }
            element ldap {
                    background #deecfa
                    colour #000000
            }
            element sso {
                    background #fcf0e6
                    colour #000000
            }
            element queue {
                    shape Pipe
                    background #b6faf7
                    color #000000
                    icon https://raw.githubusercontent.com/tupadr3/plantuml-icon-font-sprites/master/devicons2/redis.png
            }
            element failover {
                    opacity 45
            }
        }

        themes default
    }

}
