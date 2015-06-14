<?php
	$conn=mysqli_connect("localhost","root","cnlroot","cnldb");
	if(mysqli_connect_errno()){
		echo "Failed to connect to MySQL: ",mysqli_connect_error();
		exit(0);
	}

	$q="update player set updated = NOW() where player_id = '" . $_POST['player_id'] . "'";
	//echo $q . "<br>";
	if(mysqli_query($conn,$q)){
		$j=array('code'=>200,'data'=>'ACCEPT');
	}
	else{
		$j=array('code'=>-1,'data'=>'NOT FOUND');
	}
	echo json_encode($j);
?>
