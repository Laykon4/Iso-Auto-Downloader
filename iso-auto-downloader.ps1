Clear-Host
$stamp = (Get-Date).toString("yyyy-MM-dd -- HH.mm.ss")
$logfilepath="F:\ScriptISO\report_$stamp.log"
$logmessage= "###### DEBUT DU SCRIPT ######" 

$choice = Read-Host "Choose an OS type : `n 1 - Debian `n 2 - Kali Linux `n 3 - Ubuntu `n Your choice "

$osType = switch ($choice) {
    "1" { "Debian" }
    "2" { "Kali Linux" }
    "3" { "Ubuntu" }
    Default { "Unknown" }
}

if ($osType -eq "Debian") {

    $debianUrl = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/"
    $debianIsoPattern = "debian-[\d.]+-amd64-netinst\.iso"
    $debianLocalPath = "F:\ScriptISO\debian\"

    Write-Host "You selected Debian. Proceeding with Debian setup..."
    $response = Invoke-WebRequest -Uri $debianUrl
    $pageContent = $response.Content

    $isoFile = [regex]::Match($pageContent, $debianIsoPattern).Value

    if ($isoFile) {
        $latestIsoUrl = "$debianUrl$isoFile"
        $localPath = "$debianLocalPath$isoFile"

        if (Test-Path -Path $localPath) {
            $localLastModified = (Get-Item -Path $localPath).LastWriteTime

            $remoteLastModified = $response.Headers["Last-Modified"]
            $remoteLastModifiedDate = [DateTime]::ParseExact($remoteLastModified, "R", $null)

            if ($remoteLastModifiedDate -gt $localLastModified) {
                Invoke-WebRequest -Uri $latestIsoUrl -OutFile $localPath
            
                $logmessage= "The new iso file was downloaded : $isoFile"
            } else {
                $logmessage= "The iso file is already up to date."
            }
        }else {
            Invoke-WebRequest -Uri $latestIsoUrl -OutFile $localPath
            $logmessage= "The ISO file did not exist locally and was downloaded : $isoFile"
        }


    } else {
        $logmessage= "No ISO files found in the directory."
}



} 

elseif ($osType -eq "Kali Linux") {

    [Int] $version = Read-Host "Choose a version for Kali Linux (1 for Netinst | 2 for Complete)"
    switch ($version) {
        1 {$kaliIsoPattern = "kali-linux-[\d.]+-installer-netinst-amd64\.iso"}
        2 {$kaliIsoPattern = "kali-linux-[\d.]+-installer-amd64\.iso"}
    }

    $kaliUrl = "https://cdimage.kali.org/current/"
    $kaliLocalPath = "F:\ScriptISO\kali\"

    Write-Host "You selected Kali Linux. Proceeding with Kali Linux setup..."
    $response = Invoke-WebRequest -Uri $kaliUrl
    $pageContent = $response.Content

    $isoFile = [regex]::Match($pageContent, $kaliIsoPattern).Value

    if ($isoFile) {
        $latestIsoUrl = "$kaliUrl$isoFile"
        $localPath = "$kaliLocalPath$isoFile"

        if (Test-Path -Path $localPath) {
            $localLastModified = (Get-Item -Path $localPath).LastWriteTime

            $remoteLastModified = $response.Headers["Last-Modified"]

            if ($remoteLastModified -gt $localLastModified) {
                Invoke-WebRequest -Uri $latestIsoUrl -OutFile $localPath
            
                $logmessage= "The new iso file was downloaded : $isoFile"
            } else {
                $logmessage= "The iso file is already up to date."
            }
        }else {
            Invoke-WebRequest -Uri $latestIsoUrl -OutFile $localPath
            $logmessage= "The ISO file did not exist locally and was downloaded : $isoFile"
        }


    } else {
        $logmessage= "No ISO files found in the directory."
}

}

elseif ($osType -eq "Ubuntu") {

    $ubuntuUrl = "https://releases.ubuntu.com/"

    $response = Invoke-WebRequest -Uri $ubuntuUrl
    $pageContent = $response.Content

    $ubuntuPattern = "(?<=href=[""'])(\d{2}\.\d{2})(?=[""'/])"
    $isoFile = [regex]::Matches($pageContent, $ubuntuPattern) | ForEach-Object { $_.Value }

    $latestVersion = ($isoFile | Sort-Object -Descending)[0]

    $latestIsoUrl = "$ubuntuUrl$latestVersion/ubuntu-$latestVersion-desktop-amd64.iso"
    $ubuntuLocalPath = "F:\ScriptISO\ubuntu"


    if ($latestVersion) {
        $localPath = "$ubuntuLocalPath\ubuntu-$latestVersion-desktop-amd64.iso"

        if (Test-Path -Path $localPath) {
            $localLastModified = (Get-Item -Path $localPath).LastWriteTime

            $remoteLastModified = $response.Headers["Last-Modified"]

            if ($remoteLastModified -gt $localLastModified) {
                Invoke-WebRequest -Uri $latestIsoUrl -OutFile $localPath
            
                $logmessage= "The new iso file was downloaded : $latestIsoUrl"
            } else {
                $logmessage= "The iso file is already up to date."
            }
        } else {
            Invoke-WebRequest -Uri $latestIsoUrl -OutFile $localPath
            $logmessage= "The ISO file did not exist locally and was downloaded : $latestIsoUrl"
        }
    } 

    else {
        $logmessage= "No ISO files found in the directory."
    }
}

else {
    Write-Host "Invalid choice. Please select a valid option."
}


$stamp + " : " + $logmessage >> $logfilepath
