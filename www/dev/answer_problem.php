<?php
	$conn=mysqli_connect("localhost","root","cnlroot","cnldb");
	if(mysqli_connect_errno()){
		echo "Failed to connect to MySQL: ",mysqli_connect_error();
		exit(0);
	}

	$q="select * from round where round_id = '" . $_POST['round_id'] . "'";
	$result=mysqli_query($conn,$q);
	if($row=mysqli_fetch_array($result)){
		// update round information
		if ($row["problem"] == $_POST['answer']) {
			$q="update round set score=score+1 where round_id = '" . $_POST['round_id'] . "'";
			$j = array('code'=>200, 'data'=>'ACCEPT');
		}
		else 
			$j = array('code'=>200, 'data'=>'WRONG');
	}
	else{
		$j=array('code'=>-1,'data'=>'ROUND NOT FOUND');
	}
	echo json_encode($j);
?>
