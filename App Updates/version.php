<?php
$filename = 'version.json';
$data = file_get_contents($filename);
header('Content-type:application/json;charset=utf-8');
echo $data;
?>
