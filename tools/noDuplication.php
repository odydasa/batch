<?
$help = trim("
Valid arguments: [path1] [path2] [exception_files]
");

$argv = (isset($argv) ? $argv : (isset($_SERVER["argv"]) ? 
        $_SERVER["argv"] : ($HTTP_SERVER_VARS["argv"]) ? 
        $HTTP_SERVER_VARS["argv"] : null));
$_source    = isset($argv[1]) && !empty($argv[1]) ? $argv[1] : ".\*.*";
$_target    = isset($argv[2]) && !empty($argv[2]) ? $argv[2] : ".\*.*";
$_exception = isset($argv[3]) && !empty($argv[3]) ? $argv[3] : ".\*.*";
foreach (explode(" ", strtolower("source target")) as $i=>$tmp)
{ ${"_".$tmp} = "cmd /C DIR /B/S/A-D \"".str_replace("\"", "", 
                ${"_$tmp"})."\"\n";
  unset($x);
}
$tmp        = explode(" ", $_exception);
$_exception = "";
foreach ($tmp as $i=>$tmp)
{ $x = "cmd /c FOR /F \"delims=\" %A IN ('DIR /B/S/A-D \"".
       str_replace("\"", "", $tmp)."\"') DO ECHO %A";
  $_exception .= $x."\n";
  unset($x);
}
foreach (explode(" ", "source target exception") as $i=>$tmp)
{ passthru(trim(${"_".$tmp}), ${"_".$tmp});
  #echo ${"_".$tmp};
}
#$_exception = array_map("trim", explode("\n", trim(eregi_replace("(\r\n|\r|\n)+", 
#          "\n", $_exception))));
#print_r($_source);
#print_r($_target);
#print_r($_exception);
#passthru("dir /ad\n\necho", $x);
#print_r($x);


exit;

#params parsing
if (!in_array("-regex", $params)) $txt1 = preg_quote($txt1);
$data = implode("", file($file));
$data = in_array("-i", $params) ? 
        eregi_replace($txt1, $txt2, $data) :
        ereg_replace($txt1, $txt2, $data);
if (in_array("-dump", $params))
   echo $data;
else
{ echo "$file: ";
  $fp = fopen( $file,"w+"); 
  fwrite( $fp, $data);
  fclose( $fp ); 
  echo "\"$txt1\" => \"$txt2\": done.\n";
}
?>