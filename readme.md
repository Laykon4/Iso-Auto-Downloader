# ISO Auto-Downloader

### Automate the Download of Latest ISO Files (Only Linux Distro for now)

ISO Auto-Downloader is a tool designed to automate the process of fetching the latest versions of ISO files from specified sources. The tool checks for new releases, compares with locally stored files, and downloads updates only when a new version is available. This is ideal for users who need the most recent ISO versions without manually checking for updates.

## Features

- **Automated Version Check**: Detects the latest ISO version available from the specified URL.
- **Smart Downloading**: Downloads only when a new ISO version is available, saving bandwidth and storage.
- **Easy Scheduling**: Integrates with task schedulers (like Windows Task Scheduler or CRON) to run periodically.
  
## Getting Started

### Prerequisites

- **PowerShell (v5 or higher)** for running the script.
- **Internet Access** to fetch files from the specified URLs.
- **Permission to Write** to the target directory where ISO files will be saved.

### Installation

1. Clone the repository to your local machine on your desktop:

    ```bash
    git clone https://github.com/Laykon4/iso-auto-downloader.git
    ```

### Usage

1. Run the script directly in PowerShell:

    ```powershell
    powershell "path\to\your\ps1\file\iso-auto-downloader.ps1"
    ```

2. The script will:
   - Access the target URL directory.
   - Retrieve the latest ISO filename based on specified patterns.
   - Compare the latest remote version with any locally stored versions.
   - Download the new ISO file if an update is available.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
