<?php

define('BASE', './');

?>
<?php include_once(dirname(__FILE__) . '/header.php'); ?>
<h2>Welcome</h2>
<p>Standard AutoHotkey Library Transfer (SALT) is a powerful and versatile <a href="http://www.autohotkey.com/docs/Functions.htm#lib">standard library</a> repository featuring:</p>
<ul>
  <li>Categorised script listing with searchable criteria</li>
  <li>A centralised database for developers to update their work</li>
  <li>Full revision control, view and compare with historic versions</li>
  <li>Automatic dependancy resolving</li>
</ul>
<?php if (!$login) { ?>
<form id="login" method="post" action="<?php echo BASE; ?>login/">
  <label>Username
    <input type="text" name="user" id="user" />
  </label>
  <label>Password
    <input type="text" name="pass" id="pass" />
  </label>
  <label>
    <input type="submit" name="act" id="act" value="Log in" />
  </label>
</form>
<?php } ?>
<p>This project is currently in <a href="http://code.google.com/p/salt/">development stage</a>, feedback and suggestions are welcome.<br />
Authors: Titan, <a href="<?php echo BASE; ?>derraphael/">derRaphael</a>, IsNull, infogulch and Tuncay.</p>
<?php include_once(dirname(__FILE__) . '/footer.php'); ?>
