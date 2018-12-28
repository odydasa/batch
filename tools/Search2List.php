<?
$valid_params = array_map("strtolower", explode(" ", 
                "-i -regex_quote"));
$help = trim("
Valid arguments: filename pattern_text [options]

Options:
  -regex_quote   convert pattern_text into regex pattern
  -i             specifies that the text replace is not to be case-sensitive
");

$argv = (isset($argv) ? $argv : (isset($_SERVER["argv"]) ? 
        $_SERVER["argv"] : ($HTTP_SERVER_VARS["argv"]) ? 
        $HTTP_SERVER_VARS["argv"] : null));

# error parsing
if (isset($error)) unset($error);
if (!isset($argv[1]) || !is_file($argv[1]))
   $error = "Invalid File...\n\n".$help;
if (count($argv)<2)
   $error = "Invalid Parameter...\n\n".$help;
$file   = $argv[1];
$txt1   = $argv[2];
$params = array_map("strtolower", array_slice($argv, 3));
$argv   = array_slice($argv, 0, 3);

foreach (array_keys($params) as $i)
{ $error = "Invalid Parameter...\n\n".$help;
  foreach (array_keys($valid_params) as $j)
  if ($params[$i]==$valid_params[$j])
  { unset($error);
    break;
  }
  if (isset($error)) break;
}

if (isset($error))
{ echo $error."\n";
  exit;
}

# convert special characters: \a, \f, \n, \r, and \t
$ptrn = "/\\\\[aefnrt]/";
$spch = array
( "a"=>"\a",
  "f"=>"\f",
  "n"=>"\n",
  "r"=>"\r",
  "t"=>"\t"
);
foreach (explode(" ", "txt1") as $i=>$txt)
{ $tmp = ${$txt};
  $x = preg_match_all($ptrn, $tmp, $keys);
  $keys = $keys[0];
  if (count($keys)>0)
  { $keys = array_unique($keys);
    sort($keys);
    foreach (array_keys($keys) as $j)
      $tmp = str_replace($keys[$j], $spch[substr($keys[$j], 1)], $tmp);
    ${$txt} = $tmp;
  }
}

#convert chr(n) into ascii character
#  this is purposed for command line character limitation
#  i.e: chr(34)=", chr(42)=*, chr(47)=/, chr(58)=:, chr(59)=;, chr(60)=<, 
#       chr(62)=>, chr(63)=?, chr(92)=\, chr(124)=|
$ptrn = "chr\\([0-9]{1,3}\\)";
foreach (explode(" ", "txt1") as $i=>$txt)
{ $tmp = ${$txt};
  $x = eregi($ptrn, $tmp, $keys);
  if (count($keys)>0)
  { $keys = array_unique($keys);
    sort($keys);
    foreach (array_keys($keys) as $j)
      $tmp = str_replace($keys[$j], chr(substr($keys[$j], 4, -1)), $tmp);
    ${$txt} = $tmp;
  }
}

#params parsing
if (in_array("-regex_quote", $params)) $txt1 = preg_quote($txt1);
$data        = implode("", file($file));
$var_pattern = "|".$txt1."|U".(in_array("-i", $params) ? "i":"");
preg_match_all($var_pattern, $data, $result, PREG_PATTERN_ORDER);
$result = isset($result[0]) ? implode("\r\n", $result[0]) : "";
echo $result;
exit;

print_r($result);


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