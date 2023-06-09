set appName to "zoom.us"
set initialVersion to get version of application appName
set settingsFile to "us.zoom.xos.plist"
set userHome to path to home folder as text
set preferencesFolder to userHome & "Library:Preferences:"
set desktopFolder to path to desktop as text

repeat
	delay 60 -- Check every minute
	tell application "System Events"
		set appCount to count (every process whose name is appName)
	end tell
	
	if appCount > 0 then
		set currentVersion to get version of application appName
		if currentVersion is not equal to initialVersion then
			display notification "The version of " & appName & " has changed from " & initialVersion & " to " & currentVersion
			set initialVersion to currentVersion
			
			-- Save a copy of the app's user settings
			set settingsBackupFile to desktopFolder & settingsFile & " Backup " & ((current date) as string) & ".plist"
			tell application "Finder"
				duplicate file (preferencesFolder & settingsFile) to file settingsBackupFile
			end tell
			
			-- Restore user settings from the backup file
			tell application appName to quit
			delay 5 -- Wait for the app to quit
			tell application "Finder"
				delete file (preferencesFolder & settingsFile)
				duplicate file settingsBackupFile to file (preferencesFolder & settingsFile)
			end tell
			tell application appName to activate
		end if
	end if
end repeat
