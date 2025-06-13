// Remova qualquer bloco ou linha relacionada a NDK ou ndkVersion deste arquivo.
// Este arquivo deve conter apenas configurações globais e repositórios.
// O erro do NDK ocorre porque algum build.gradle está tentando usar um NDK corrompido ou não instalado corretamente.
// Para projetos Flutter padrão, não é necessário configurar NDK manualmente.

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
