<?php
	$conn=mysqli_connect("localhost","root","cnlroot","cnldb");
	if(mysqli_connect_errno()){
		echo "Failed to connect to MySQL: ",mysqli_connect_error();
		exit(0);
	}

	$q="select player_id, password from player where player_id = '" . $_POST['player_id'] . "'";
	//echo $q . "<br>";
	$result=mysqli_query($conn,$q);
	if($row=mysqli_fetch_array($result)){
		if($_POST['password']==$row['password']){
			$j=array('code'=>200,'data'=>'ACCEPT');
		}
		else{
			$j=array('code'=>-1,'data'=>'REJECT');
		}
	}
	else{
		$j=array('code'=>-2,'data'=>'NOT FOUND');
	}
	echo json_encode($j);
?>
