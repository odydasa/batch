<?
$valid_params = array_map("strtolower", explode(" ", 
                "-dump"));
$allowed_tags = "p br h1 h2 h3";
$skip_tags    = "img a";
$eol          = "\r\n";

$help = trim("
Valid arguments: filename [allowed_tags [options]]

Type tags will be allowed, sparated by space, or just let it blank.
allowed_tags: 
   \"\"    default allowed tags: $allowed_tags
   -     no tag allowed

Options:
  -dump    write result to stdout
  
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
if (!isset($argv[2])) $argv[2] = "";

$file         = $argv[1];
$params       = array_map("strtolower", array_slice($argv, 3));
$argv         = array_slice($argv, 0, 3);

$allowed_tags = isset($argv[2]) && !empty($argv[2]) ? $argv[2] : $allowed_tags;
$allowed_tags = explode(" ", strtolower($allowed_tags=="-" ? "":$allowed_tags));
$skip_tags    = explode(" ", strtolower($skip_tags));


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

# data process
$data = implode("", file($argv[1]));
$data = fix_tags($data, $allowed_tags, $skip_tags, $eol);
$data = fix_char($data);
$data = fix_space($data, 76, $eol);

#params parsing
if (in_array("-dump", $params))
   echo $data;
else
{ echo "$file: ";
  $fp = fopen($file,"w+"); 
  fwrite($fp, $data);
  fclose($fp);
  $found_tags = array();
  foreach (array_keys($allowed_tags) as $i)
  if (ereg (make_ereg_tags($allowed_tags[$i]), $data))
     $found_tags[] = strtoupper($allowed_tags[$i]);
  echo "all tags stripped".(count($found_tags)>0 ? 
       ", except ".implode("|", $found_tags):"").".".$eol;
}

# ---------------------------------------------------

function make_tags($txt)
{ return strtolower("<".$txt.">");
}

function make_endtags($txt)
{ return strtolower("</".$txt.">");
}

function make_ereg_tags($txt)
{ return strtolower(preg_quote("<".$txt)."[^".preg_quote(">")."]*".preg_quote(">"));
}

function make_ereg_endtags($txt)
{ return strtolower(preg_quote("</".$txt)."[^".preg_quote(">")."]*".preg_quote(">"));
}

function fix_tags($txt, $allowed_tags=array(), $skip_tags=array(), $eol="\r\n")
{ $txt = strip_tags($txt, "<".implode("><", $allowed_tags).">");
  foreach (array_keys($allowed_tags) as $i)
  { $txt = eregi_replace("<".$allowed_tags[$i],  "<".$allowed_tags[$i], $txt);
    $txt = eregi_replace("</".$allowed_tags[$i], "</".$allowed_tags[$i], $txt);
  }
  foreach (array_keys($allowed_tags) as $i)
  { $skipped = false;
    foreach (array_keys($skip_tags) as $j)
    if ($allowed_tags[$i]==$skip_tags[$j])
       $skipped = true;
    // this makes closing tags to be cleared from 
    // white space and other chars
    $txt = eregi_replace(make_ereg_endtags($allowed_tags[$i]),    
                         make_endtags($allowed_tags[$i]),
                         $txt);
    if (!$skipped)
       $txt = eregi_replace(make_ereg_tags($allowed_tags[$i]),
                            make_tags($allowed_tags[$i]),
                            $txt);
  }
  $txt  = eregi_replace("[[:space:]]+", " ", $txt);
  $txt  = eregi_replace("[[:space:]]*</", "</", $txt);
  $txt  = eregi_replace("</p>[[:space:]]*", "</p>".$eol, $txt);
  $txt  = eregi_replace("[[:space:]]*<p>", $eol."<p>", $txt);
  $txt  = eregi_replace("[[:space:]]*<br>[[:space:]]*", "<br>".$eol, $txt);
  $txt  = eregi_replace("<p>[[:space:]]*</p>[[:space:]]*", "<br><br>".$eol, $txt);
  $txt  = eregi_replace("(<br>[[:space:]]*<br>[[:space:]]*)+", "<br><br>".$eol, $txt);
  $txt = eregi_replace("<(br)[^>]*>", "<br>", $txt);
  return $txt;
}


function fix_char($txt)
{ foreach (get_html_translation_table(HTML_ENTITIES) as $i=>$tmp)
  if ($i!="<" && $i!=">" && $i!="\"" && $i!="'")
    $txt = str_replace($tmp, ($tmp=="&nbsp;" ? " ":$i), $txt);
  return $txt;
}

function fix_space($txt, $size=76, $eol="\r\n")
{ #$txt = eregi_replace("(<h[^>]*>)(^</h)(</h[^>]*>)([[:space:]]*)", trim("\\1").
  #       "\n", $txt);
  eregi("(<h[^>]*>)", $txt, $x);
  print_r($x);
  $txt  = eregi_replace(">".$eol."*<", ">".$eol.$eol."<", $txt);
  $txt  = eregi_replace($eol, "\n", $txt);
  $txt  = explode("\n", $txt);
  $txt  = array_map("fix_paragraph", $txt, 
                    array_pad(array(), $size, $size),
                    array_pad(array(), $size, $eol)
                   );
  $txt  = trim(implode($eol, array_map("trim", $txt))).$eol;
  return $txt;
}

function fix_paragraph($txt, $size=76, $eol="\r\n")
{ $out="";
  $j=0;
  foreach (explode(" ", $txt) as $i=>$tmp)
  { $j += (strlen($tmp)+1);
    $out .= ($j<$size ? "" : $eol).$tmp." "; 
    if ($j>=$size) $j=0;
  }
  return $out.$eol; 
}

$string = "<h1>kocok</h1> kocok textx\nasdasdad<br>\n";
#echo $string;
#echo eregi_replace("(<h[^>]*>)(.*)(</h[^>]*>)([[:space:]]*)", "\\1\\2\\3\n", $string);

?>