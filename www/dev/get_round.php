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

	$q="select * from round where round_id = '" . $_GET['round_id'] . "'";
	$result=mysqli_query($conn,$q);
	
	if($row=mysqli_fetch_array($result)){
		$list = array('player1'=>$row['player1'], 
			'player2'=>$row['player2'], 
			'score'=>$row['score'], 
			'act'=>$row['act'], 
			'answer'=>$row['answer'],
			'done'=>$row['done']);

		$prob_id = $row['prob_id'];
		$round_id = $_GET['round_id'];
		$prob_cnt = $row['prob_cnt'];
		$q="select * from problem where prob_id='".$prob_id."'";
		$result=mysqli_query($conn, $q);

		if($row=mysqli_fetch_array($result)) {
			// problem is defined
			$list['prob_cnt'] = $prob_cnt;
			$list['problem']=$row['name'];
			$opts = array($row['name']);

			$class=$row['class'];
			$q="SELECT problem.name	FROM problem, (SELECT prob_id AS sid FROM problem WHERE problem.class ='".$class."' and problem.prob_id != '".$prob_id."' ORDER BY RAND() LIMIT 2 ) tmp WHERE problem.prob_id = tmp.sid;";
			$result = mysqli_query($conn, $q);
			while($row=mysqli_fetch_array($result)) {
				array_push($opts, $row['name']);
			}
			$list['options']=$opts;


            $files = scandir("picture/$prob_id");
            $pattern = "/^$round_id-$prob_cnt/i";
            $pictures = array_values(preg_grep($pattern, $files));
			$list['pictures']=$pictures;
		}
		else {
			// problem is not defined
			$list['prob_cnt']=0;
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
