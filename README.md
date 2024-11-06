# Chrome Bookmarks Backup & Restore using PowerShell

## Overview

**Chrome Bookmarks Backup & Restore** is a PowerShell script that allows users to easily back up and restore Chrome bookmarks. This script is perfect for users who want a quick way to save their Chrome bookmarks in JSON format or restore them from an existing backup file.

## Features

- **Backup Bookmarks**: Saves a backup of the Chrome bookmarks file to the user’s Documents folder with a filename that includes the user’s name.
- **Restore Bookmarks**: Allows the user to restore bookmarks from a previously created backup, with a File Explorer dialog for selecting the backup file.
- **User-Friendly Prompts**: Offers clear prompts for choosing backup or restore, and confirms overwrite actions to prevent accidental data loss.

## How to Use

1. **Run the Script**: Open PowerShell and run the script.
2. **Select Action**: You’ll be prompted to choose:
   - `1` to back up bookmarks to the Documents folder.
   - `2` to restore bookmarks from a backup file.
3. **Restore Confirmation**: When restoring, select the backup file using the File Explorer dialog. You’ll be prompted to confirm overwriting the current bookmarks.

> **Note**: Make sure Chrome is closed before running the script to avoid file lock issues.

## Script Details

### Parameters

- **Backup Destination**: Automatically saves the backup file in the user’s Documents folder.
- **File Selection for Restore**: Uses a File Explorer dialog to simplify the restore process.

## Requirements

- **PowerShell**: This script requires PowerShell and Windows Forms, which are available on most Windows systems.

## Author

**Mezba Uddin**

## Version

- **1.0**
- **Last Updated**: 2024-11-06

---

### Full Script: ChromeBookmarksBackupRestore.ps1

```powershell
# Load Windows Forms for File Explorer dialog
Add-Type -AssemblyName System.Windows.Forms

# Get the current user's name
$userName = $env:USERNAME

# Define the path to Chrome's default bookmarks file
$chromeProfilePath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default"
$bookmarksFile = Join-Path -Path $chromeProfilePath -ChildPath "Bookmarks"

# Define the default backup file path in the user's Documents folder
$defaultBackupDestination = "C:\Users\$userName\Documents\$userName - Chrome Bookmarks Backup.json"

# Ask user whether they want to backup or restore bookmarks
Write-Host "Please choose an option:"
Write-Host "1. Backup Chrome bookmarks"
Write-Host "2. Restore Chrome bookmarks"
$action = Read-Host -Prompt "Enter 1 or 2"

if ($action -eq "1") {
    # Backup bookmarks
    if (Test-Path $bookmarksFile) {
        # Copy the bookmarks file to the default backup destination
        Copy-Item -Path $bookmarksFile -Destination $defaultBackupDestination -Force
        Write-Host "Chrome bookmarks have been successfully backed up to $defaultBackupDestination"
    } else {
        Write-Host "Chrome bookmarks file not found. Please ensure Chrome is installed and has a profile with bookmarks."
    }
}
elseif ($action -eq "2") {
    # Restore bookmarks
    # Open a File Explorer dialog to select the backup file
    $fileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $fileDialog.InitialDirectory = "C:\Users\$userName\Documents"
    $fileDialog.Filter = "JSON files (*.json)|*.json|All files (*.*)|*.*"
    $fileDialog.Title = "Select the Chrome bookmarks backup file to restore"

    if ($fileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $backupFile = $fileDialog.FileName
        
        # Confirm the restoration with Y/N prompt (default to No)
        $confirmation = Read-Host -Prompt "Are you sure you want to overwrite your current bookmarks with this backup? (Y/N) [Default: N]"
        
        if ($confirmation -eq "Y") {
            # Copy the backup file to the Chrome profile folder, overwriting the current bookmarks file
            Copy-Item -Path $backupFile -Destination $bookmarksFile -Force
            Write-Host "Chrome bookmarks have been successfully restored from the selected backup."
        } else {
            Write-Host "Restoration canceled by user."
        }
    } else {
        Write-Host "No file was selected. Restoration canceled."
    }
}
else {
    Write-Host "Invalid selection. Please enter 1 to Backup or 2 to Restore."
}
