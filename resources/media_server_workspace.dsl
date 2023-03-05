workspace "Media Server" "Example microkernel architecture for a simple media server." {
    model {
        consumer = person "Media Consumer" "Someone who watches media via the server." "user"
		
        renderer = softwareSystem "Media Renderer" "Device or software that plays media." {
            renderCore = container "Core Rendering System" "Provide navigation and playback of media library." "" "core" {
				ui = component "User Interface" "" "" "ui"
				playVideo = component "Play Video Stream" "" "" "video"
				playAudio = component "Play Audio Stream" "" "" "audio"
				rendererRegistry = component "Plug-In Registry" "" "" "core"
			}
            uiPlugins = container "UI Plug-Ins" "User interface extensions." "" "ui" {
				homeTheatre = component "Home Theatre UI" "UI adapted for home theatre environments and remote controls." "" "ui"
				browser = component "Browser UI" "UI adapted for use in a web browser." "" "ui"
			}
		}

        mediaServer = softwareSystem "Media Server" "Delivers media to renderers." {
            serverCore = container "Core Media Server" "Manage and stream media library." "" "core" {
				libMgt = component "Library Management" "" "" "libmgt" 
				nav = component "Library Navigation" "" "" "nav"
				videoStream = component "Video Streaming" "" "" "video"
				audioStream = component "Audio Streaming" "" "" "audio"
				serverRegistry = component "Plug-In Registry" "" "" "core"
			}
            libMgtPlugins = container "Library Management Plug-Ins" "Extensions for managing media library" "" "libmgt" {
				tvdb = component "TVDB Scraper" "" "" "libmgt"
				tmdb = component "TMDB Scraper" "" "" "libmgt"
				musicBrainz = component "MusicBrainz Scraper" "" "" "libmgt"
			}
            videoStreamPlugins = container "Video Streaming Plug-Ins" "Decoding of different types of video data." "" "video" {
				h264 = component "AVC (H.264) Decoding" "" "" "video"
				h265 = component "HEVC (H.265) Decoding" "" "" "video"
			}
            audioStreamPlugins = container "Audio Streaming Plug-Ins" "Decoding of different types of audio data." "" "audio" {
				flac = component "FLAC Decoding" "" "" "audio"
				mp3 = component "MP3 Decoding" "" "" "audio"
			}
            navPlugins = container "Navigation Plug-Ins" "Extensions to customise library navigation." "" "nav"
        }
        
        db = softwareSystem "Library Database" "Stores metadata about media files." "db"
        files = softwareSystem "File System" "Location of media files." "file"

        # System Relationships
		consumer -> renderer "Watch Media"
		renderer -> mediaServer "Obtains Media to Play"
		mediaServer -> db "Store and Retrieve Library Metadata"
		mediaServer -> files "Access Media Files"

        # Media Renderer Relationships
		consumer -> ui "Browse & Watch Media"
		ui -> uiPlugins "User Interaction"
		ui -> nav "Display Library"
		uiPlugins -> rendererRegistry "Register"
		playVideo -> videoStream "Play Video Stream"
		playAudio -> audioStream "Play Audio Stream"

        # Media Server Relationships
		libMgtPlugins -> serverRegistry "Register"
		videoStreamPlugins -> serverRegistry "Register"
		audioStreamPlugins -> serverRegistry "Register"
		navPlugins -> serverRegistry "Register"
		libMgt -> tvdb "Scrape Metadata"
		libMgt -> tmdb "Scrape Metadata"
		libMgt -> musicBrainz "Scrape Metadata"
		nav -> navPlugins "Navigate"
		videoStream -> videoStreamPlugins "Obtain video data stream."
		audioStream -> audioStreamPlugins "Obtain audio data stream."
		videoStreamPlugins -> files "Load video data stream."
		audioStreamPlugins -> files "Load audio data stream."
		libMgtPlugins -> db "Update Metadata"
		navPlugins -> db "Retrieve Metadata"

        deploymentEnvironment "Media Server" {
            deploymentNode "Metadata" {
                dbInstance = softwareSystemInstance db
            }

            deploymentNode "File System" {
                filesInstance = softwareSystemInstance files
            }

            deploymentNode "Media Renderer" {
                renderCoreInstance = containerInstance renderCore
                uiPluginsInstance = containerInstance uiPlugins
            }

            deploymentNode "Media Server" {
                serverCoreInstance = containerInstance serverCore
                libMgtPluginsInstance = containerInstance libMgtPlugins
                videoStreamPluginsInstance = containerInstance videoStreamPlugins
                audioStreamPluginsInstance = containerInstance audioStreamPlugins
                navPluginsInstance = containerInstance navPlugins
            }
        }
   }

    views {
        systemLandscape "overall_context" "Media playback ecosystem." {
            include *
#            autoLayout lr
        }

        container renderer "renderer_container" {
            include *
#            autoLayout lr
        }

        container mediaServer "media_server_container" {
            include *
#            autoLayout tb
        }

        component serverCore "media_server_core_component" {
            include *
#            autoLayout lr
        }

        component renderCore "render_core_component" {
            include *
#            autoLayout lr
        }

        component libMgtPlugins "libmgt_component" {
            include *
#            autoLayout tb
        }

        deployment * "Media Server" "deployment" {
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
            element file {
                shape Folder
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
