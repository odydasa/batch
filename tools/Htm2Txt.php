<?
$paragraph_mark  = chr(7);
$paragraph_space = "\r\n\r\n";

$argv = (isset($argv) ? $argv : (isset($_SERVER["argv"]) ? 
        $_SERVER["argv"] : ($HTTP_SERVER_VARS["argv"]) ? 
        $HTTP_SERVER_VARS["argv"] : null));
if (count($argv)!=3) exit;
for ($i=0; $i<count($argv)-1; $i++)
    if (!is_file($argv[$i+1])) exit;

$cmd = array_slice($argv, 1);
$cmd = implode(" ", $cmd);
$out = `$cmd`;
$out = array_map("trim", explode("\n", $out));
$out = implode("\n", $out);
$out = str_replace("\n\n", $paragraph_mark, $out);
$out = str_replace("\n", " ", $out);
$out = str_replace("\n", " ", $out);
$out = str_replace("  ", " ", $out);
$out = str_replace("  ", " ", $out);
$out = str_replace($paragraph_mark, $paragraph_space, $out);
echo $out;
exit;
?>