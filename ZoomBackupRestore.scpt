on run
	set appName to "zoom.us"
	set settingsFile to "us.zoom.xos.plist"
	
	set initialVersion to get version of application appName
	set userHome to path to home folder as text
	set preferencesFolder to userHome & "Library:Preferences:"
	set desktopFolder to path to desktop as text
	
	repeat while true
		tell application "System Events"
			set appCount to count (every process whose name is appName)
		end tell
		
		if appCount > 0 then
			set currentVersion to get version of application appName
			if currentVersion is not equal to initialVersion then
				set notificationMessage to "The version of " & appName & " has changed from " & initialVersion & " to " & currentVersion
				display notification notificationMessage
				
				set initialVersion to currentVersion
				
				-- Save a copy of the app's user settings
				set settingsBackupFile to desktopFolder & settingsFile & " Backup " & ((current date) as string) & ".plist"
				try
					tell application "Finder"
						if exists file (preferencesFolder & settingsFile) then
							duplicate file (preferencesFolder & settingsFile) to file settingsBackupFile
						else
							display notification "Settings file not found: " & settingsFile
						end if
					end tell
				on error errMsg
					display notification "Error backing up settings: " & errMsg
				end try
				
				-- Restore user settings from the backup file
				tell application appName to quit
				delay 5 -- Wait for the app to quit
				try
					tell application "Finder"
						if exists file settingsBackupFile then
							delete file (preferencesFolder & settingsFile)
							duplicate file settingsBackupFile to file (preferencesFolder & settingsFile)
						else
							display notification "Settings backup file not found: " & settingsBackupFile
						end if
					end tell
				on error errMsg
					display notification "Error restoring settings: " & errMsg
				end try
				
				tell application appName to activate
			end if
		end if
		
		delay 60 -- Check every minute
	end repeat
end run
