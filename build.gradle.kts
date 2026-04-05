plugins {
    id("base")
    id("de.infolektuell.typst") version "0.8.0"
}

val timestamp = providers.of(GitCommitDateValueSource::class) {
    parameters {
        revision = "main"
    }
}

typst {
    creationTimestamp = timestamp.get()
}

typst.sourceSets {
    val shared by registering


    val practicalsDir = file("src/practicals")
    practicalsDir.listFiles { file -> file.isDirectory }?.forEach { folder ->
        register("practical" + folder.name.replaceFirstChar { if (it.isLowerCase()) it.titlecase() else it.toString() }) {
            root = layout.projectDirectory.dir("src/practicals/" + folder.name)
            destinationDir = layout.buildDirectory.dir("practicals/" + folder.name)
            documents = listOf("main")
        }
    }
}