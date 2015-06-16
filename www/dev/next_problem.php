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

	$q="select * from round where round_id = '" . $_POST['round_id'] . "'";
	$result=mysqli_query($conn,$q);
	if($row=mysqli_fetch_array($result)){
		// generate random problem id
		$q="select prob_id from problem order by RAND() limit 1";
		$result=mysqli_query($conn, $q);
		$row=mysqli_fetch_array($result);
		$prob_id = $row['prob_id'];

		// update round information
		$q="update round set prob_id='".$prob_id."', prob_cnt=prob_cnt+1 where round_id = '" . $_POST['round_id'] . "'";
		$result=mysqli_query($conn, $q);
		if($result) {
			$j = array('code'=>200, 'data'=>'ACCEPT');
		}
		else {	
			$j = array('code'=>-2, 'data'=>'UPDATE ERROR');
		}
	}
	else{
		$j=array('code'=>-1,'data'=>'NOT FOUND');
	}
	echo json_encode($j);
?>
