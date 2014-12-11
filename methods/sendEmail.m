function [exit_code] = sendEmail(who)
% NOTE: CHANGE THESE 2 LINES OF CODE TO REFLECT YOUR SETTINGS.
mySMTP = 'smtp.gmail.com';
myEmail = 'mmorcv@gmail.com';
password='12341234dxz';

props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

% Set your email and SMTP server address in MATLAB.
setpref('Internet','E_mail',myEmail);
setpref('Internet','SMTP_Server',mySMTP);
setpref('Internet','SMTP_Username',myEmail);
setpref('Internet','SMTP_Password',password);

% Send an email to someone
recipient = who;
subj = 'Experiment is finished!';
msg = 'Your experiemnt is finished! Please check the result!';
sendmail(recipient,subj,msg);
exit_code = 1;
end

