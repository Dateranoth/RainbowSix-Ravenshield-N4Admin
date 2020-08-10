<?
require("config.inc.php");

$statstables[]= 'StatsMissionCoop';
$statstables[]= 'StatsHostageCoop';
$statstables[]= 'StatsTerrorHuntCoop';
$statstables[]= 'StatsHostage';
$statstables[]= 'StatsSurvival';
$statstables[]= 'StatsTeamSurvival';
$statstables[]= 'StatsBomb';
$statstables[]= 'StatsPilot';
$statstables[]= 'StatsTerroristHuntAdvMode';
$statstables[]= 'StatsScatteredHuntAdvMode';
$statstables[]= 'StatsCaptureTheEnemyAdvMode';
$statstables[]= 'StatsCountDownMode';
$statstables[]= 'StatsKamikazeMode';

$laddertables[]= 'LadderMissionCoop';
$laddertables[]= 'LadderHostageCoop';
$laddertables[]= 'LadderTerrorHuntCoop';
$laddertables[]= 'LadderHostage';
$laddertables[]= 'LadderSurvival';
$laddertables[]= 'LadderTeamSurvival';
$laddertables[]= 'LadderBomb';
$laddertables[]= 'LadderPilot';
$laddertables[]= 'LadderTerroristHuntAdvMode';
$laddertables[]= 'LadderScatteredHuntAdvMode';
$laddertables[]= 'LadderCaptureTheEnemyAdvMode';
$laddertables[]= 'LadderCountDownMode';
$laddertables[]= 'LadderKamikazeMode';


if (!isset($_GET["step"])) {
$step='1';
?>
<form action="install.php">
<b><u>Step 1</u></b>
<br><br>
Updated for Athena Sword by Munkey (ravenshield.theplatoon.com), Neo4E656F (www.koalaclaw.com) and Wizard (www.smakclan.com)
<br><br>
Welcome to the RavenShield Serverlist V1.12 install Script.<br>(Please open the config.inc.php file in a text editor and enter the correct information before.)
<br><hr><input type="hidden" name="step" value="2"><input type="submit" value="To Step 2"></form><hr>
Serverlist for RainbowSix3 , Raven Shield by UBI-Soft<br>
Copyright (C) 2003 =TSAF=Muschel<br>
http://www.tsaf.de , muschel@tsaf.de<br>
<br>
This program is free software; you can redistribute it and/or modify<br>
it under the terms of the GNU General Public License as published by<br>
the Free Software Foundation version 2.<br>
<br>
This program is distributed in the hope that it will be useful,<br>
but WITHOUT ANY WARRANTY; without even the implied warranty of<br>
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the<br>
GNU General Public License for more details.<br>
<br>
You should have received a copy of the GNU General Public License<br>
along with this program; if not, write to the Free Software<br>
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA<br>
<br>
<a href="gpl.txt">View the GNU General Public License</a>
<?
}
else if ($_GET["step"]=='2') {
?>
<form action="install.php">
<b><u>Step 2</u></b><br><br>
We will install the following tables into the <b><?= $dbDatabase ?></b> Database.<hr><br>
Table 1: <b><?=$dbtable1?></b><br>
Table 2: <b><?=$dbtable2?></b><br>
Table 3: <b><?=$dbtable3?></b><br>
Table 4: <b><?=$dbtable5?>GameMode</b><br>
Table 5: <b><?=$dbtable5?>GameModeInBeacon</b><br>
Table 6: <b><?=$dbtable4?>ServerIdentsNames</b><br>
Table 7: <b><?=$dbtable4?>Player</b><br>
Table 8: <b><?=$dbtable4?>Nicks</b><br>
Table 9: <b><?=$dbtable6?>Update</b><br>
<?php
foreach ($statstables as $item)
{
	echo "Statstable: <b>".$dbtable4.$item."</b><br>";
}
foreach ($laddertables as $item)
{
	echo "Statstable: <b>".$dbtable6.$item."</b><br>";
}
?>
<br><hr><input type="hidden" name="step" value="3"><input type="submit" value="To Step 3"></form>
<?
}
else if ($_GET["step"]=='3') {
$db = mysqli_connect("$dbHost", "$dbUser", "$dbPass", "$dbDatabase") or die ("<CENTER>Connect-Error to mysqli!");
//mysqlii_select_db("$dbDatabase", $db) or die ("<CENTER>Connect-Error to Database!");

mysqli_query($db,"DROP TABLE IF EXISTS $dbtable1");
mysqli_query($db,"CREATE TABLE $dbtable1 (
  id int(11) NOT NULL auto_increment,
  ip varchar(255) NOT NULL default '',
  bp varchar(255) NOT NULL default '',
  sort int(255) NOT NULL default '0',
  text varchar(255) NOT NULL default '',
  PRIMARY KEY  (id)
)");

mysqli_query($db,"DROP TABLE IF EXISTS $dbtable2");
mysqli_query($db,"CREATE TABLE $dbtable2 (
  id int(11) NOT NULL auto_increment,
  language char(3) NOT NULL default '',
  css char(3) NOT NULL default '',
  aname varchar(20) NOT NULL default '',
  apass varchar(20) NOT NULL default '',
  PRIMARY KEY  (id)
)");

mysqli_query($db,"INSERT INTO $dbtable2 VALUES (1, '0', '3', 'admin', 'admin')");

mysqli_query($db,"DROP TABLE IF EXISTS $dbtable3");
mysqli_query($db,"CREATE TABLE $dbtable3 (
  id int(11) NOT NULL auto_increment,
  map varchar(50) NOT NULL default '',
  link varchar(200) NOT NULL default '',
  PRIMARY KEY  (id)
)");

mysqli_query($db,"INSERT INTO $dbtable3 VALUES (1, 'Prison', 'release.html')");
mysqli_query($db,"INSERT INTO $dbtable3 VALUES (5, 'Peaks', 'release.html')");
mysqli_query($db,"INSERT INTO $dbtable3 VALUES (6, 'Presidio', 'release.html')");
mysqli_query($db,"INSERT INTO $dbtable3 VALUES (7, 'MeatPacking_Day', 'release.html')");
mysqli_query($db,"INSERT INTO $dbtable3 VALUES (8, 'Warehouse', 'release.html')");
mysqli_query($db,"INSERT INTO $dbtable3 VALUES (9, 'Alpines', 'release.html')");
mysqli_query($db,"INSERT INTO $dbtable3 VALUES (10, 'Island', 'release.html')");
mysqli_query($db,"INSERT INTO $dbtable3 VALUES (11, 'Bank', 'release.html')");
mysqli_query($db,"INSERT INTO $dbtable3 VALUES (12, 'Import_Export', 'release.html')");
mysqli_query($db,"INSERT INTO $dbtable3 VALUES (13, 'Garage', 'release.html')");
mysqli_query($db,"INSERT INTO $dbtable3 VALUES (14, 'MeatPacking', 'release.html')");
mysqli_query($db,"INSERT INTO $dbtable3 VALUES (15, 'Streets', 'release.html')");
mysqli_query($db,"INSERT INTO $dbtable3 VALUES (16, 'Oil_Refinery', 'release.html')");
mysqli_query($db,"INSERT INTO $dbtable3 VALUES (17, 'Parade', 'release.html')");
mysqli_query($db,"INSERT INTO $dbtable3 VALUES (18, 'Penthouse', 'release.html')");
mysqli_query($db,"INSERT INTO $dbtable3 VALUES (19, 'Airport', 'release.html')");
mysqli_query($db,"INSERT INTO $dbtable3 VALUES (20, 'Mountain_High', 'release.html')");
mysqli_query($db,"INSERT INTO $dbtable3 VALUES (21, 'Island_Dawn', 'release.html')");
mysqli_query($db,"INSERT INTO $dbtable3 VALUES (22, 'Shipyard', 'release.html')");
mysqli_query($db,"INSERT INTO $dbtable3 VALUES (24, 'Training', 'release.html')");
mysqli_query($db,"INSERT INTO $dbtable3 VALUES (25, 'Airport_Night', 'release.html')");

mysqli_query($db,"DROP TABLE IF EXISTS ".$dbtable5."GameMode");
mysqli_query($db,"CREATE TABLE ".$dbtable5."GameMode (
  id int(11) NOT NULL auto_increment,
  text varchar(20) NOT NULL default '',
  statstablename varchar(30) NOT NULL default '',
  laddertablename varchar(30) NOT NULL default '',
  PRIMARY KEY  (id),
  UNIQUE KEY text (text),
  UNIQUE KEY statstablename (statstablename),
  UNIQUE KEY LadderTable (laddertablename)
)");

mysqli_query($db,"INSERT INTO ".$dbtable5."GameMode VALUES (1, 'missioncoop', 'StatsMissionCoop', 'LadderMissionCoop')");
mysqli_query($db,"INSERT INTO ".$dbtable5."GameMode VALUES (2, 'hostagecoop', 'StatsHostageCoop', 'LadderHostageCoop')");
mysqli_query($db,"INSERT INTO ".$dbtable5."GameMode VALUES (3, 'terrorhuntcoop', 'StatsTerrorHuntCoop', 'LadderTerrorHuntCoop')");
mysqli_query($db,"INSERT INTO ".$dbtable5."GameMode VALUES (4, 'hostage', 'StatsHostage', 'LadderHostage')");
mysqli_query($db,"INSERT INTO ".$dbtable5."GameMode VALUES (5, 'survival', 'StatsSurvival', 'LadderSurvival')");
mysqli_query($db,"INSERT INTO ".$dbtable5."GameMode VALUES (6, 'teamsurvival', 'StatsTeamSurvival', 'LadderTeamSurvival')");
mysqli_query($db,"INSERT INTO ".$dbtable5."GameMode VALUES (7, 'bomb', 'StatsBomb', 'LadderBomb')");
mysqli_query($db,"INSERT INTO ".$dbtable5."GameMode VALUES (8, 'pilot', 'StatsPilot', 'LadderPilot')");
mysqli_query($db,"INSERT INTO ".$dbtable5."GameMode VALUES (9, 'terroristhuntadvmode', 'StatsTerroristHuntAdvMode', 'LadderTerroristHuntAdvMode')");
mysqli_query($db,"INSERT INTO ".$dbtable5."GameMode VALUES (10, 'scatteredhuntadvmode', 'StatsScatteredHuntAdvMode', 'LadderScatteredHuntAdvMode')");
mysqli_query($db,"INSERT INTO ".$dbtable5."GameMode VALUES (11, 'capturetheenemymode', 'StatsCaptureTheEnemyAdvMode', 'LadderCaptureTheEnemyAdvMode')");
mysqli_query($db,"INSERT INTO ".$dbtable5."GameMode VALUES (12, 'countdownmode', 'StatsCountDownMode', 'LadderCountDownMode')");
mysqli_query($db,"INSERT INTO ".$dbtable5."GameMode VALUES (13, 'kamikazemode', 'StatsKamikazeMode', 'LadderKamikazeMode')");

mysqli_query($db,"DROP TABLE IF EXISTS ".$dbtable5."GameModeInBeacon");
mysqli_query($db,"CREATE TABLE ".$dbtable5."GameModeInBeacon (
  id int(11) NOT NULL auto_increment,
  fromgamemodeid int(11) NOT NULL default '0',
  beacontext varchar(30) NOT NULL default '',
  PRIMARY KEY  (id),
  UNIQUE KEY beacontext (beacontext)
)");

mysqli_query($db,"INSERT INTO ".$dbtable5."GameModeInBeacon VALUES (1, 1, 'RGM_MissionMode')");
mysqli_query($db,"INSERT INTO ".$dbtable5."GameModeInBeacon VALUES (2, 2, 'RGM_HostageRescueCoopMode')");
mysqli_query($db,"INSERT INTO ".$dbtable5."GameModeInBeacon VALUES (3, 3, 'RGM_TerroristHuntCoopMode')");
mysqli_query($db,"INSERT INTO ".$dbtable5."GameModeInBeacon VALUES (4, 4, 'RGM_HostageRescueAdvMode')");
mysqli_query($db,"INSERT INTO ".$dbtable5."GameModeInBeacon VALUES (5, 5, 'RGM_DeathmatchMode')");
mysqli_query($db,"INSERT INTO ".$dbtable5."GameModeInBeacon VALUES (6, 6, 'RGM_TeamDeathmatchMode')");
mysqli_query($db,"INSERT INTO ".$dbtable5."GameModeInBeacon VALUES (7, 7, 'RGM_BombAdvMode')");
mysqli_query($db,"INSERT INTO ".$dbtable5."GameModeInBeacon VALUES (8, 8, 'RGM_EscortAdvMode')");
mysqli_query($db,"INSERT INTO ".$dbtable5."GameModeInBeacon VALUES (9, 9, 'RGM_TerroristHuntAdvMode')");
mysqli_query($db,"INSERT INTO ".$dbtable5."GameModeInBeacon VALUES (10, 10, 'RGM_ScatteredHuntAdvMode')");
mysqli_query($db,"INSERT INTO ".$dbtable5."GameModeInBeacon VALUES (11, 11, 'RGM_CaptureTheEnemyAdvMode')");
mysqli_query($db,"INSERT INTO ".$dbtable5."GameModeInBeacon VALUES (12, 12, 'RGM_CountDownMode')");
mysqli_query($db,"INSERT INTO ".$dbtable5."GameModeInBeacon VALUES (13, 13, 'RGM_KamikazeMode')");


mysqli_query($db,"DROP TABLE IF EXISTS ".$dbtable4."ServerIdentsNames");
mysqli_query($db,"CREATE TABLE ".$dbtable4."ServerIdentsNames (
  id int(11) NOT NULL auto_increment,
  serverident varchar(20) NOT NULL default '',
  servername varchar(30) NOT NULL default '',
  PRIMARY KEY  (id),
  UNIQUE KEY serverident (serverident)
)");

mysqli_query($db,"DROP TABLE IF EXISTS ".$dbtable6."Update");
mysqli_query($db,"CREATE TABLE ".$dbtable6."Update (
  id int(11) NOT NULL auto_increment,
  gamemodeid int(11) NOT NULL default '0',
  lastupdatetime int(11) NOT NULL default '0',
  inupdate int(1) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE KEY gamemodeid (gamemodeid)
)");

mysqli_query($db,"DROP TABLE IF EXISTS ".$dbtable4."Nicks");
mysqli_query($db,"CREATE TABLE ".$dbtable4."Nicks (
  id int(11) NOT NULL auto_increment,
  fromid int(11) NOT NULL default '0',
  nick varchar(30) NOT NULL default '',
  PRIMARY KEY  (id),
  KEY fromid (fromid)
)");

mysqli_query($db,"DROP TABLE IF EXISTS ".$dbtable4."Player");
mysqli_query($db,"CREATE TABLE ".$dbtable4."Player (
  id int(11) NOT NULL auto_increment,
  serverident varchar(20) NOT NULL default '',
  ubiname varchar(30) NOT NULL default '',
  ubipass varchar(30) NOT NULL default '',
  PRIMARY KEY  (id),
  KEY serverident (serverident)
)");

foreach ($statstables as $item)
{
mysqli_query($db,"DROP TABLE IF EXISTS ".$dbtable4.$item);
mysqli_query($db,"CREATE TABLE ".$dbtable4.$item." (
  id int(11) NOT NULL auto_increment,
  fromid int(11) NOT NULL default '0',
  kills int(11) NOT NULL default '0',
  deaths int(11) NOT NULL default '0',
  map varchar(40) NOT NULL default '',
  roundsplayed int(11) NOT NULL default '0',
  fired int(11) NOT NULL default '0',
  hits int(11) NOT NULL default '0',
  PRIMARY KEY  (id)
)");
}

foreach ($laddertables as $item)
{
mysqli_query($db,"DROP TABLE IF EXISTS ".$dbtable6.$item);
mysqli_query($db,"CREATE TABLE ".$dbtable6.$item." (
  id int(11) NOT NULL auto_increment,
  fromid int(11) NOT NULL default '0',
  score int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  KEY score (score)
)");
}



?>
<form action="index.php">
<b><u>Step 3</u></b><br><br>
Thanks for installing the RavenShield Serverlist. Please DELETE the install.php file.<br>
The default Serverlist-Admin is admin/admin, change it!
<hr></form>
<?
}
?>
</body>
</html>
