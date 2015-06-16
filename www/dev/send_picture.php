<?php

	// echo debug variable
	function echo_debug($var, $file="/tmp/error.log") {
	    $date = date("H:i:s", time());
	    ob_start();
	    var_dump($var);
	    $result = ob_get_clean();

	    if (file_exists($file)) {
	        // Open the file to get existing content
	        $current = file_get_contents($file);

	        // Append a new person to the file
	        $current .= "[$date] $result\n";
	    }else{
	        $current = $result;
	    }
	    if (is_writable($file)) {
	        // Write the contents back to the file
	        file_put_contents($file, $current);
	    }
	}

	$conn=mysqli_connect("localhost","root","cnlroot","cnldb");
	if(mysqli_connect_errno()){
		echo "Failed to connect to MySQL: ",mysqli_connect_error();
		exit(0);
	}

	$q="select prob_id from round where round_id = '" . strtok(basename($_FILES["file"]["name"]),"-") . "'";
	//echo $q . "<br>";
	$result=mysqli_query($conn,$q);
	if($row=mysqli_fetch_array($result)){
		$target_file = "picture/" . $row['prob_id'] . "/" . basename($_FILES["file"]["name"]);
		if (move_uploaded_file($_FILES["file"]["tmp_name"], $target_file)) {
			//echo $target_file . " has been uploaded";
			$j=array('code'=>200,'data'=>'ACCEPT');
		} else {
			//echo $target_file . " upload failed";
			$j=array('code'=>-1,'data'=>'MOVE ERROR');
		}
	}
	else{
		$j=array('code'=>-2,'data'=>'NOT FOUND');
	}
	echo json_encode($j);
?>
