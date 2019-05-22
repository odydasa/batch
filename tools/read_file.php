<?
$argv = (isset($argv) ? $argv : (isset($_SERVER["argv"]) ? 
        $_SERVER["argv"] : ($HTTP_SERVER_VARS["argv"]) ? 
        $HTTP_SERVER_VARS["argv"] : null));
if (isset($error)) unset($error);
if (!isset($argv[1]) || !is_file($argv[1]))
   $error = "Invalid File...";

if (isset($error))
{ echo $error."\n";
  exit;
}

$data = implode("", file($argv[1]));
print_r($data);
?>