<h1>Deep Diving about Automated Backup and Rotation Script</h1>

- Here this script basically automates the backup of github repository to local directory. It implements the Rotational backup strategy and pushes the backups to the Google Drive by using rclone. and it also send curl upon successful completion of backup process.</p>

- You can watch the video of basic scenarios that we face in real-time!.👇Just click on the below <b>Thumbnail.</b><br><br>
[![Thumbnail](https://github.com/RomilMovaliya/Automated-Backup-and-Rotation-Script/blob/main/thumbnail.jpg)](https://drive.google.com/file/d/1Zskkztam-khKPH1n4gLKK1GiMl4siX-k/view?usp=sharing)


<h2>Features</h2>

<ul>
  <li>Automated backups of project files from the Github Repository.</li>
  <li>Rotational backup strategy for customizable retention period such as, For daily, weekly and monthly backups.</li>
  <li>To storing backup files on Google drive by using <b>rclone</b>.</li>
  <li>According to the retention policy Automated deletes the older backups.</li>
  <li>Using curl request through sending notification of successful completion of backups.</li>
</ul>

<br1>
<h2>Prerequisites</h2>
<p>Before using scripts, ensure that you have install some following necessary stuff.</p>


| **Configuration Tools**                          | **Configuration Tools Description**                 |
|------------------------------------------------|-----------------------------------------|
| 1. `Git`                                  | To clone your github project.                                   |
| 2. `rclone `                                     | To push backups to google drive.                                    |
| 3. `curl   `                                | To sends notification of successful backups                                  |
                        


<br>
<h2>Installation of rclone</h2>
<ul>
  <li>Here we are installing rclone using following link,</li>

<li>curl https://rclone.org/install.sh | sudo bash </li>

<li>Here we are configuring rclone using Google Drive. Run the following command for Google Drive remote,</li>

<br>

| **rclone config key option**                          | **rclone config Description of option**                 |
|------------------------------------------------|-----------------------------------------|
| 1. `New remote`                                   | Here we are enter `n` for new remote connection after that we add the name.                                   |
| 2. `Storage`                                       | Here we are enter `17` for google drive storage. because it provides different variety of storage solution.                          |
| 3. `Client id`                                    | Simply press `Enter` it will select defualt.                                 |
| 4. `Client secret`                                  | Simply press `Enter` it will select defualt.                                  |
| 5. `Scope`                                  | Here we select the number `1` for full access all files.                                |
| 6. `Secret account file`                                      | Simply press `Enter` it will select defualt.                           |
| 7.  `Advanced config`                            | Simply press `Enter`  it will select defualt because currently i don't need any advanced config.                       |
| 8.  `Use auto config`                            | Simply press `y`.                                |

<br>

<img src="https://github.com/RomilMovaliya/DemoPractical/blob/main/RCLONE_CONFIG1.JPG" alt="RCLONE_CONFIG1.JPG"><br>
<img src="https://github.com/RomilMovaliya/DemoPractical/blob/main/RCLONE_CONFIG2.JPG" alt="RCLONE_CONFIG2.JPG"><br>
<img src="https://github.com/RomilMovaliya/DemoPractical/blob/main/RCLONE_CONFIG3.JPG" alt="RCLONE_CONFIG3.JPG"><br>
<img src="https://github.com/RomilMovaliya/DemoPractical/blob/main/RCLONE_CONFIG4.JPG" alt="RCLONE_CONFIG4.JPG"><br>
<br>

After that click on the link and sign in.
Now we are mount this connection on local drive. we simply write,
 ```bash
mkdir ~/mydirectory
 ```

 ```bash
sudo chmod 755 ~/mydirectory
 ```

 ```bash
rclone mount newgdrive_backup: ~/mydirectory
```


<h2>Creating necessary directories (Optional)</h2>
<p>mkdir /home/DevOps/Github_local_repo/</p> 
<p>if permission needed so adds the following permission, </p>

 ```bash
sudo chown romil:romil /home/DevOps/backupwala
 ```

 ```bash
sudo chmod 755 /home/DevOps/backupwala
 ```

<li> Here romil(username):romil(groupname) and 755 that means user can read, write and can execute the file.</li>
</ul>

<br>
<h2>The use of Script</h2> 
<p>Cloning the repository</p>
<p>First of all, You should clone The Github repository to your local directory where the backup script create a backup.</p>

```bash
git clone https://github.com/RomilMovaliya/DemoPractical.git /home/DevOps/Github_local_repo/
```

<li><b>Note</b>: you use your own github repo which contains folder and files.</li>

<br>
<h2>Run the script</h2>
<p>Before the run your script, you should assign the following permission.

```bash
sudo chmod +x ./backup.sh
 ```
<p>Run <b>backup.sh</b> script with following parameter.</p>
<li>./backup.sh /home/Devops/Github_local_repo/ /path/to/backup/directory</li>
<li>Parameters:</li>

- `/home/Devops/Github_local_repo/` ----> /path/to/local/project <br>
- `/home/Devops/backupwala` ----> /path/to/backup/directory
<br>
<br>
<h2>About <mark>Retention function</mark></h2>
<img src="https://github.com/RomilMovaliya/DemoPractical/blob/main/retention_function.jpg" alt="retention_function.jpg"><br>

<h2>Deletes the older backups than retention day.</h2>

- `find DIRECTORY_OF_BACKUP` : </mark> that means it search for directory that is matched by variable name.
- `type -f` : </mark>that means we are finding file instead of directory.
- `-name "*.zip"` : </mark>that specify filter for file who contains .zip extension.
- `-mtime + $RETENTION_DAYS` : </mark> which filter if the file modification time is more than VARIABLE($RETENTION_DAYS) days ago.
- `-exec rm {} /` :</mark> here it removes the file and {} replace with file name founded.


<br>
<h2>To keeping last 4 weeks backup.</h2>

- `find "$DIRECTORY_OF_BACKUP"`  : That Starts for search within the specified directory.
- `-type f -name "*.zip` : It basically filter out the type should be file instead of directory and name must be end with .zip extension.
- ` -exec bash -c '...' \` : It executes the bash command for each founded file. and allows us to run custom command.
- `$(basename {} .zip | cut -d"_" -f2)` : Here basename {} .zip that removes the .zip extension from the file and cut -d"_" -f2 that extract the date from the filename.
- `$(date -d ... +%u)` : Here It convert the extracted date into the numeric day of a week.(ex, 1 -> monday, 7-> sunday)
- `(( $(date -d ... +%u) == 7 ))` : It checks the day of a week is sunday then it gives true. if it was backuped on sunday.


<h2>To keeping 1st day of month backup.</h2>

- `find "$DIRECTORY_OF_BACKUP` :  Same as before.
- `-type f -name "*.zip" ` : Same filtering. 
- `-exec bash -c '...' \; ` : Executes a bash command for each file found. 
- `$(basename {} .zip | cut -d"_" -f2) ` : Same extraction of the date part from the filename.
- `$(date -d ... +%d) ` : Converts the extracted date into the day of the month.
- `(( $(date -d ... +%d) == 1 )) ` : Checks if the day of the month is the 1st. This test returns true if the file is a backup from the 1st of the month.


<br>
<h2> KEY POINTS OF RETENTION PROCESS LINES </h2>
<ul>
<li>The first line deletes all .zip files older than a certain number of days specified by $RETENTION_DAYS.</li>
<li>The second line identifies files where the date in the filename corresponds to a Sunday, but it doesn’t perform any deletion or retention action by itself.</li>
<li>The third line identifies files where the date in the filename is the 1st of the month, but again, it doesn’t perform any retention or deletion action directly.</li>
</ul>

<h2> 🏆 THE RESULT OF THE SCRIPT 🏆 </h2>
<P>Here we can see the backups that basically store in the Google Drive.</P>
<img src="https://github.com/RomilMovaliya/DemoPractical/blob/main/google_drive_result.JPG" alt="Google_drive_view">
<p>Here we get notification using curl to the webhook's dashboard.</p>
<img src="https://github.com/RomilMovaliya/DemoPractical/blob/main/webhook_result.JPG" alt="webhook_view">

<p>⏰ Here we can also schedule the Job using Cronjob</p>
<p>
  <li>For example, If i want to daily execte the script at daily 2 AM, add the following line in your crobtab. </li>
  <li><b>0 2 * * * /home/DevOps/backup.sh  /home/DevOps/Github_local_repo  /home/DevOps/backupwala</b></li>
</p>
