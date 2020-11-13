node('per0dvoy69') {

    stage('Stage 0 - Artifact Resolving'){
        artifactResolver artifacts: [artifact(artifactId: '${ARTIFACT_ID}', 
        classifier: '${CLASSIFIER}', extension: 'zip', groupId: '${GROUP_ID}', 
        targetFileName: '${CLASSIFIER}_Enovia.zip', version: '${VERSION}')], 
        releaseUpdatePolicy: 'always', snapshotUpdatePolicy: 'always', 
        targetDirectory: 'd:\\ds\\slave\\build'
    }
    
    stage('Stage 1 - Build Expansion'){
        powershell "d:/ds/slave/scripts/stage1_logs_build.ps1"
    }
    stage('Stage 2 - One Time Script'){
        powershell "d:/ds/slave/scripts/stage2_ots.ps1"
    }
    stage('Stage 3 - Set config.xml'){
        powershell "d:/ds/slave/scripts/stage3_config.ps1"
    }
    stage('Stage 4 - Pakage Import | Spinner | Staging'){
        powershell "d:/ds/slave/scripts/stage4_packagespinnerstaging.ps1"
    }
    stage('Stage 5 - Post Spinner | Error Check'){
        powershell "d:/ds/slave/scripts/stage5_postspinnererrorcheck.ps1"
    }
    stage('Stage 6 - Build Deploy | Compile JPO'){
        powershell "d:/ds/slave/scripts/stage6_builddeployjpo.ps1"
    }
}
