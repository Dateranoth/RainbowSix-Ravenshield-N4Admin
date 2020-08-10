<?php
// Script (C)opyright 2003 by =TSAF=Muschel
// Released under GNU GENERAL PUBLIC LICENSE
// www.tsaf.de , muschel@tsaf.de
error_reporting(2047);
$artoverall="Overall";
$text_enterubiname="Enter a Ubiname:";
foreach ($_GET as $key => $value){${$key}=$value;}
require("config.inc.php");
if (!isset($mode)){$mode="0";}
if (!isset($ubi)){$ubi="";}
ConnectTheDBandGetDefaults();
require('language/'.$customlanguage.'.inc.php');
$modetext['0']=$artoverall;
$modetext['1']=$text_gamemode['teamsurvival'];
$modetext['2']=$text_gamemode['survival'];
$modetext['3']=$text_gamemode['bomb'];
$modetext['4']=$text_gamemode['hostage'];
$modetext['5']=$text_gamemode['pilot'];
?>
<html>
<title>UBI-Ladder</title>
<LINK rel='stylesheet' HREF="<?=$css?>" TYPE='text/css'>
<body class=body>
<script language="javascript">
<!--
if (document.images) { on = new Image(); on.src = "images/indicator.gif"; off = new Image(); off.src ="images/clear.gif"; }
function mi(n) { if (document.images) {document[n].src = eval("on.src");}}
function mo(n) { if (document.images) {document[n].src = eval("off.src");}}
// -->
</script>
<table align="left" valign="top" border="0" cellpadding="0" cellspacing="0" width="350">
<td>
<table border=0 cellpadding=0 cellspacing=0 width=350 align=center valign=top>
<tr><td width="100%" class="tabfarbe-3"><table border=0 cellspacing=1 width="100%">
<tr><td width="100%" class=oben colspan=2 align=center background="images/<?=$design[$dset]?>_header.gif">
<?=$text_playerdetails?> (<?=$modetext[$mode]?>)</td></tr>
<tr><td width="100%" class=results colspan=2 align=center>
<?=ShowFlags("ubiladder.php","&ubi=".$ubi."&mode=".$mode)?></td></tr>
<?php
echo "<tr><td colspan=2 class=results width=\"100%\" align=center><b>".$text_ladderoff."</b></td></tr>";
?>
</table></table></td>
</tr></table></body></html>

