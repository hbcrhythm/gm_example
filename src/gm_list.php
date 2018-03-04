<?php
	/**
	** @doc 本文件提取代码中的gm命令
	** @author labihbc@gmail.com
	*/

	header("Content-Type:text/html;charset=utf-8");
	define('GM_FILE', dirname(__FILE__)."/gm_handle_api.erl");
	define('ROW', 3);		//多少个gm命令一行

	echo collect_gm();
	function collect_gm(){
		$content = file_get_contents(GM_FILE);
		$i = 1;
		preg_match_all("/【(.*?)】/i", $content, $out);
		unset($out[1][0]);
		unset($out[1][1]);
		$outString = "[";
		foreach ($out[1] as $key => $value) {
			$arrValue = explode(" ", $value);
			$e_cmd = explode("=", $arrValue[0]);
			$z_cmd = explode("=", $arrValue[1]);
			$params = empty($e_cmd[1]) ? "" : $e_cmd[1];
			$outString .= "{gm_list,1,\"$e_cmd[0]\",\"{$params}\",\"{$z_cmd[0]}\" } ,";
		}
		$outString = rtrim($outString, ",");
		$outString .= "]";
		return $outString;
	}
?>
