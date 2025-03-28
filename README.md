# keepass-backup
Access .kdbx file from WebDAV and backup on a CDN.

## Overview

![Flow diagram](/diagram.png)

When you open Keepass, the latest version of your database is retrieved from a WebDAV server (or any remote location). This ensures you’re are always working with the most up-to-date information, regardless of your location or the number of devices you utilize.

Then the main idea is to use KeePass triggers, which allow you to automate actions based on specific events (such as saving the database or exiting the application). 

Whenever you save your database, automated triggers are executed to ensure that your data is not only stored securely but also backed up on additional location. The first trigger creates a provisional temporary copy of the .kdbx file on your local machine. This copy serves as a safeguard during the backup process, ensuring that your working version remains intact.

Immediately after, the second trigger uploads this temporary copy to a designated CDN (Content Delivery Network). This step creates a secure backup of your database, providing an additional layer of protection by storing it in a different location.

When you’re done using Keepass and decide to exit the application, a final trigger is activated. This trigger automatically deletes the provisional temporary file created during the save process, ensuring that no unnecessary copies of your sensitive data remain on the device.

## How to use

<p>1) Install KeePass (<a href="https://keepass.info/help/v1/setup.html">Installation &raquo;</a>)</p>

<p>2) Open KeePass and go to <i>File</i> > <i>Open</i> > <i>Open URL...</i> and enter remote location of .kdbx file and credentials (if applicable). If you enter Username and Password then select prefered option for Remember field. Next time when you open KeePass you can open your .kdbx file from <i>File</i> > <i>Open Recent</i></p>

<p>3) Create a dedicated KeePass entry (DO-NOT-DELETE-T1, <a href="/cld-entry.jpg">cld-entry.jpg</a>) to store Cloudinary credentials</p>

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

<p>4.2) Store database file on remote CDN
  <pre>
- <b>Properties</b>
  - <i>Name</i>: Store database file on remote CDN
  - <i>Enabled</i>: true
  - <i>Initially on</i>: true
- <b>Events</b>
  - <i>Event</i>: Saved database file
- <b>Conditions</b> - not used
- <b>Actions</b>
  - <i>Action</i>: Execute command line / URL
    - <i>File/URL</i>: path\to\git\git-bash.exe<sup>(1)</sup>
    - <i>Arguments</i>: path/to/cloudinary.bash "location/to/store/{DB_BASENAME}.kdbx" "{DB_BASENAME}.kdbx" {REF:N@T:DO-NOT-DELETE-T1}<sup>(2)</sup>
    - <i>Wait for exit</i>: true
    - <i>Window style</i>: Maximized
  - <i>Action</i>: Show message box
    - <i>Main instructio</i>n: Database {DB_BASENAME} stored on remote CDN
    - <i>Icon</i>: None
    - <i>Buttons</i>: OK
    - <i>Default button</i>: Button 1
    - <i>Action - Condition</i>: Button OK/Yes
    - <i>Action</i>: None</pre>
  <span style="font-size:smaller;color:#999;"><i><sup>(1)</sup>Path to git-bash.exe; not tested with powershell</i><br />
  <i><sup>(2)</sup>Command to execute for uploading file to Cloudinary CDN by using cUrl. Required command line arguments:<br />
- local path to file to be uploaded<br />
- Cloudinary plublicId of the uploaded file<br />
- Cloudinary cloud name<br />
- Cloudinary API key<br />
- Cloudinary API secret<br />
- Cloudinary folder where file will be uploaded (optional)<br />
Note: Check repo for shell script cloudinary.bash<br />
Note: Parameters 3) to 6) are taken from a dedicated KeePass entry (DO-NOT-DELETE-T1, <a href="/cld-entry.jpg">cld-entry.jpg</a>), this means all Cloudinary related credentials are stored in KeePass database.</i>
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

- Database settings (Select database file then go to File > Database Settings)
  - Security
  - Compression: GZip
  - Recycle Bin
    - Use a recycle bin: checked
- Advanced
  - Limit number of history items per entry: e.g. 2
  - Limit history size per entry (MB): e.g. 1<br />
  *both settings could reduce the overall size of the database*
- KeePass configurations (Tools > Options)
  - Security
    - Clipboard auto-clear time (seconds; main entry list): e.g. 10
    - Clear clipboard when closing KeePass: checked
    - Do not store data in Windows clipboard: checked
    - Prevent certain screen captures: checked
- Advancced
  - Limit to single instance: checked
 
:point_right: Always keep a backup copy of the KeePass DB file in an accessible location, i.e. not in a location for which credentials are stored in KeePass itself. 

## Resources

- [KeePass homepage](https://keepass.info/)
- [KeePass Installation/Portability](https://keepass.info/help/v1/setup.html)
- [KeePass triggers](https://keepass.info/help/v2/triggers.html)
- [KeePass FAQ](https://keepass.info/help/kb/faq.html)
- [StackOverflow KeePass questions](https://stackoverflow.com/questions/tagged/keepass)
- [Koofr - One storage for all](https://koofr.eu/)
- [Koofr @ GitHub](https://github.com/koofr)
- [Cloudinary documentation](https://cloudinary.com/documentation)
- [Cloudinary API - Upload](https://cloudinary.com/documentation/image_upload_api_reference)
- [Cloudinary Admin API reference](https://cloudinary.com/documentation/admin_api#api_overview)
- [Cloudinary File upload using cUrl](https://support.cloudinary.com/hc/en-us/community/posts/360000183051-File-upload-using-curl)
