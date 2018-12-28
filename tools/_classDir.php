<?

class DirObject
{ var $root_path = "../";
  var $root_link = "./";

  function DirObject($root_path="", $root_link="")
  { if ($root_path!="") $this->root_path = $root_path;
    if ($root_link!="") $this->root_link = $root_link;
    $this->root_path = $this->fix_slash($this->root_path);
    $this->root_link = $this->fix_slash($this->root_link);
  }

  function browse($dir="", $filter="", $array_output=false)
  { $dir = $dir=="" ? $this->root_path : $this->fix_slash($dir);
    if (!is_dir($dir)) return false;
    switch (strtolower($filter))
    { case "":
      case "all":
        $filter="11";
        $output = array("path"=>$dir, "dir"=>array(), "file"=>array());
        break;
      case "dir":
        $filter="10";
        $output = array();
        break;
      case "file":
        $filter="01";
        $output = array();
        break;
      default:
        return false;
        break;
    }
    $d = dir($dir);
    while($list=$d->read())
    if (!in_array($list, explode(" ", ". ..")))
    { $tmp = filetype($dir.$list);
      if ($filter=="11")
         $output[$tmp][] = $tmp=="file" ? $list : $this->fix_slash($list);
      else
      if ($tmp=="dir" && $filter=="10" ||
          $tmp=="file" && $filter=="01")
          $output[] = $tmp=="file" && $filter=="01" ? $list : $this->fix_slash($list);
    }
    if ($filter=="11")
    { $output["dir"]  = $this->isort($output["dir"], true, ".");
      $output["file"] = $this->isort($output["file"], true, ".");
    }
    else
       $output = $this->isort($output, true, ".");
    return $output;
  }

  function browse_dir($dir="", $recursive=false, $level="", $array_output=false)
  { $dir    = $dir=="" ? $this->root_path : $this->fix_slash($dir);
    if ($level=="") $level=0;
    $tmp = $this->browse($dir, "dir");
    if ($recursive && $tmp!=false)
    { $output = $array_output ? array() : "";
      foreach (array_keys($tmp) as $i)
      { $tmp2 = $this->browse_dir($dir.$tmp[$i], $recursive, $level+1, $array_output);
        if ($array_output)
        { $output[] = $tmp[$i];
          if (is_array($tmp2) && count($tmp2)>0)
              $output[] = $tmp2;
        }
        else
        { $output .= str_repeat(":",$level).$tmp[$i]."\n".
                     (is_array($tmp2) ? implode("\n", $tmp2) : $tmp2);
        }
      }
    }
    else $output = $tmp;
    return $output;
  }

  function isort($array, $ext_parsed=false, $ext_spacer="")
  { if (!is_array($array)) return $array;
    $tmp    = array();
    $output = array();
    foreach (array_keys($array) as $i)
    { if ($ext_parsed && $ext_spacer!="")
      { if (strrpos($array[$i], $ext_spacer)>0)
        { $tmp2 = substr($array[$i], strrpos($array[$i], $ext_spacer));
          $tmp3 = substr($array[$i], 0, strrpos($array[$i], $ext_spacer));
        }
        else
        { $tmp2 = " ";
          $tmp3 = $array[$i];
        }
        $array[$i] = $tmp2.":".$tmp3;
      }
      $tmp[] = strtolower($array[$i])."\\".$i;
    }
    sort($tmp);
    if ($ext_parsed && $ext_spacer!="")
    foreach (array_keys($array) as $i)
    { $array[$i] = explode(":", $array[$i]);
      $array[$i][0] = trim($array[$i][0]);
      $array[$i] = $array[$i][1].$array[$i][0];
    }
    foreach (array_keys($tmp) as $i)
    { $tmp[$i] = explode("\\", $tmp[$i]);
      $output[] = $array[$tmp[$i][1]];
    }
    return $output;
  }

  function fix_space($txt, $trim=false)
  { return $trim ?
           trim(eregi_replace("[[:space:]]+", " ", $txt)) :
           eregi_replace("[[:space:]]+", " ", $txt);
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


}
?>