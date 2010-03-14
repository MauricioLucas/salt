<?php

if (!defined('BASE'))
	define('BASE', '../');

$login = false;

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><?php if (defined('TITLE')) echo(TITLE . ' - '); ?>SALT</title>
<link href="<?php echo BASE; ?>theme.css" rel="stylesheet" type="text/css" />
</head>
<body>
<div id="nav">
  <ul>
    <li><a href="<?php echo BASE; ?>">Home</a></li>
    <?php if (!$login) { ?>
    <li><a href="<?php echo BASE; ?>login/">Login</a></li>
    <li><a href="<?php echo BASE; ?>register/">Register</a></li>
	<?php } ?>
    <?php if ($login) { ?>
    <li><a href="<?php echo BASE; ?>logout/">Logout</a></li>
	<?php } ?>
    <li><a href="http://code.google.com/p/salt/w/list">About</a></li>
  </ul>
</div>
<div id="content">
