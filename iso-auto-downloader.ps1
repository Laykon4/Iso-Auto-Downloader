Clear-Host

#-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
# TODO                                                                                          /
#-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

$folderName = "IsoAD"
$desktopPath = "$env:USERPROFILE\desktop\$folderName"

if (Test-Path -Path $desktopPath) {
    Write-Host "The folder '$folderName' already exists on the desktop." -ForegroundColor Yellow
} else {
    Write-Host "The folder '$folderName' does not exist. Creating it now..." -ForegroundColor Green
    New-Item -ItemType Directory -Path $desktopPath
    Write-Host "The folder '$folderName' has been created at: $folderPath" -ForegroundColor Cyan
}

function debian {
    $distro = "Debian"

    if (Test-Path -Path "$desktopPath\$distro") {
        Write-Host "The folder '$distro' already exists on the IsoAD folder." -ForegroundColor Yellow
    } else {
        Write-Host "The folder '$distro' does not exist. Creating it now..." -ForegroundColor Green
        New-Item -ItemType Directory -Path "$desktopPath\$distro" | Out-Null
        Write-Host "The folder '$distro' has been created at: $folderPath\$distro" -ForegroundColor Cyan
    }

    $debianUrl = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/"
    $debianIsoPattern = "debian-[\d.]+-amd64-netinst\.iso"
    $debianLocalPath = "$env:USERPROFILE\desktop\$folderName\$distro\"
    $sha256LocalPath = "$env:USERPROFILE\desktop\$folderName\$distro\"
    $sha256Url = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/SHA256SUMS"

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
                Invoke-WebRequest -Uri $sha256Url -OutFile $sha256LocalPath

                $calcSha256 = (Get-FileHash -Path $latestIsoUrl -Algorithm SHA256).Hash
                $expectedSha256 = Select-String -Path $sha256LocalPath -Pattern ([System.IO.Path]::GetFileName($latestIsoUrl)) | ForEach-Object { $_ -replace "\s.*", "" }
                if ($calcSha256 -eq $expectedSha256) {
                    Write-Host "The file is valid :" -NoNewline
                    Write-Host " SHA-256 hash matches." -ForegroundColor Green
                } else {
                    Write-Host "The file is corrupted or modified :" -NoNewline
                    Write-Host " SHA-256 hash does not match." -ForegroundColor Red
                }
            
                Write-Host "Debian : The new files were downloaded :" -NoNewline
                Write-Host " $isoFile | SHA256SUMS" -ForegroundColor Green
            } else {
                Write-Host "Debian : The iso and sha256 file are already up to date."
            }
        } 
        else {
            Invoke-WebRequest -Uri $latestIsoUrl -OutFile $localPath
            Invoke-WebRequest -Uri $sha256Url -OutFile $sha256LocalPath

            Write-Host "Debian : The ISO and sha256 file did not exist locally and was downloaded :" -NoNewline
            Write-Host " $isoFile | SHA256SUMS" -ForegroundColor Green

            if ($calcSha256 -eq $expectedSha256) {
                Write-Host "The file is valid :" -NoNewline
                Write-Host " SHA-256 hash matches." -ForegroundColor Green
            } else {
                Write-Host "The file is corrupted or modified :" -NoNewline
                Write-Host " SHA-256 hash does not match." -ForegroundColor Red
            }
        }


    } else {
        Write-Host "Debian : No ISO files found in the directory." -ForegroundColor Red
    }
}

function kaliLinux {
    [Int] $version = Read-Host "Choose a version for Kali Linux (1 for Netinst | 2 for Complete)"
    switch ($version) {
        1 {$kaliIsoPattern = "kali-linux-[\d.]+-installer-netinst-amd64\.iso"}
        2 {$kaliIsoPattern = "kali-linux-[\d.]+-installer-amd64\.iso"}
    }
    
    $distro = "Kali Linux"

    if (Test-Path -Path "$desktopPath\$distro") {
        Write-Host "The folder '$distro' already exists on the IsoAD folder." -ForegroundColor Yellow
    } else {
        Write-Host "The folder '$distro' does not exist. Creating it now..." -ForegroundColor Green
        New-Item -ItemType Directory -Path "$desktopPath\$distro" | Out-Null
        Write-Host "The folder '$distro' has been created at: $folderPath\$distro" -ForegroundColor Cyan
    }

    $kaliUrl = "https://cdimage.kali.org/current/"
    $kaliLocalPath = "$env:USERPROFILE\desktop\$folderName\$distro\"
    $sha256Url = "https://cdimage.kali.org/kali-images/current/SHA256SUMS"
    $signedSha256Url = "https://cdimage.kali.org/kali-images/current/SHA256SUMS.gpg"
    $sha256LocalPath = "$env:USERPROFILE\desktop\$folderName\$distro\"
    $signedSha256Path = "$env:USERPROFILE\desktop\$folderName\$distro\"

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
                Invoke-WebRequest -Uri $sha256Url -OutFile $sha256LocalPath
                Invoke-WebRequest -Uri $signedSha256Url -OutFile $signedSha256Path
            
                Write-Host "Kali Linux : The new files were downloaded :" -NoNewline
                Write-Host " $isoFile | SHA256SUMS" -ForegroundColor Green

                $calcSha256 = (Get-FileHash -Path $latestIsoUrl -Algorithm SHA256).Hash
                $expectedSha256 = Select-String -Path $sha256LocalPath -Pattern ([System.IO.Path]::GetFileName($latestIsoUrl)) | ForEach-Object { $_ -replace "\s.*", "" }
                
                if ($calcSha256 -eq $expectedSha256) {
                    Write-Host "The file is valid :" -NoNewline
                    Write-Host " SHA-256 hash matches." -ForegroundColor Green
                } else {
                    Write-Host "The file is corrupted or modified :" -NoNewline
                    Write-Host " SHA-256 hash does not match." -ForegroundColor Red
                }

            } else {
                Write-Host "Kali Linux : The iso and sha256 filea are already up to date."
            }
        }else {
            Invoke-WebRequest -Uri $latestIsoUrl -OutFile $localPath
            Invoke-WebRequest -Uri $sha256Url -OutFile $sha256LocalPath
            Invoke-WebRequest -Uri $signedSha256Url -OutFile $signedSha256Path

            Write-Host "Kali Linux : The new files were downloaded :" -NoNewline
            Write-Host " $isoFile | SHA256SUMS" -ForegroundColor Green
            
            if ($calcSha256 -eq $expectedSha256) {
                Write-Host "The file is valid :" -NoNewline
                Write-Host " SHA-256 hash matches." -ForegroundColor Green
            } else {
                Write-Host "The file is corrupted or modified :" -NoNewline
                Write-Host " SHA-256 hash does not match." -ForegroundColor Red
            }
        }


    } else {
        Write-Host "Kali Linux : No ISO files found in the directory."
    } 
}

function ubuntu {
    $distro = "Ubuntu"

    if (Test-Path -Path "$desktopPath\$distro") {
        Write-Host "The folder '$distro' already exists on the IsoAD folder." -ForegroundColor Yellow
    } else {
        Write-Host "The folder '$distro' does not exist. Creating it now..." -ForegroundColor Green
        New-Item -ItemType Directory -Path "$desktopPath\$distro" | Out-Null
        Write-Host "The folder '$distro' has been created at: $folderPath\$distro" -ForegroundColor Cyan
    }

    $ubuntuUrl = "https://releases.ubuntu.com/"

    Write-Host "You selected Ubuntu. Proceeding with Ubuntu setup..."
    $response = Invoke-WebRequest -Uri $ubuntuUrl
    $pageContent = $response.Content

    $ubuntuPattern = "(?<=href=[""'])(\d{2}\.\d{2})(?=[""'/])"
    $isoFile = [regex]::Matches($pageContent, $ubuntuPattern) | ForEach-Object { $_.Value }

    $latestVersion = ($isoFile | Sort-Object -Descending)[0]
    $sha256Url = "$ubuntuUrl$latestVersion/SHA256SUMS"

    $latestIsoUrl = "$ubuntuUrl$latestVersion/ubuntu-$latestVersion-desktop-amd64.iso"
    $ubuntuLocalPath = "$env:USERPROFILE\desktop\$folderName\$distro\"
    $sha256LocalPath = "$env:USERPROFILE\desktop\$folderName\$distro\"


    if ($latestVersion) {
        $localPath = "$ubuntuLocalPath\ubuntu-$latestVersion-desktop-amd64.iso"

        if (Test-Path -Path $localPath) {
            $localLastModified = (Get-Item -Path $localPath).LastWriteTime

            $remoteLastModified = $response.Headers["Last-Modified"]

            if ($remoteLastModified -gt $localLastModified) {
                Invoke-WebRequest -Uri $latestIsoUrl -OutFile $localPath
                Invoke-WebRequest -Uri $sha256Url -OutFile $sha256LocalPath

                $calcSha256 = (Get-FileHash -Path $latestIsoUrl -Algorithm SHA256).Hash
                $expectedSha256 = Select-String -Path $sha256LocalPath -Pattern ([System.IO.Path]::GetFileName($ubuntuLocalPath)) | ForEach-Object { $_ -replace "\s.*", "" }
            
                # Comparer les deux hachages
                if ($calcSha256 -eq $expectedSha256) {
                    Write-Host "The file is valid :" -NoNewline
                    Write-Host " SHA-256 hash matches." -ForegroundColor Green
                } else {
                    Write-Host "The file is corrupted or modified :" -NoNewline
                    Write-Host " SHA-256 hash does not match." -ForegroundColor Red
                }
            
                Write-Host "Ubuntu : The new files were downloaded :" -NoNewline
                Write-Host " ubuntu-$latestVersion-desktop-amd64.iso | SHA256SUMS" -ForegroundColor Green
            } else {
                Write-Host "Ubuntu : The iso and sha256 files ire already up to date."
            }
        } else {
            Invoke-WebRequest -Uri $latestIsoUrl -OutFile $localPath
            Invoke-WebRequest -Uri $sha256Url -OutFile $sha256LocalPath
        
            # Comparer les deux hachages
            if ($calcSha256 -eq $expectedSha256) {
                Write-Host "The file is valid :" -NoNewline
                Write-Host " SHA-256 hash matches." -ForegroundColor Green
            } else {
                Write-Host "The file is corrupted or modified :" -NoNewline
                Write-Host " SHA-256 hash does not match." -ForegroundColor Red
            }

            Write-Host "Ubuntu : The files did not exist locally and were downloaded :" -NoNewline
            Write-Host " ubuntu-$latestVersion-desktop-amd64.iso | SHA256SUMS" -ForegroundColor Green
        }

    } 


    else {
        Write-Host "Ubuntu : No ISO files found in the directory." -ForegroundColor Red
    } 
}

function dlAll {
    debian
    kaliLinux
    ubuntu
}

function archLinux {
    $distro = "Arch Linux"

    if (Test-Path -Path "$desktopPath\$distro") {
        Write-Host "The folder '$distro' already exists on the IsoAD folder." -ForegroundColor Yellow
    } else {
        Write-Host "The folder '$distro' does not exist. Creating it now..." -ForegroundColor Green
        New-Item -ItemType Directory -Path "$desktopPath\$distro" | Out-Null
        Write-Host "The folder '$distro' has been created at: $folderPath\$distro" -ForegroundColor Cyan
    }

    $archUrl = "https://geo.mirror.pkgbuild.com/iso/latest/"
    $archIsoPattern = "archlinux-\d{4}\.\d{2}\.\d{2}-x86_64\.iso"
    $archLocalPath = "$env:USERPROFILE\desktop\$folderName\$distro\"
    $sha256Url = "https://geo.mirror.pkgbuild.com/iso/latest/sha256sums.txt"
    $sha256LocalPath = "$env:USERPROFILE\desktop\$folderName\$distro\"

    Write-Host "You selected Arch Linux. Proceeding with Arch Linux setup..."
    $response = Invoke-WebRequest -Uri $archUrl
    $pageContent = $response.Content

    $isoFile = [regex]::Match($pageContent, $archIsoPattern).Value

    if ($isoFile) {
        $latestIsoUrl = "$archUrl$isoFile"
        $localPath = "$archLocalPath$isoFile"

        if (Test-Path -Path $localPath) {
            $localLastModified = (Get-Item -Path $localPath).LastWriteTime
            $remoteLastModified = $response.Headers["Last-Modified"]

            if ($remoteLastModified -gt $localLastModified) {
                Invoke-WebRequest -Uri $latestIsoUrl -OutFile $localPath
                Invoke-WebRequest -Uri $sha256Url -OutFile "$sha256LocalPath\sha256sums.txt"
            
                # Correction de la vérification SHA-256
                $calcSha256 = (Get-FileHash -Path $localPath -Algorithm SHA256).Hash.ToLower()
                $expectedSha256 = Get-Content "$sha256LocalPath\sha256sums.txt" | 
                    Where-Object { $_ -match "$isoFile$" } | 
                    ForEach-Object { ($_ -split '\s+')[0] }
            
                if ($calcSha256 -eq $expectedSha256) {
                    Write-Host "The file is valid :" -NoNewline
                    Write-Host " SHA-256 hash matches." -ForegroundColor Green
                } else {
                    Write-Host "The file is corrupted or modified :" -NoNewline
                    Write-Host " SHA-256 hash does not match." -ForegroundColor Red
                    Write-Host "Expected: $expectedSha256" -ForegroundColor Yellow
                    Write-Host "Got: $calcSha256" -ForegroundColor Yellow
                }

                Write-Host "Arch Linux : The new files were downloaded :" -NoNewline
                Write-Host " $isoFile | sha256sums.txt" -ForegroundColor Green
            } else {
                Write-Host "Arch Linux : The iso and sha256 files are already up to date."
            }
        } else {
            # Appliquer la même correction pour le cas où le fichier n'existe pas
            Invoke-WebRequest -Uri $latestIsoUrl -OutFile $localPath
            Invoke-WebRequest -Uri $sha256Url -OutFile "$sha256LocalPath\sha256sums.txt"

            $calcSha256 = (Get-FileHash -Path $localPath -Algorithm SHA256).Hash.ToLower()
            $expectedSha256 = Get-Content "$sha256LocalPath\sha256sums.txt" | 
                Where-Object { $_ -match "$isoFile$" } | 
                ForEach-Object { ($_ -split '\s+')[0] }

            if ($calcSha256 -eq $expectedSha256) {
                Write-Host "The file is valid :" -NoNewline
                Write-Host " SHA-256 hash matches." -ForegroundColor Green
            } else {
                Write-Host "The file is corrupted or modified :" -NoNewline
                Write-Host " SHA-256 hash does not match." -ForegroundColor Red
                Write-Host "Expected: $expectedSha256" -ForegroundColor Yellow
                Write-Host "Got: $calcSha256" -ForegroundColor Yellow
            }

            Write-Host "Arch Linux : The ISO and sha256 file did not exist locally and was downloaded :" -NoNewline
            Write-Host " $isoFile | sha256sums.txt" -ForegroundColor Green
        }
    }
    else {
        Write-Host "Arch Linux : No ISO files found in the directory." -ForegroundColor Red
    }
}

Get-ChildItem 
$choice = Read-Host "Choose an OS type : `n 1 - Debian `n 2 - Kali Linux `n 3 - Ubuntu `n 4 - Arch Linux `n 99 - Download all `n Your choice "

$osType = switch ($choice) {
    "1" { debian }
    "2" { kaliLinux }
    "3" { ubuntu }
    "4" { archLinux }
    "99" {dlAll}
    Default { "Unknown" }
}

