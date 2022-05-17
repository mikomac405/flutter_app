$lastGitHash = git log --pretty=format:"%h" -1
Write-Output "Deploying Flutter Application to Raspberry Pi { commit hash: $lastGitHash }"
if (Test-Connection -ComputerName raspberrypi.local -Count 1) {
    Write-Output "Connection to raspberrpi established."

    flutter build bundle
    Write-Output "Builded flutter bundle."

    ssh build@raspberrypi "mkdir /home/build/flutter_app_$lastGitHash"
    Write-Output "Created directory on remote for the latest version of app."

    scp -r ./build/flutter_assets/ build@raspberrypi:/home/build/flutter_app_$lastGitHash
    Write-Output "Copied application assets to raspberry."

    ssh build@raspberrypi "flutter-pi /home/build/flutter_app_$lastGitHash/flutter_assets"
    Write-Output "Tried to launch app on raspberry."
} else {
    Write-Output "Connection failed."
}