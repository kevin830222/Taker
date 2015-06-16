<?php
    $conn=mysqli_connect("localhost","root","0222","cnldb");
    if(mysqli_connect_errno()){
        echo "Failed to connect to MySQL: ",mysqli_connect_error();
        exit(0);
    }

    $q="select prob_id, name from problem";
    $result=mysqli_query($conn, $q);

    $j = array();
    if ($result) {
        $problems = array();
        while($row=mysqli_fetch_array($result)) {
            $prob_id = $row[0];
            $name = $row[1];
            $files = scandir("picture/$prob_id");
            $pattern = '/jpg$/i';
            $pictures = array_values(preg_grep($pattern, $files));
            array_push($problems, array("prob_id" => $prob_id, "name" => $name, "pictures" => $pictures));
        }
        $j = array("code"=> 200, "data"=> json_encode($problems));
    }
    else {
        $j = array("code"=> -1, "data"=> "MYSQL_ERROR");        
    }

    echo json_encode($j);
    
?>
