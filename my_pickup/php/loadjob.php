<?php
error_reporting(0);
include_once("dbConnect.php");
$email = $_POST['email'];

$sql = "SELECT * FROM job ORDER BY job_id DESC";

$result = $conn->query($sql);
if ($result->num_rows > 0) {
    $response["jobs"] = array();
    while ($row = $result ->fetch_assoc()){
        $joblist = array();
        $joblist[job_id] = $row["job_id"];
        $joblist[job_cust] = $row["job_cust"];
        $joblist[job_location] = $row["job_location"];
        $joblist[job_destination] = $row["job_destination"];
        $joblist[job_contact] = $row["job_contact"];
        $joblist[job_accept] = $row["job_accept"];
        array_push($response["jobs"], $joblist);    
        
    }
    echo json_encode($response);
}else{
    echo "nodata";
}

?>