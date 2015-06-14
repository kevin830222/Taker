<?php
	$conn=mysqli_connect("localhost","root","cnlroot","cnldb");
	if(mysqli_connect_errno()){
		echo "Failed to connect to MySQL: ",mysqli_connect_error();
		exit(0);
	}

	$q="select * from round where round_id = '" . $_GET['round_id'] . "'";
	$result=mysqli_query($conn,$q);
	
	if($row=mysqli_fetch_array($result)){
		$list = array('player1'=>$row['player1'], 
			'player2'=>$row['player2'], 
			'score'=>$row['score'], 
			'act'=>$row['act'], 
			'answer'=>$row['answer']);

		$prob_id = $row['prob_id'];
		$prob_cnt = $row['prob_cnt'];
		$q="select * from problem where prob_id='".$prob_id."'";
		$result=mysqli_query($conn, $q);

		if($row=mysqli_fetch_array($result)) {
			// problem is defined
			$list['problem']=$row['name'];
			$opts = array($row['name']);

			$class=$row['class'];
			$q="SELECT problem.name	FROM problem, (SELECT prob_id AS sid FROM problem WHERE problem.class ='".$class."' and problem.prob_id != '".$prob_id."' ORDER BY RAND() LIMIT 2 ) tmp WHERE problem.prob_id = tmp.sid;";
			$result = mysqli_query($conn, $q);
			while($row=mysqli_fetch_array($result)) {
				array_push($opts, $row['name']);
			}
			$list['options']=$opts;
			
			$pics = array($prob_id."/".$_GET['round_id']."-".$prob_cnt."-1.png", $prob_id."/".$_GET['round_id']."-".$prob_cnt."-2.png", $prob_id."/".$_GET['round_id']."-".$prob_cnt."-3.png");
			$list['pictures']=$pics;
		}
		else {
			// problem is not defined
			$list['problem']=null;
			$list['options']=null;
			$list['pictures']=null;
		}
		$j = array('code'=>200, 'data'=>$list);
	}
	else{
		$j=array('code'=>-1,'data'=>'SQL ERROR');
	}
	echo json_encode($j);
	
?>