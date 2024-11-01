<?php
$Direktori = "/usr/local/www/FreeBSD:13:i386"; // Specify the path to the Direktori you want to display

// Get the list of files and directories in the specified Direktori
$files = scandir($Direktori);

// Remove "." and ".." from the list
$files = array_diff($files, array(".", ".."));

// Sort the files and directories alphabetically
sort($files);

// Generate the HTML markup
echo "<ul>";
foreach ($files as $file) {
    $path = $Direktori . "/" . $file;
    if (is_dir($path)) {
        echo "<li><strong>Direktori:</strong> <a href=\"$file/\">$file</a></li>";
    } else {
        echo "<li><strong>File:</strong> <a href=\"$file\">$file</a></li>";
    }
}
echo "</ul>";

