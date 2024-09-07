<h1>Deep Diving about Automated Backup and Rotation Script</h1>

<p?>Here this script basically automates the backup of github repository to local directory. It implements the Rotational backup strtegy and pushes the backups to the Google Drive by using rclone. and it also send cURL upon successful completion of backup process.</p>
<br>

<h2>Features</h2>
<br>
<ul>
  <li>Automated backups of project files from the Github Repository.</li>
  <li>Rotational backup stretegy for customizable retention period such as, For daily, weekly and monthly backups.</li>
  <li>To storing backup files on Google drive by using <b>rclone</b>.</li>
  <li>According to the retention policy Automated deletes the older backups.</li>
  <li>Using cUrl request through sending notification of succesful completion of backups.</li>
</ul>
<br>
<h2>Prerequisits</h2>
<p>Before using scripts, ensure that you have install some following neccessary stuff.</p>
<ol type="1">
  <li><b>Git</b> : To clone your github project.</li>
  <li><b>rclone</b> : To push backups to google drive.</li>
  <li><b>cUrl</b> : To sends notification of successful backups.</li>
</ol>
<br>
<h2>Installation of rclone</h2>
<h3>Here we are installing rclone using following link,</h3><br>
<p>curl https://rclone.org/install.sh | sudo bash </p>
<br>
<p>Here we are configuring rclone using Google Drive.</p>
<p>Run the following command for Google Drive remote,</p>
<p>rclone config</p>
