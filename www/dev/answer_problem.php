<?php
	$conn=mysqli_connect("localhost","root","cnlroot","cnldb");
	if(mysqli_connect_errno()){
		echo "Failed to connect to MySQL: ",mysqli_connect_error();
		exit(0);
	}

	$q="select * from round where round_id = '" . $_POST['round_id'] . "'";
	$result=mysqli_query($conn,$q);
	if($row=mysqli_fetch_array($result)){

		$prob_id = $row['prob_id'];
		$q="select * from problem where prob_id='".$prob_id."'";
		$result=mysqli_query($conn, $q);

		if($row=mysqli_fetch_array($result)) {
			$problem=$row['name'];
			// update round information
			if ($problem == $_POST['answer']) {
				$q="update round set score=score+1 where round_id = '" . $_POST['round_id'] . "'";
				$result=mysqli_query($conn, $q);
				if($result) {
					$j = array('code'=>200, 'data'=>'ACCEPT');
				}
				else {
					$j=array('code'=>-1,'data'=>'MYSQL ERROR');
				}
				
			}
			else 
				$j = array('code'=>200, 'data'=>'WRONG');
		}
		else {
			$j=array('code'=>-1,'data'=>'MYSQL ERROR');
		}


	}
	else{
		$j=array('code'=>-1,'data'=>'ROUND NOT FOUND');
	}
	echo json_encode($j);
?>
