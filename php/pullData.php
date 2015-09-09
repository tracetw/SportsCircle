<?php
$link = @mysql_connect("localhost", "root", "root");
if (!$link)
{
	die("can't link ");
	echo "fail";
}
else
{
	//echo "success<BR>";
}
// $charset=mysql_client_encoding();
// echo "最後開啟之資料連結所使用的字級名稱: $charset<BR> ";

mysql_query("SET NAMES 'UTF8'");//加這行中文才可以顯示...
$db_selected=mysql_select_db("sportscircle",$link);//開啟資料庫了！
if (!$db_selected)
{
	die("無法開啟mytestbase資料庫<BR>".mysql_error($link));
}

$allSportsType = array("Other","Archery","Athletics","Badminton","Basketball","BeachVolleyball","Cycling","Diving",
"Equestrian","Fencing","Football","Gymnastics","Handball","Hockey","Judo","Rowing","Sailing","Shooting",
"Swimming", "SynchronisedSwimming","TableTennis","Taekwondo","Tennis","Trampoline","Volleyball","WaterPolo","Weightlifting",
"Wrestling");

$sportTimeLess30Count = array();
//echo $sportTimeLess30Count["nouse"];
for ($i=0 ; $i < count($allSportsType) ; $i++)
{
	$sql="SELECT *FROM data WHERE time < '00:30:00' && sportstype = '$allSportsType[$i]'";//WHERE price='200'
	$result=mysql_query($sql,$link);//用mysql_query使用sql語法
	//echo "$allSportsType[$i]"."時間time<30的紀錄有" .mysql_num_rows($result). "筆";
	//echo "，包含" .mysql_num_fields($result). "欄位<BR>";
	$sportsName = $allSportsType[$i];
	$array = array($sportsName => mysql_num_rows($result));
	//print_r($array);
	$sportTimeLess30Count += $array;
}
//echo "===================================<BR>";
//print_r($sportTimeLess30Count);
//echo $sportTimeLess30Count["Basketball"];

//echo "===================================<BR>";
$sportTimeBetween30to60Count = array();
for ($i=0 ; $i < count($allSportsType) ; $i++)
{
	$sql="SELECT *FROM data WHERE time Between '00:30:00' AND '01:00:00'  && sportstype = '$allSportsType[$i]'";//WHERE price='200'
	$result=mysql_query($sql,$link);//用mysql_query使用sql語法
// 	echo "$allSportsType[$i]"."時間30~60的紀錄有" .mysql_num_rows($result). "筆";
// 	echo "，包含" .mysql_num_fields($result). "欄位<BR>";
	$sportsName = $allSportsType[$i];
	$array = array($sportsName => mysql_num_rows($result));
	//print_r($array);
	$sportTimeBetween30to60Count += $array;
}
//echo "===================================<BR>";
$sportTimeBetween60to90Count = array();
for ($i=0 ; $i < count($allSportsType) ; $i++)
{
	$sql="SELECT *FROM data WHERE time Between '01:00:00' AND '01:30:00' && sportstype = '$allSportsType[$i]'";//WHERE price='200'
	$result=mysql_query($sql,$link);//用mysql_query使用sql語法
// 	echo "$allSportsType[$i]"."時間60~90的紀錄有" .mysql_num_rows($result). "筆";
// 	echo "，包含" .mysql_num_fields($result). "欄位<BR>";
	$sportsName = $allSportsType[$i];
	$array = array($sportsName => mysql_num_rows($result));
	//print_r($array);
	$sportTimeBetween60to90Count += $array;
}
//echo "===================================<BR>";
$sportTimeBetween90to120Count = array();
for ($i=0 ; $i < count($allSportsType) ; $i++)
{
	$sql="SELECT *FROM data WHERE time Between '01:30:00' AND '00:120:00' && sportstype = '$allSportsType[$i]'";//WHERE price='200'
	$result=mysql_query($sql,$link);//用mysql_query使用sql語法
// 	echo "$allSportsType[$i]"."時間90~120的紀錄有" .mysql_num_rows($result). "筆";
// 	echo "，包含" .mysql_num_fields($result). "欄位<BR>";
	$sportsName = $allSportsType[$i];
	$array = array($sportsName => mysql_num_rows($result));
	//print_r($array);
	$sportTimeBetween90to120Count += $array;
}
//echo "===================================<BR>";
$sportTimeBetweenLarge120Count = array();
for ($i=0 ; $i < count($allSportsType) ; $i++)
{
	$sql="SELECT *FROM data WHERE time > '02:00:00' && sportstype = '$allSportsType[$i]'";//WHERE price='200'
	$result=mysql_query($sql,$link);//用mysql_query使用sql語法
// 	echo "$allSportsType[$i]"."時間time>120的紀錄有" .mysql_num_rows($result). "筆";
// 	echo "，包含" .mysql_num_fields($result). "欄位<BR>";
	$sportsName = $allSportsType[$i];
	$array = array($sportsName => mysql_num_rows($result));
	//print_r($array);
	$sportTimeBetweenLarge120Count += $array;
}
?>