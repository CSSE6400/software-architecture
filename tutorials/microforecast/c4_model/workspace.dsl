workspace "MicroForecast" "Example microkernel architecture for hyper-local weather forecasting." {
    model {
        observer = person "Forecast Observer" "Someone who wishes to find out a local weather forecast." "user"
		phone = softwareSystem "Mobile Phone" "Phone acting as sensor and interface." "phone"
		browser = softwareSystem "Web Browser" "Web interface to forecasts." "browser"
		tempSensor = softwareSystem "Temperature Sensor" "Physical sensor that collects temperature data."
		
        microForecast = softwareSystem "Weather Forecast System" "Sytem that makes weather forecasts." {
            core = container "Core Forecast System" "Make weather forecasts for a location." "" "core" {
				dataMgt = component "Weather Data Management" "Store and retrieve weather data." "" "core"
				presentation = component "Presentation Layer" "Present weather forecasts." "" "core"
				forecastRegistry = component "Forecast Plug-In Registry" "" "" "core"
				sourceRegistry = component "Source Plug-In Registry" "" "" "core"
				presentationRegistry = component "Presentation Plug-In Registry" "" "" "core"
			}
            forecasting = container "Forecast Weather" "Make weather forecasts for a location." "" "core" {
				rainForecast = component "Forecast Rain" "" "" "core"
				temperatureForecast = component "Forecast Temperature" "" "" "core"
			}
            temperatureSource = container "Temperature Data Source" "Plug-In providing temperature data." "" "plugin" {
				temperatureSensor = component "Temperature Data Sensor" "Sensor that provides current temperature." "" "plugin"
			}
            phonePlugins = container "Phone Plug-In" "Plug-Ins for phones." "" "plugin" {
				phoneSource = component "Phone Data" "Data from mobile phone (e.g. temperature, barometric pressure, humidity)." "" "plugin"
				phonePresentation = component "Phone Presentation" "Get weather forecast to display on phone." "" "plugin"
			}
            humidityPlugin = container "Humidity Data Source" "Plug-In providing humidity data." "" "plugin" {
				humiditySensor = component "Humidity Data Sensor" "Sensor that provides current humidity." "" "plugin"
				humidityProcessing = component "Process Humidity Data" "Processes humidity data to provide data for weather forecasting." "" "plugin"
			}
            windPlugin = container "Wind Data Source" "Plug-In providing wind speed and direction data." "" "plugin" {
				windSensor = component "Wind Data Sensor" "Sensor that provides current wind speed and direction." "" "plugin"
				windProcessing = component "Process Wind Data" "Processes wind speed and direction data to provide data for weather forecasting." "" "plugin"
			}
            precipitationPlugin = container "Precipitation Data Source" "Plug-In providing precipitation data." "" "plugin" {
				precipitationSensor = component "Precipitation Data Sensor" "Sensor that provides amount of precipitation over a time period." "" "plugin"
				precipitationProcessing = component "Process Precipitation Data" "Processes precipitation data to provide data for weather forecasting." "" "plugin"
			}
            videoPlugin = container "Video Data Source" "Plug-In providing visual data." "" "plugin" {
				videoSensor = component "Camera" "Camera returning video image of a location." "" "plugin"
				videoProcessing = component "Process Video Data" "Processes video data to provide data for weather forecasting." "" "plugin"
			}
			weatherDB = container "Weather Database" "Stores data used to make forecasts and resulting predictions." "NoSQL" "db"
		}

        # System Relationships
		observer -> phone "Get Weather Forecast"
		observer -> browser "Get Weather Forecast"
		phone -> phoneSource "Send Weather Data"
		phone -> phonePresentation "Get Weather Forecast"
		browser -> presentation "Get Weather Forecast"

        # Register Plug-Ins
		temperatureSource -> sourceRegistry "Register"
		phoneSource -> sourceRegistry "Register"
		phonePresentation -> presentationRegistry "Register"
		rainForecast -> forecastRegistry "Register"
		temperatureForecast -> forecastRegistry "Register"

        # Receive Data from Sensors
		tempSensor -> temperatureSensor "Send Temperature"
		temperatureSensor -> dataMgt "Save Temperature"
		phoneSource -> dataMgt "Save Phone Data"
		dataMgt -> weatherDB "Store Weather Data"

		# Forecast Weather
		phonePresentation -> forecastRegistry "Get Forecast Options"
		phonePresentation -> forecasting "Get Weather Forecasts"

        deploymentEnvironment "MicroForecast" {
            deploymentNode "Weather Database" {
                dbInstance = containerInstance weatherDB
            }
            deploymentNode "Weather Forecasting System" {
                coreInstance = containerInstance core
                forecastingInstance = containerInstance forecasting
                tempSrcInstance = containerInstance temperatureSource
                phonePluginsInstance = containerInstance phonePlugins
            }
            deploymentNode "Temperature Sensor" {
                tempSensorInstance = softwareSystemInstance tempSensor
            }
            deploymentNode "Mobile Phone" {
                phoneInstance = softwareSystemInstance phone
            }
            deploymentNode "Web Browser" {
                browserInstance = softwareSystemInstance browser
            }
        }
   }

    views {
        systemLandscape "overall_context" "MicroForecast System" {
            include *
#            autoLayout lr
        }

        container microForecast "microForecast_container" {
            include *
#            autoLayout lr
        }

        component core "core_component" {
            include *
#            autoLayout tb
        }

        component forecasting "forecasting_component" {
            include *
#            autoLayout lr
        }

        deployment * "MicroForecast" "deployment" {
            include *
#            autoLayout tb
        }

        styles {
            element "Software System" {
                shape Box
                background #c0a2fc
            }
            element "Container" {
                shape RoundedBox
                background #c5d8fc
            }
            element "Component" {
                shape Component
                background #c5d8fc
            }
            element user {
                shape Person
                background #02540b
                /* colour is text colour. */
                colour #ffffff
            }
            element db {
                shape Cylinder
                background #01057a
                /* colour is text colour. */
                colour #ffffff
            }
			# Microkernel Styles
            element core {
                background #b6d8fa
            }
            element plugin {
                background #b6faf7
            }
			# Domain Styles
            element video {
                background #f7e8c8
            }
            element audio {
                background #e6f7c8
            }
            element nav {
                background #d2fae7
            }
            element libmgt {
                background #fcebfc
            }
            element ui {
                background #fadee0
            }
        }
    }   
}
