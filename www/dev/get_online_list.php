<?php
	$conn=mysqli_connect("localhost","root","cnlroot","cnldb");
	if(mysqli_connect_errno()){
		echo "Failed to connect to MySQL: ",mysqli_connect_error();
		exit(0);
	}

	$q="select player_id, updated from player";
	//echo $q . "<br>";
	$result=mysqli_query($conn,$q);
	
	$list = array();
	if($row=mysqli_fetch_array($result)){
		do {
			$id = $row['player_id'];
			$time = strtotime($row['updated']);
			$curtime = time();
			if(($curtime-$time) <= 10) {
				array_push($list, $id);
			}
		} while($row=mysqli_fetch_array($result));
		$j = array('code'=>200, 'data'=>$list);
	}
	else{
		$j=array('code'=>-1,'data'=>'NO USER');
	}
	echo json_encode($j);
?>