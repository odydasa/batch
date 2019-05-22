<?
$chars = "
133|...
147|\"
148|\"
145|'
146|'
189|1/2
151|--
169|(C)
174|(R)
";

$argv = (isset($argv) ? $argv : (isset($_SERVER["argv"]) ? 
        $_SERVER["argv"] : ($HTTP_SERVER_VARS["argv"]) ? 
        $HTTP_SERVER_VARS["argv"] : null));

$chars = explode(" ", trim(eregi_replace("[[:space:]]+", " ", $chars)));
$chars = array_map("explode", array_pad (array(), count($chars), "|"), $chars);

foreach (array_keys($chars) as $i)
{ $chars[$i][2] = $chars[$i][1];
  $chars[$i][1] = $chars[$i][0];
  $chars[$i][0] = chr($chars[$i][0]);
}

$data = implode("\n", array_map("trim", file($argv[1])));
$data = strip_tags($data);

foreach (array_keys($chars) as $i)
  $data = str_replace(chr($chars[$i][1]), $chars[$i][2], $data);

print_r(array_map("implode", $chars, 
        array_pad(array(), count($chars), "\t")));

$fp = fopen($argv[1], "w+"); 
fwrite($fp, $data); 
fclose($fp); 

print_r($data);

?>