## KeePass Trigger to execute SFTP file upload via WinSCP

By leveraging your pre-saved WinSCP Site Manager profile, the KeePass trigger remains clean and lightweight. All complex authentication settings are managed securely inside WinSCP, keeping your KeePass automation simple, secure, and easy to maintain.

It is also possible to configure SFTP authentication with SSH or YubiKey and Pageant for advanced certificate-based security.

\* *Note*: By using the "Simple FTP service" provided by [DocEvent.io](https://docevent.io/), you can access any AWS S3-compatible storage service, including [Cloudflare R2](https://www.cloudflare.com/products/r2/), [Backblaze B2](https://www.backblaze.com/cloud-storage), [IDrive e2](https://www.idrive.com/s3-storage-e2/), and others, through SFTP, SCP, or FTP/S.

### Trigger configuration

**Properties**

- Name: _Copy to SFTP_
- Enabled: yes
- Initually on: yes

**Events**

Saved database file / Equals

**Conditions**

_Empty._

**Actions**

Execute command line / URL
- File/URL: `%comspec%`
- Arguments: `/c timeout /t 2 >nul & "C:\Users\UserName\AppData\Local\Programs\WinSCP\WinSCP.exe" /log="C:/path-to/winscp_debug.log" /command "open MySFTPSiteConnection" "option confirm off" "put C:\Users\UserName\path-to\filename.ext /remote-folder/" "exit"`
- Wait for exit: yes
- Window style: Hidden

## Resources

- https://winscp.net/
- [WinSCP Documentation](https://winscp.net/eng/docs/start)
- [WinSCP - SSH](https://winscp.net/eng/docs/ssh)
- https://putty.org/
- [Integration with PuTTY](https://winscp.net/eng/docs/integration_putty)
- [PuTTY CAC](https://github.com/nomorefood/putty-cac)
- [PuTTY-CAC Installation - Windows](https://gsallewell.github.io/piv-guides/windows/puttycac-install)
- [Securing SSH with the YubiKey](https://developers.yubico.com/SSH/)
- [Using PIV for SSH through PKCS #11](https://developers.yubico.com/PIV/Guides/SSH_with_PIV_and_PKCS11.html)
- SFTP Service providers
  - [SFTPCloud.io](https://sftpcloud.io/)
  - [SFTPCloud.io - Free SFTP server](https://sftpcloud.io/tools/free-sftp-server)
  - [Couchdrop.io](https://www.couchdrop.io/)
  - [SFTPToGo.com](https://sftptogo.com/)
  - [DocEvent.io](https://docevent.io/)
