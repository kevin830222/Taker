<?php
	$conn=mysqli_connect("localhost","root","cnlroot","cnldb");
	if(mysqli_connect_errno()){
		echo "Failed to connect to MySQL: ",mysqli_connect_error();
		exit(0);
	}

	$q="select * from player where player_id = '" . $_GET['player_id'] . "'";
	//echo $q . "<br>";
	$result=mysqli_query($conn,$q);
	if($row=mysqli_fetch_array($result)){
		$data = array('score'=>$row['score'], 'updated'=>$row['updated']);
		$q="SELECT * FROM round WHERE round.player2='".$_GET['player_id']."'";
		//echo $q."<br>";
		$result=mysqli_query($conn, $q);
		
		$invite=array();
		while($row=mysqli_fetch_array($result)){
			array_push($invite, $row['round_id']);
		}
		$data['invite'] = $invite;
		$j=array('code'=>200,'data'=>$data);
	}
	else{
		$j=array('code'=>-1,'data'=>'NOT FOUND');
	}
	echo json_encode($j);
?>
