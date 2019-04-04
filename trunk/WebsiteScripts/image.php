<?PHP

//$target_path = "/";
$target_path = $_REQUEST[ 'path' ];
//$target_path .= "/";
$target_path = $target_path . basename( $_FILES[ 'Filedata' ][ 'name' ] ); 

echo "the value of target path is:" . $target_path ."\n";
echo "the value of basename or whatever is:" . basename( $_FILES[ 'Filedata' ][ 'name' ]) . "\n";

if ( move_uploaded_file( $_FILES[ 'Filedata' ][ 'tmp_name' ], $target_path ) ) 
{
     echo "The file " . basename( $_FILES[ 'Filedata' ][ 'name' ] ) . " has been uploaded;";
} 
else
{
     echo "There was an error uploading the file, please try again!";
	 
	 //BEGIN MY NEW CRQZY STUFF
	 /*
	 $output = "<html><head><title></title></head><body>";
	 
	 $output .= "maybe I am making a website now?\n\n";
	 
	 $output .= "<img src=" . basename( $_FILES[ 'Filedata' ][ 'name' ]) . "/>";
	 
	 $output .= "</body></html>";
	 
	 echo $output;
	 
	$fp = fopen("temp2.html", "wb");
	fwrite($fp, $output);
	fclose($fp);
	*/
	
	//END CRAZY STUFF
	 
}
?>
