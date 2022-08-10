$lastGitHash = git log --pretty=format:"%h" -1
Write-Output "Deploying Flutter Application to Raspberry Pi { commit hash: $lastGitHash }"
if (Test-Connection -ComputerName 10.180.73.17 -Count 1) {
    Write-Output "Connection to raspberrpi established."

    flutter build bundle
    Write-Output "Builded flutter bundle."

    ssh pi@raspberrypi "mkdir /home/pi/flutter_app_$lastGitHash"
    Write-Output "Created directory on remote for the latest version of app."

    scp -r ./build/flutter_assets/ pi@raspberrypi:/home/pi/flutter_app_$lastGitHash
    Write-Output "Copied application assets to raspberry."

    ssh pi@raspberrypi "flutter-pi /home/pi/flutter_app_$lastGitHash/flutter_assets"
    Write-Output "Tried to launch app on raspberry."
} else {
    Write-Output "Connection failed."
}