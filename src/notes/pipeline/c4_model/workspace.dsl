workspace "Pipeline Architecture" "An example pipeline architecture." {
    model {
        customer = person "Visitor" "Someone who visits the website."
		
		site = softwareSystem "Web Site" "Website from which usage data is collected." {
			webSite = container "Web Site" "Website from which usage data is collected." {
				event = component "Activity Event" "source" "" "source"
				tagTime = component "Tag Time" "filter" "" "transformer"
				eventCache = component "Event Cache" "filter" "" "transformer"
			}
			userAnalytics = container "User Analytics" "Analyse users' activity" {
				tagPage = component "Tag Page" "filter" "" "tester"
				storeUserEvents = component "Store Events" "filter" "" "transformer"
				userDB = component "User Analytics" "consumer" "" "consumer"
			}
			pageAnalytics = container "Page Analytics" "Analyse page activity" {
				anon = component "Anonymise" "filter" "" "tester"
				storePageEvents = component "Store Events" "filter" "" "transformer"
				pageDB = component "Page Analytics" "consumer" "" "consumer"
			}
		}

		# Pipeline relationships
        event -> tagTime
		tagTime -> eventCache
		eventCache -> tagPage
		eventCache -> anon
		tagPage -> storeUserEvents
		storeUserEvents -> userDB
		anon -> storePageEvents
		storePageEvents -> pageDB
    }

    views {
		component webSite "webSite_component_diagram" {
			include *
			autoLayout lr
		}

        dynamic webSite "activity_logging" "Activity Logging Pipeline" {
			event -> tagTime
			tagTime -> eventCache
			eventCache -> tagPage
			eventCache -> anon
			tagPage -> storeUserEvents
			storeUserEvents -> userDB
			anon -> storePageEvents
			storePageEvents -> pageDB
#            autoLayout tb
        }

		styles {
			element source {
				background #b9b6fa
				/* colour is text colour. */
				colour #000000
			}
			element transformer {
				background #b6d8fa
				/* colour is text colour. */
				colour #000000
			}
			element tester {
				background #b6faf7
				/* colour is text colour. */
				colour #000000
			}
			element consumer {
				shape Cylinder
				background #bfffda
				/* colour is text colour. */
				colour #000000
			}
		}
    }   
}
