# KeePass backup

Access .kdbx file from WebDAV and backup to a remote cloud storage such as Disk, WebDAV or SFTP.

<small>
<b>Prerequisites</b><br />
KeePass password manager installed, a command-line environment (Bash or PowerShell), and at least one active cloud storage account (Dropbox, Backblaze, Koofr, Cloudflare, etc.)
</small>

## Overview

KeePass is a popular way to manage passwords because your databas (.kdbx) is stoired offline, under your direct control, encrypted with military-grade algorithms. However, that high security introduces a critical vulnerability: human error and/or device failure.

Relying on manual file copies or forgetting to back up your database to a secure off-site location can lead to total data loss if a hard drive fails, a phone resets, or a laptop is misplaced. While commercial password managers handle synchronization automatically, they require you to surrender your master keys to third-party cloud servers.

The DIY backup solution described here was built to bridge that gap. It gives you the best of both worlds: complete local ownership of your encrypted database combined with automated, hands-off synchronization to your preferred cloud providers (such as Dropbox, Backblaze, Koofr, Cloudflare, etc.). No vendor lock-in, no hidden subscriptions - your digital vault is safe and always recoverable.

![Flow diagram](/diagram.png)

## Flow description

When you open KeePass, the latest version of your database is retrieved from a WebDAV server (or any remote location). This ensures you’re are always working with the most up-to-date information, regardless of your location or the number of devices you utilize.

Then the main idea is then to use [KeePass triggers](https://keepass.info/help/v2/triggers.html), which allows you to automate actions based on specific events (such as _saving the database_ or _exiting the application_).

Whenever you save your database, automated triggers are executed to ensure that your data is not only stored securely but also backed up on additional location. The first trigger creates a provisional temporary copy of the .kdbx file on your local machine. This copy serves as a safeguard during the backup process, ensuring that your working version remains intact.

Immediately after, the second trigger uploads this temporary copy to a designated location (WebDAV, SFTP, CDN, etc.). This step creates a secure backup of your database, providing an additional layer of protection by storing it in a different location.

When you’re done using KeePass and decide to exit the application, a final trigger is activated. This trigger automatically deletes the provisional temporary file created during the save process, ensuring that no unnecessary copies of your sensitive data remain on the device.

## How to use

<p>1) Install KeePass (<a href="https://keepass.info/help/v1/setup.html">Installation &raquo;</a>)</p>

<p>2) Open KeePass and go to <i>File</i> > <i>Open</i> > <i>Open URL...</i> and enter remote location of .kdbx file and credentials (if applicable). If you enter Username and Password then select prefered option for Remember field. Next time when you open KeePass you can open your .kdbx file from <i>File</i> > <i>Open Recent</i></p>

<p>3) Create a dedicated KeePass entry (e.g. DO-NOT-DELETE-T1) to store Remote Service credentials</p>

![KeePass entry](/cld-entry.jpg)

<p>4) Configure required KeePass triggers, go to <i>Tools</i> > <i>Triggers</i>...</p>

<p>4.1) Export database on save
  <pre>
- <b>Properties</b>
  - <i>Name</i>: Export database on save
  - <i>Enabled</i>: true
  - <i>Initially on</i>: true
- <b>Events</b>
  - <i>Event</i>: Saved database file
- <b>Conditions</b> - not used
- <b>Actions</b>
  - <i>Action</i>: Export active database
    - <i>File/URL</i>: location\to\store\{DB_BASENAME}.kdbx<sup>(1)</sup>
    - <i>File format</i>: KeePass KDBX (2.x)</pre>
  <span style="font-size:smaller;color:#999;"><i><sup>(1)</sup>Location where temp .kdbx file to be saved</i></span>
</p>

<p>4.2) Store database file on remote location
  <pre>
- <b>Properties</b>
  - <i>Name</i>: Store database file on remote location
  - <i>Enabled</i>: true
  - <i>Initially on</i>: true
- <b>Events</b>
  - <i>Event</i>: Saved database file
- <b>Conditions</b> - not used
- <b>Actions</b>
  - <i>Action</i>: Execute command line / URL
    - <i>File/URL</i>: path\to\git\git-bash.exe<sup>(1)</sup>
    - <i>Arguments</i>: path/to/yourscript.bash "location/to/store/{DB_BASENAME}.kdbx" "{DB_BASENAME}.kdbx" {REF:N@T:DO-NOT-DELETE-T1}<sup>(2)</sup>
    - <i>Wait for exit</i>: true
    - <i>Window style</i>: Maximized
  - <i>Action</i>: Show message box
    - <i>Main instructio</i>n: Database {DB_BASENAME} stored on remote location
    - <i>Icon</i>: None
    - <i>Buttons</i>: OK
    - <i>Default button</i>: Button 1
    - <i>Action - Condition</i>: Button OK/Yes
    - <i>Action</i>: None</pre>
  <span style="font-size:smaller;color:#999;"><i><sup>(1)</sup>Path to git-bash.exe; not tested with powershell</i><br />
  <i><sup>(2)</sup>Command to execute for uploading file to the remote location by using cUrl. Required command line arguments could vary based on the service e.g.<br />
- local path to file to be uploaded<br />
- Account/Cloud name<br />
- API key<br />
- API secret<br />
- Remote folder where file will be uploaded (optional)<br />
Note: Some sensitive data values are taken from the "Notes" field of a dedicated KeePass entry named for example "DO-NOT-DELETE-T1", ensuring that all credentials are securely stored within the KeePass database.<br />
Note: Set line endings to "LF" in Linux, not "CRLF"</i>
  </span>
</p>

<p>4.3) Delete temp file/s on exit
  <pre>
- <b>Properties</b>
  - <i>Name</i>: Delete temp file/s on exit
  - <i>Enabled</i>: true
  - <i>Initially on</i>: true
- <b>Events</b>
  - <i>Event</i>: Application exit
- <b>Conditions</b> - not used
- <b>Actions</b>
  - <i>Action</i>: Execute command line / URL
    - <i>File/URL</i>: %comspec%<sup>(1)</sup>
    - <i>Arguments</i>: /c del "C:\tmp\directory\*.kdbx"<sup>(2)</sup>
    - <i>Wait for exit</i>: true
    - <i>Window style</i>: Hidden</pre>
  <span style="font-size:smaller;color:#999;"><i><sup>(1)</sup>The command interpreter, which by default is cmd.exe in NT systems, and COMMAND.COM in DOS systems</i><br />
  <i><sup>(2)</sup>Command to execute with required arguments</i>
  </span>
</p>

## Useful KeePass configurations

- Database settings (Select database file then go to _File_ > _Database Settings_)
  - Security
  - Compression: `GZip`
  - Recycle Bin
    - Use a recycle bin: checked
- Advanced
  - Limit number of history items per entry: e.g. 2
  - Limit history size per entry (MB): e.g. 1<br />
  *both settings could reduce the overall size of the database*
- KeePass configurations (_Tools_ > _Options_)
  - Security
    - Clipboard auto-clear time (seconds; main entry list): e.g. 10
    - Clear clipboard when closing KeePass: checked
    - Do not store data in Windows clipboard: checked
    - Prevent certain screen captures: checked
- Advancced
  - Limit to single instance: checked

> [!NOTE]
> Keep a backup of your KeePass database in a separate location, ensuring you don't need credentials stored inside the KeePass database to access it.

## Resources

- [KeePass homepage](https://keepass.info/)
- [KeePass Installation/Portability](https://keepass.info/help/v1/setup.html)
- [KeePass triggers](https://keepass.info/help/v2/triggers.html)
- [KeePass FAQ](https://keepass.info/help/kb/faq.html)
- [StackOverflow KeePass questions](https://stackoverflow.com/questions/tagged/KeePass)
- [Writing on GitHub](https://docs.github.com/en/get-started/writing-on-github)
- [Docsify](https://docsify.js.org)
