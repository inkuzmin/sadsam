nodemailer = require 'nodemailer'

smtpTransport = nodemailer.createTransport 'SMTP',
    service: 'Gmail'
    auth:
        user: 'sadsam.ru@gmail.com'
        pass: 'rghtewn21512@FS'



exports.send = (request, responce) ->
    name  = request.body.name
    phone = request.body.phone
  
    mailOptions =
      from: "Заказ с сайта <order@sadsam.ru>"
      to: "inkuzmin@ya.ru"
      subject: "Заказ с сайта"
      text: "#{name} просит перезвонить по телефону #{phone}."

    smtpTransport.sendMail mailOptions, (error, response) ->
        if (error)
        	console.log(error);
        else
        	console.log("Message sent: " + response.message);
       	smtpTransport.close()
    