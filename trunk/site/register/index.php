<?php

define('TITLE', 'Register');

if (isset($_POST['cmd']) and $_POST['cmd'] == 'Submit')
{
	
}

$error = 'not accepting new registrations at this time.';

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
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td><label for="pass">Password</label></td>
      <td><input name="pass" type="text" id="pass" size="45" maxlength="32" /></td>
    </tr>
    <tr>
      <td><label for="confirm">Confirm</label></td>
      <td><input name="confirm" type="text" id="confirm" size="45" maxlength="32" /></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td><label for="email">Email</label></td>
      <td><input name="email" type="text" id="email" size="45" maxlength="45" /></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td><label>
          <input type="checkbox" name="terms" id="terms" />
          Agree to <a href="<?php echo BASE; ?>terms/">Terms and Conditions</a></label></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td><input type="submit" name="cmd" id="cmd" value="Submit" /></td>
    </tr>
  </table>
</form>
<?php include_once(dirname(__FILE__) . '/../footer.php'); ?>
