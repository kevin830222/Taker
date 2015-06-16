<?php
	$conn=mysqli_connect("localhost","root","cnlroot","cnldb");
	if(mysqli_connect_errno()){
		exit(0);
	}

	$q="select * from round where round_id = '" . $_POST['round_id'] . "'";
	$result=mysqli_query($conn,$q);
	if($row=mysqli_fetch_array($result)){
		$q="update round set act=1 where round_id = '" . $_POST['round_id'] . "'";
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
