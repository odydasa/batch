<?
require_once (str_replace("\\", "/", dirname(__FILE__)."/".
               "_functions.lib.php"));
global_vars(explode(" ", "COMPUTERNAME"));

$help = trim("
Valid arguments: FunctionName [functionParam1 [functionParam2 [...]]]
FunctionName must be valid function in PHP.

Please read from manual: http://".strtolower($COMPUTERNAME).
get_cfg_var("docref_root")."
");

# parameter & error parsing
parse_params(2);
$fn  = strtolower($argv[1]);

# processing...
$ext = get_loaded_extensions();
$tmp = $fn;
unset($fn);
usort($ext, "cmp");
foreach (array_keys($ext) as $i)
{ foreach ((get_extension_funcs($ext[$i])) as $j=>$_fn)
  { if ($tmp==strtolower($_fn)) $fn = $_fn;
    if (isset($fn)) break;
  }
  if (isset($fn)) break;
}
if (isset($fn))
{ $tmp = array_keys($params);
  $tmp = "print_r(\$fn(".(count($params>0) ? 
         "\$params[".implode("], \$params[", $tmp)."]" : "")."));";
  echo eval($tmp);
}
else 
  $error[] = "You requested nonexisting function: ".$argv[1];

check_error();
?>