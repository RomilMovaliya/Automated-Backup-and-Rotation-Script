<h1>Deep Diving about Automated Backup and Rotation Script</h1>

<p>Here this script basically automates the backup of github repository to local directory. It implements the Rotational backup strategy and pushes the backups to the Google Drive by using rclone. and it also send curl upon successful completion of backup process.</p>


<br>
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

<ol type="1">
  <li><b>Git</b> : To clone your github project.</li>
  <li><b>rclone</b> : To push backups to google drive.</li>
  <li><b>curl</b> : To sends notification of successful backups.</li>
</ol>
<br>

<br>
<h2>Installation of rclone</h2>
<ul>
  <li>Here we are installing rclone using following link,</li>

<li>curl https://rclone.org/install.sh | sudo bash </li>

<li>Here we are configuring rclone using Google Drive. Run the following command for Google Drive remote,</li>

<li><mark>rclone config</mark></li>
<li><b>New remote</b> : Here we are enter <mark>n</mark> for new remote connection after that we add the name. </li>
<li><b>Storage</b> : Here we are enter <mark>17</mark> for google drive storage. because it provides different variety of storage solution.</li>
<li><b>Client id</b> : Simply press <mark>Enter</mark> it will select defualt.</li>
<li><b>Client secret</b> : Simply press <mark>Enter</mark> it will select defualt.</li>
<li><b>Scope</b> : Here we select the number <mark>1</mark> for full access all files.</li>
<li><b>Secret account file</b> :  Simply press <mark>Enter</mark> it will select defualt.</li>
<li><b>Advanced config</b> :  Simply press <mark>Enter</mark> it will select defualt because currently i don't need any advanced config.</li>
<li><b>Use auto config</b> :  Simply press <mark>y</mark>.</li></li><br>
<img src="https://github.com/RomilMovaliya/DemoPractical/blob/main/RCLONE_CONFIG1.JPG" alt="RCLONE_CONFIG1.JPG"><br>
<img src="https://github.com/RomilMovaliya/DemoPractical/blob/main/RCLONE_CONFIG2.JPG" alt="RCLONE_CONFIG2.JPG"><br>
<img src="https://github.com/RomilMovaliya/DemoPractical/blob/main/RCLONE_CONFIG3.JPG" alt="RCLONE_CONFIG3.JPG"><br>
<img src="https://github.com/RomilMovaliya/DemoPractical/blob/main/RCLONE_CONFIG4.JPG" alt="RCLONE_CONFIG4.JPG"><br>
<br>

After that click on the link and sign in.
Now we are mount this connection on local drive. we simply write,
<li><b>mkdir ~/mydirectory</b></li>
<li><b>sudo chmod 755 ~/mydirectory</b></li>
<li><b>rclone mount newgdrive_backup: ~/mydirectory</b></li>
</ul>


<h2>Creating necessary directories (Optional)</h2>
<p>mkdir /home/DevOps/Github_local_repo/</p> 
<p>if permission needed so adds the following permission, </p>
<ul>
<li>sudo chown romil:romil /home/DevOps/backupwala</li> 
<li>sudo chmod 755 /home/DevOps/backupwala</li>
<li> Here romil(username):romil(groupname) and 755 that means user can read, write and can execute the file.</li>
</ul>

<br>
<h2>The use of Script</h2> 
<p>Cloning the repository</p>
<p>First of all, You should clone The Github repository to your local directory where the backup script create a backup.</p>
<li>git clone https://github.com/RomilMovaliya/DemoPractical.git /home/DevOps/Github_local_repo/</li>
<li><b>Note</b>: you use your own github repo which contains folder and files.</li>

<br>
<h2>Run the script</h2>
<p>Before the run your script, you should assign the following permission.
<li><b>sudo chmod +x ./backup.sh</b></li> </p>
<p>Run <mark>backup.sh</mark> script with following parameter.</p>
<li>./backup.sh /home/Devops/Github_local_repo/ /path/to/backup/directory</li>
<li>Parameters:</li>
<mark>/home/Devops/Github_local_repo/</mark> ----> /path/to/local/project <br>
<mark>/home/Devops/backupwala</mark> ----> /path/to/backup/directory
<br>
<br>
<h2>About <mark>Retention function</mark></h2>
<img src="https://github.com/RomilMovaliya/DemoPractical/blob/main/retention_function.jpg" alt="retention_function.jpg"><br>

<h2>Deletes the older backups than retention day.</h2>
<ul>
<li><mark>find DIRECTORY_OF_BACKUP : </mark> that means it search for directory that is matched by variable name. </li>
<li><mark>type -f : </mark>that means we are finding file instead of directory.</li>
<li><mark>-name "*.zip" : </mark>that specify filter for file who contains .zip extension.</li>
<li><mark>-mtime + $RETENTION_DAYS : </mark> which filter if the file modification time is more than VARIABLE($RETENTION_DAYS) days ago.</li>
<li><mark>-exec rm {} / :</mark> here it removes the file and {} replace with file name founded.</li>
</ul>

<br>
<h2>To keeping last 4 weeks backup.</h2>
<ul>
<li><mark>find "$DIRECTORY_OF_BACKUP" </mark> : That Starts for search within the specified directory.</li>
<li><mark>-type f -name "*.zip</mark> : It basically filter out the type should be file instead of directory and name must be end with .zip extension</li>
<li><mark>-exec bash -c '...' \</mark> : It executes the bash command for each founded file. and allows us to run custom command.</li>
<li><mark>$(basename {} .zip | cut -d"_" -f2)</mark> : Here basename {} .zip that removes the .zip extension from the file and cut -d"_" -f2 that extract the date from the filename.</li>
<li><mark>$(date -d ... +%u)</mark> : Here It convert the extracted date into the numeric day of a week.(ex, 1 -> monday, 7-> sunday)</li>
<li><mark>(( $(date -d ... +%u) == 7 ))</mark> : It checks the day of a week is sunday then it gives true. if it was backuped on sunday.</li>
</ul>

<h2>To keeping 1st day of month backup.</h2>
<ul>
<li><mark>find "$DIRECTORY_OF_BACKUP"</mark> :  Same as before.</li>
<li><mark>-type f -name "*.zip"</mark> : Same filtering. </li>
<li><mark>-exec bash -c '...' \;</mark> : Executes a bash command for each file found. </li>
<li><mark>$(basename {} .zip | cut -d"_" -f2)</mark> : Same extraction of the date part from the filename.</li>
<li><mark>$(date -d ... +%d)</mark> : Converts the extracted date into the day of the month.</li>
<li><mark>(( $(date -d ... +%d) == 1 ))</mark> : Checks if the day of the month is the 1st. This test returns true if the file is a backup from the 1st of the month.</li>
</ul>

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
