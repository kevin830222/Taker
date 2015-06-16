<?php
	$conn=mysqli_connect("localhost","root","cnlroot","cnldb");
	if(mysqli_connect_errno()){
		echo "Failed to connect to MySQL: ",mysqli_connect_error();
		exit(0);
	}

	$rid=uniqid();
	$q="insert into round (round_id, player1, player2) values ('" . $rid . "', '" . $_POST['player1'] . "', '" . $_POST['player2'] . "')";
	//echo $q . "<br>";
	if(mysqli_query($conn,$q)){
		$j=array('code'=>200,'data'=>$rid);
	}
	else{
		$j=array('code'=>-1,'data'=>'MYSQL ERROR');
	}
	echo json_encode($j);
?>
