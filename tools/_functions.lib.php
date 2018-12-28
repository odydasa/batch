<?

/**
==============================================
 Special Functions
==============================================
*/
init();

function init()
{ global $argv, $param, $error, $help;
  $params = array();
  $error  = array();
  $help   = null;
  global_vars(explode(" ", "argv"));
  check_system();
}

function check_system()
{ foreach (explode(" ", "argv params error help") as $i=>$tmp)
  if (!isset(${$tmp}) || !is_array(${$tmp}) && ${$tmp}!=null)
  { global ${$tmp};
    #system error, cannot find $argv, $params, $error, or $help
    system_error();
  }
}

function system_error()
{ $error[] = "System error!";
  check_error();
}

function parse_params($argv_shift, $reset=false)
{ if ($argv_shift<1) system_error();
  global $argv, $params, $error;
  if ($reset) explode(" ", "argv");
  $argv = array_merge($argv, is_array($params) ? $params : array());
  if (count($argv)<$argv_shift)
     #parameter count is invalid
     $error[] = "Invalid number of parameter...";
  check_error();
  $params = array_slice($argv, $argv_shift);
  $argv   = array_slice($argv, 0, $argv_shift);
}

function global_vars(/*array*/ $var_list)
{ foreach (array_keys($var_list) as $i)
  { global ${$var_list[$i]};
    ${$var_list[$i]} = 
      (isset(${$var_list[$i]}) ? ${$var_list[$i]} : 
      (isset($HTTP_SERVER_VARS[$var_list[$i]]) ? $HTTP_SERVER_VARS[$var_list[$i]] :
      (isset($_SERVER[$var_list[$i]]) ? $_SERVER[$var_list[$i]] :
      (isset($_ENV[$var_list[$i]]) ? $_ENV[$var_list[$i]] : null))));
    if (${$var_list[$i]}==null) unset (${$var_list[$i]});
  }
}

function check_error()
{ global $error, $help, $params;
  #print_r($params);
  if (isset($error) && is_array($error) && count($error)>0)
  { 
  #   echo (in_array("-q", $params) ? implode("\n", $error) :
  #       "ERROR!\n"."- ".implode("\n- ", array_map("align_pad", $error, 
  #       array_pad(array(), count($error), 2)))."\n\n".
  #       (in_array("-nv", $params) ? "" : $help."\n\n"));
  #  exit;
  }
}

function file_argv($argv_index=1)
{ global $argv, $error;
  if (!isset($argv[$argv_index]) || !is_file($argv[$argv_index]))
  { #no file supplied or no file exists
    $error[] = "Invalid File...";
    check_error();
  }
}

function default_argv($argv_index, $val="", $forced=false)
{ global $argv;
  if ($argv_index>=count($argv))
  for ($i=count($argv); $i<=$argv_index; $i++)
      if (!isset($argv[$i])) $argv[$i] = null;
  if ($forced && isset($argv[$argv_index]))
     $argv[$argv_index] = $val;
}

/**
==============================================
 General Functions
==============================================
*/

function blank(){}

function eol_dos()  {return eol(0);}
function eol_unix() {return eol(1);}
function eol_mac()  {return eol(2);}

function eol($type=0)
{ return ($type==2 ? "\r" : ($type==1 ? "\n" : "\r\n"));
}

function isort(&$array)
{ usort($array, "cmp");
}

function cmp ($a, $b)
{ if (strtolower($a)==strtolower($b)) return 0;
  return (strtolower($a)<strtolower($b)) ? -1 : 1;
}

function read_file($filename="")
{ return is_file($filename) ?
         implode("", file($filename)):
         false;
}

function write_file($filename, $data)
{ $fp = fopen( $filename,"w+"); 
  if (!fwrite( $fp, $data)) return false;
  fclose( $fp ); 
}

function fix_slash($txt, $is_backslash=false)
{ $out = $txt;
  if (!($is_backslash) && substr($out, -1)!="/" || 
      $is_backslash && substr($out, -1)!="\\")
     $out .= "/";
  $out = str_replace("\\", "/", $out);
  $out = str_replace("//", "/", $out);
  if ($is_backslash)
     $out = str_replace("/", "\\", $out);
  return $out;
}

function fix_name($txt, $is_ucwords=true)
{ $out = str_replace("_", " ", $txt);
  $out = str_replace("%20", " ", $out);
  return $is_ucwords ? ucwords($out):$out;
}

function ack($ack="", $color="")
{ return $ack!="" ? "<b><font color=\"".($color==""?"red":$color)."\">".
                    $ack."</font></b>" : "";
}

function spacify_text($txt, $spacer=" ")
{ return implode($spacer, preg_split('//', $txt, -1, PREG_SPLIT_NO_EMPTY));
}

function align_pad($text, $pad_length, $pad_text=" ", $pad_type=0)
{ if ($pad_length==0) return $text;
  if ($pad_length<0)
  { $pad_length = $pad_length<strlen($text) ? $pad_length:strlen($text);
    return substr($text, 0, $pad_length);
  }
  return $text;
  $pad_length    -= strlen($text);
  $repeat_length  = ceil($pad_length/strlen($text));
  if ($pad_text=null || strlen($pad_text)<1 || $pad_text="")
     $pad_text = " ";
  $pad_text = str_repeat($pad_text, $repeat_length);
  if (strlen($pad_text)>$pad_length)
     $pad_text = substr($pad_text, 0, $pad_length);
  switch ($pad_type)
  { case 0:
      $text += $pad_text;
      break;
    case 1:
      $text = $pad_text + $text;
      break;
    case 2:
      $repeat_length = round($pad_length/2) + (pad_length % 2 == 0 ? 0 : 1);
      $pad_length    = strlen($pad_text) + strlen($text);
      $pad_text      = substr($pad_text, 0, $repeat_length);
      $text         += strrev($pad_text);
      if (strlen($text) + strlen($pad_text) > $pad_length)
        $pad_text = substr($pad_text, 0, pad_length - strlen($text));
      $text = $pad_text + $text;
      break;
    }
    return $text;
  
  

}

function display_perms($mode)
{ # Determine Type */ 
  $type = array( "p"=>0x1000,  # FIFO pipe
                 "c"=>0x2000,  # Character special
                 "d"=>0x4000,  # Directory
                 "b"=>0x6000,  # Block special
                 "-"=>0x8000,  # Regular
                 "l"=>0xA000,  # Symbolic Link
                 "s"=>0xC000   # Socket
                );
  foreach (array_keys($type) as $i)
    if ($mode & $type[$i]) { $type = $i; break;}
  if (is_array($type)) $type = "u";  # UNKNOWN

  # Determine permissions
  $perm["o"]["r"] = ($mode & 00400) ? "r":"-";
  $perm["o"]["w"] = ($mode & 00200) ? "w":"-";
  $perm["o"]["x"] = ($mode & 00100) ? "x":"-";
  $perm["g"]["r"] = ($mode & 00040) ? "r":"-";
  $perm["g"]["w"] = ($mode & 00020) ? "w":"-";
  $perm["g"]["x"] = ($mode & 00010) ? "x":"-";
  $perm["w"]["r"] = ($mode & 00004) ? "r":"-";
  $perm["w"]["w"] = ($mode & 00002) ? "w":"-";
  $perm["w"]["x"] = ($mode & 00001) ? "x":"-";

  # Adjust for SUID, SGID and sticky bit
  if ($mode & 0x800) $perm["o"]["x"] = $perm["o"]["x"] ? "s" : "S";
  if ($mode & 0x400) $perm["g"]["x"] = $perm["g"]["x"] ? "s" : "S";
  if ($mode & 0x200) $perm["w"]["x"] = $perm["w"]["x"] ? "t" : "T";

  $out = $type;
  foreach (array_keys($perm) as $i)
  foreach (array_keys($perm[$i]) as $j)
    $out .= $perm[$i][$j];
  return $out;
}

?>