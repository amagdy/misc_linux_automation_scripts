#!/usr/bin/php5
<?php
/**
This script generates some code from yEd diagram editor output.
yEd generates .graphml files for class diagrams
and this script generates PHP code from these graphml files
Note that this script is very basic and does not interpret the UML relations shipts between classes/interfaces.
Usage:
	./yed_uml_to_php.sh class_diagram.graphml
N.B. Make sure there is an ampty folder on the same path with the script named "generated_code"
*/
//------------------------------------------------------------------------------
// delete PHP file
$files = glob('generated_code/*.php'); // get all file names
foreach($files as $file){ // iterate files
  if(is_file($file))
    unlink($file); // delete file
}
//------------------------------------------------------------------------------
function process_method_params($text){
	$bool = preg_match_all("/((?P<param>[a-z0-9A-Z_\$]+)\s*:\s*(?P<type>[a-z0-9A-Z_]+)\s*,?\s*)/", $text, $raw_params);
	if (!$bool) return array();
	$params = array();
	foreach($raw_params['param'] as $p){
		$params[] = (preg_match('/^$/', $p) ? $p : '$' . $p);
	}
	return array_combine($params, $raw_params['type']);
}
//------------------------------------------------------------------------------
function process_attributes($text){
	$output = array();
	$arr = explode("\n", $text);
	foreach($arr as $a){
		$a = trim($a);
		$bool = preg_match('/^(?P<modifier>[\+#\-]+)\s*(?P<attr>[a-zA-Z0-9_\$]+)\s*:?\s*(?P<type>[a-zA-Z0-9:\s]+)\s*;?/', $a, $matches);
		if (!$bool) continue;
			$attr = array();
			if ($matches['modifier'] == '+') {
				$attr['scope'] = 'public';			
			} elseif ($matches['modifier'] == '#') {
				$attr['scope'] = 'protected';
			} elseif ($matches['modifier'] == '-') {
				$attr['scope'] = 'private';			
			} else {
				continue;
			}
			$attr['attr'] = (preg_match('/^$/', $matches['attr']) ? $matches['attr'] : '$' . $matches['attr']);
			$attr['type'] = $matches['type'];
			$output[] = $attr;
	}
	
	return $output;
}
//------------------------------------------------------------------------------
function process_methods($text){
	$output = array();
	$arr = explode("\n", $text);
	foreach($arr as $m){
		$m = trim($m);
		$bool = preg_match('/^(?P<modifier>[\+#\-]+)\s*(?P<method>[a-zA-Z0-9_]+)\s*\(\s*(?P<params>[\$a-zA-Z0-9_:\s,]+)?\s*\):?(?P<return>[a-zA-Z0-9:\s]+)\s*;?/', $m, $matches);
		if (!$bool) continue;
			$method = array();
			if ($matches['modifier'] == '+') {
				$method['scope'] = 'public';			
			} elseif ($matches['modifier'] == '#') {
				$method['scope'] = 'protected';
			} elseif ($matches['modifier'] == '-') {
				$method['scope'] = 'private';			
			} else {
				continue;
			}
			$method['method'] = $matches['method'];
			$method['params'] = process_method_params($matches['params']);
			$method['return'] = $matches['return'];
			$output[] = $method;
	}
	
	return $output;
}
//------------------------------------------------------------------------------
function print_attribute($attr){
	return $attr['scope'] . " " . $attr['attr'] . ";\t\t// " . $attr['type'];
}
//------------------------------------------------------------------------------
function print_method_signature($method){
	$str = $method['scope'] . " function " . $method['method'] . "(";
	$i = 0;
	foreach ($method['params'] as $param => $type) {
		if ($i > 0) $str .= ', '; 
		$ltype = strtolower($type);
		if ($ltype != 'string' && $ltype != 'int' && $ltype != 'integer') {
			$str .= $type . " " . $param;
		} else {
			$str .= $param;
		}
		$i++;
	}
	$str .= ")";
	return $str;
}
//------------------------------------------------------------------------------
function print_method_docs($method, $padding="\t") {
	$str = $padding . "/*\n"; 
	$str .= $padding . "* " . $method['method'] . "\n";
	foreach ($method['params'] as $param => $type) {
		$str .= $padding . "* @param " . $param . " : " . $type . "\n";
	}
	if ($method['return'] && !empty($method['return'])) $str .= $padding . "* @return " . $method['return'] . "\n";	
	$str .= $padding . "*/\n";
	return $str;
}
//------------------------------------------------------------------------------
$xmlDoc = new DOMDocument();
$xmlDoc->load($argv[1]);
$arr = $xmlDoc->getElementsByTagName('UMLClassNode');
foreach ($arr as $class_node) {
	$str = "<?php\n";
	$class_name = trim($class_node->getElementsByTagName('NodeLabel')->item(0)->nodeValue);
	$attributes = process_attributes(trim($class_node->getElementsByTagName('AttributeLabel')->item(0)->nodeValue));
	$methods = process_methods(trim($class_node->getElementsByTagName('MethodLabel')->item(0)->nodeValue));
	$str .= "class $class_name {\n\n";
	foreach($attributes as $attr){
		$str .= "\t" . print_attribute($attr) . "\n";
	}
	$str .= "\n";
	foreach($methods as $meth){
		$str .= print_method_docs($meth);
		$str .= "\t" . print_method_signature($meth) . " {\n\n\t}\n\n";		
	}
	
	$str .= "\n}\n";
	// write the class to a file
	file_put_contents('generated_code/' . $class_name . ".php", $str);
}
//*/
