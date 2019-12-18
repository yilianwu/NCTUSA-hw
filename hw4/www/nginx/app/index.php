<?php
#	echo "hello world<br>";
	$input = $_SERVER["QUERY_STRING"];
	if(strlen($input)>0){
#		echo "do somthing<br>";
	#	$arr = explode("+",$input);
		$ars = explode("=",$input);
	#	$sum = (int)$arr[0]+(int)$arr[1];
		if(strlen($ars[1])>0){
			echo "Hello, $ars[1]";
		}
		else{
			$arr = explode("+",$input);
			$sum = (int)$arr[0]+(int)$arr[1];
			echo "result: $sum";
		}
	#	$result = explode("+",$_SERVER["QUERY_STRING"]);
	#	echo $result.[0];
	#	if(explode("+",$_SERVER["QUERY_STRING"]){
	#		echo explode("+",$_SERVER["QUERY_STRING"]);
	#	}
	}
	else{
		echo 'route: /';
	}


?>
