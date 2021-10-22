# Storyline: Send an email.

# Body of the email
$msg = "Hello there."

# Echoing to the screen.
write-host -BackgroundColor Red -ForegroundColor White "$msg"

# Email from Address
$email = "jason.quiroga@mymail.champlain.edu"

# Email to Address
$toEmail = "deployer@csi-web"

# Send the email
Send-MailMessage -From $email -to $toEmail -Subject "A Greeting" -Body $msg -SmtpServer 192.168.6.71