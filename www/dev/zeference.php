<head>
	<title>cnldb test!!</title>
</head>
<body>
<?php
	/* function insert($id,$comment)
	{
		global $conn;
		$str=htmlspecialchars($comment);
		mysqli_query($conn,"insert into b01902054 (id,timestamp,IP,comment) values ($id,{$_SERVER['REQUEST_TIME']},'{$_SERVER['SERVER_ADDR']}','$str')");
	} */
	
	$conn=mysqli_connect("localhost","root","cnlroot","cnldb");
	if(mysqli_connect_errno()){
		echo "Failed to connect to MySQL: ",mysqli_connect_error();
		exit(0);
	}
	/* if($_SERVER['REQUEST_METHOD']==='POST'){
		insert($_POST['id'],$_POST['comment']);
	} */
	echo "<table border='5'><tr><th>id</th><th>win</th><th>lose</th></tr>\n";
	$result=mysqli_query($conn,"select * from acct");
	while($row=mysqli_fetch_array($result)){
		echo "<tr><td>{$row['id']}</td><td>{$row['win']}</td><td>{$row['lose']}</td></tr>\n";
	}
	echo "</table><br>";
	mysqli_close($conn);
	/* echo "<form action='index.php' method='post'>
		<input type='hidden' name='id' value='$id'>
		comment: <input type='text' name='comment'> <input type='submit' value='submit'>"; */
?>
</body>
