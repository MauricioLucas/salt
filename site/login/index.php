<?php

define('TITLE', 'Login');

if (isset($_POST['cmd']) and $_POST['cmd'] == 'Log in')
{
	$error = 'invalid username or password.';
}

?>
<?php include_once(dirname(__FILE__) . '/../header.php'); ?>
<?php if (isset($error)) { ?>
<p class="error">Error: <?php echo $error; ?></p>
<?php } ?>
<form id="login" method="post" action="./">
  <table class="details">
    <tr>
      <td><label for="user">Username</label></td>
      <td><input name="user" type="text" id="user" size="45" maxlength="16" /></td>
    </tr>
    <tr>
      <td><label for="pass">Password</label></td>
      <td><input name="pass" type="text" id="pass" size="45" maxlength="32" /></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td><input type="submit" name="cmd" id="cmd" value="Log in" /></td>
    </tr>
  </table>
</form>
<?php include_once(dirname(__FILE__) . '/../footer.php'); ?>
