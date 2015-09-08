<?php

$handle = fopen("php://input", "rb");
$http_raw_post_data = '';
while (!feof($handle)) {
    $http_raw_post_data .= fread($handle, 8192);
}
fclose($handle);


$post_data = json_decode($http_raw_post_data,true);

if (is_array($post_data))
    $response = array("status" => "ok", "code" => 0, "original request" => $post_data);
else
    $response = array("status" => "error", "code" => -1, "original_request" => $post_data);

$processed = json_encode($response);
echo $processed;


$con = mysql_connect("localhost:8888","root","root") or die('Could not connect: ' . mysql_error());
mysql_select_db("sportscircle", $con);

$data = $post_data;

$objectiveId = $data['objectiveId'];
$calories = $data['calories'];
$distance = $data['distance'];
$time = $data['time'];
$sportsType = $data['sportsType'];//
$createTime = $data['createTime'];//
echo 'HLLLLLLL'.$objectiveId;

$sql = "INSERT INTO `sportscircle`.`data` (`id`, `calories`, `distance`, `time`, `sportsType`, `createTime`) 
VALUES ('$objectiveId', '$calories', '$distance', '$time', '$sportsType', '$createTime')";

if(!mysql_query($sql,$con))
{
    die('Error : ' . mysql_error());
}

?>