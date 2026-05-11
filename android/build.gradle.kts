import org.gradle.api.Action
import org.gradle.api.Project

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    val configureAndroid = Action<Project> {
        extensions.findByType<com.android.build.gradle.BaseExtension>()?.apply {
            compileSdkVersion(36)
            buildToolsVersion("35.0.0")
            defaultConfig.targetSdkVersion(36)
            
            if (this is com.android.build.gradle.LibraryExtension && namespace == null) {
                namespace = "com.noor.zenthra.${project.name.replace("-", "_")}"
            }
        }
        
        // Workaround for AGP 8.0+ manifest issue
        tasks.matching { it.name.contains("Manifest") }.configureEach {
            doFirst {
                val manifestFile = file("src/main/AndroidManifest.xml")
                if (manifestFile.exists()) {
                    val content = manifestFile.readText()
                    if (content.contains("package=")) {
                        manifestFile.writeText(content.replace(Regex("package=\"[^\"]*\""), ""))
                    }
                }
            }
        }
    }

    if (state.executed) {
        configureAndroid.execute(this)
    } else {
        afterEvaluate(configureAndroid)
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
