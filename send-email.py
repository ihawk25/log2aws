#!/usr/bin/python

import os,sys,smtplib

subject = sys.argv[1]
attach = sys.argv[2]
attach_name = attach.split(os.sep)
recipients = ['tonye@pbssystems.com', 'codyj@pbssystems.com', 'ccallahan@ddslive.com', 'general-mailbox@ddslive.com']

from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

# Create the container (outer) email message.
msg = MIMEMultipart()
msg['Subject'] = subject
msg['To'] = ", ".join(recipients)
msg.preamble = subject

# Attach file with MIME
f = file(attach)
attachment = MIMEText(f.read())
attachment.add_header('Content-Disposition', 'attachment', filename=attach_name[-1] ) 
msg.attach(attachment)

server = smtplib.SMTP( "smtp.gmail.com", 587 )
#server.set_debuglevel(1)
server.starttls()
server.login( 'log2aws@gmail.com', '1992LOG2AWS2016' )
server.sendmail( '' , recipients , msg.as_string() )
server.quit()
