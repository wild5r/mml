

$soft = [ 'postgresql', 'apg', ]
	 
	package { $soft :
		ensure => installed
	}
	
 
	 
	

# #################################################
# # Запускаем базу Устанавливаем дефолтный пароль #
# #################################################
	# service { 'mysql' : 
		# ensure 	=> 	running, 
		# enable 	=> 	true, 
		# require =>	[ 
			# Package[$soft],
			# ],
	# }
	

	# exec { 'Change password' :
		# unless		=> "/usr/bin/test -f /root/.my.cnf",
		# path   		=> 	"/bin:/sbin:/usr/bin:/usr/sbin:/bin",
		# command		=> 	 '/bin/bash -c "b=\$(apg -n 1 -m 10 -x 15) && echo \"[client]\" >> /root/.my.cnf && echo \"host=127.0.0.1\" >> /root/.my.cnf &&	echo \"password=\$b\" >> /root/.my.cnf && mysqladmin --password=\'\' --host=127.0.0.1 password \$b"',
		# logoutput	=> true,
		# subscribe	=> Service['mysql'],
		# notify		=>	File['/root/.my.cnf'],
	# }




# ##################################################
# # Обязательно проверяем права  на файл с паролем #
# ##################################################		

	
	# file { '/root/.my.cnf' :
		# mode	=> 0400,
		# owner	=> 'root',
	# }

