<?
$argv = (isset($argv) ? $argv : (isset($_SERVER["argv"]) ? 
        $_SERVER["argv"] : ($HTTP_SERVER_VARS["argv"]) ? 
        $HTTP_SERVER_VARS["argv"] : null));
if (isset($argv[1]) && (strtolower($argv[1])=="\\n" || strtolower($argv[1])=="\\n\\r") &&
    isset($argv[2]) && is_file($argv[2]))
{ $tmp = "
";
  echo $argv[2].": done.\n";
  $argv[1] = str_replace("\\n", "\n", $argv[1]);
  $argv[1] = str_replace("\\r", "\r", $argv[1]);
  $argv[1] = str_replace("\n\r", $tmp, $argv[1]);
  write_file($argv[2], implode($argv[1], array_map("rtrim", file($argv[2]))));
  return $argv[2];
}
else return false

function write_file($filename, $data)
{ $fp = fopen( $filename,"w+"); 
  if (!fwrite( $fp, $data)) return false;
  fclose( $fp ); 
}
?>