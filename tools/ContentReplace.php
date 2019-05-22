<?
require_once (str_replace("\\", "/", dirname(__FILE__)."/".
               "_functions.lib.php"));

$valid_params = array_map("strtolower", explode(" ", 
                "-dump -i -regex -q -nv"));

$help = trim("
Valid arguments: filename search_text [replace_text [options]]

Options:
  -dump    write result to stdout, don't use this with -q or -nv
  -regex   \"search_text\" acts as regex pattern
  -i       specifies that the text replace is not to be case-sensitive
  -q       quiet, no output, don't use this with -dump or -nv
  -nv      simple report, don't use this with -dump or -q
");


# parameter & error parsing
default_argv(3, "");
parse_params(4);
file_argv(1);
$file   = $argv[1];
$txt1   = $argv[2];
$txt2   = $argv[3];

# - parameter validation
$tmp = array();
if (is_array($params))
foreach (array_keys($params) as $i)
{ if (!in_array($params[$i], $valid_params))
  $tmp[] = $params[$i];
}
if (count($tmp)>0)
{ # invalid parameter found
  $error[] = "Invalid parameter found: ".implode(", ", $tmp);
  check_error();
}

# - validate parameters shouldn't be together
$tmp = explode(" ", "-nv -q -dump");
$j   = $tmp;
foreach (array_keys($j) as $i)
if (in_array($j[$i], $params))
   unset($j[$i]);
$tmp = array_diff($tmp, $j);
if (count($tmp)>1)
{ # parameter -nv, -q, -dump shouldn't be together
  $error[] = "These parameters should not found together: ".implode(", ", $tmp);
  check_error();
}

# convert special characters: \n, \r, and \t
$special = "n|\n r|\r t|\t";
$special = explode(" ", $special);
$tmp = array();
foreach (array_keys($special) as $i)
{ $special[$i]               = explode("|", $special[$i]);
  $tmp["\\".$special[$i][0]] = $special[$i][1];
}
$special = $tmp;
foreach (explode(" ", "txt1 txt2") as $i=>$txt)
{ preg_match_all("/\\\\([".str_replace("\\", "", implode("", 
                 array_keys($special)))."])/", ${$txt}, $keys);
  $keys = array_flip(array_map("preg_quote", array_intersect(
          array_flip($special), array_unique($keys[0]))));
  if (count($keys)>0)
  foreach (array_keys($keys) as $j)
     ${$txt} = ereg_replace($j, $keys[$j], ${$txt});
}

#convert chr(n) into ascii character
#  this is purposed for command line character limitation
#  i.e: chr(34)=", chr(42)=*, chr(47)=/, chr(58)=:, chr(59)=;, chr(60)=<, 
#       chr(62)=>, chr(63)=?, chr(92)=\, chr(124)=|
foreach (explode(" ", "txt1 txt2") as $i=>$txt)
{ preg_match_all("|chr\\(([\\d]{1,3})\\)|i", ${$txt}, $keys);
  $keys[0] = array_flip($keys[0]);
  foreach (array_keys($keys[0]) as $j)
    $keys[0][$j] = chr($keys[1][$keys[0][$j]]);
  $keys = array_unique($keys[0]);
  if (count($keys)>0)
  foreach (array_keys($keys) as $j)
     ${$txt} = eregi_replace(preg_quote($j), $keys[$j], ${$txt});
}

#processing...
$tmp = !in_array("-regex", $params) ? preg_quote($txt1) : $txt1;
$data = implode("", file($file));

if (is_array($params))
if (!(in_array("-i", $params) ? eregi($tmp, $data) : ereg($tmp, $data)))
{ $tmp = "String not found!";
  $error[] = in_array("-q", $params) ? $tmp :
             "Try to find : \"".align_pad(addslashes($txt1), 15)."\"\n".
             "In file     : \"$file\"\n".
             "Error       : $tmp".
             (in_array("-i", $params) ? "" : align_pad("\n".
             "Try to use -i parameter",
             14));
  check_error();
}
$data = in_array("-i", $params) ? 
        eregi_replace($tmp, $txt2, $data) :
        ereg_replace($tmp, $txt2, $data);

if (is_array($params))
if (in_array("-dump", $params))
   echo $data;
else
{ echo (in_array("-q", $params) ? "" : (in_array("-nv", $params) ?
  "$file: " :
  "File         : \"$file\"\n"));
  $fp = fopen( $file,"w+"); 
  fwrite( $fp, $data);
  fclose( $fp ); 
  echo (in_array("-q", $params) ? "" : (in_array("-nv", $params) ? " ":
       "Search Text  : \"".align_pad(addslashes($txt1), 15)."\"\n".
       "Replace Text : \"".align_pad(addslashes($txt2), 15)."\"\n"
  )."Done.\n");
}

?>