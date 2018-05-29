#
wget -c https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz -P /usr/local/src
cd /usr/local/src
tar -zxvf libevent-2.1.8-stable.tar.gz && cd libevent-2.1.8-stable
./configure --prefix=/usr/local/libevent-2.1.8
make && make install

wget -c http://pecl.php.net/get/event-2.3.0.tgz -P /usr/local/src
cd /usr/local/src
tar -zxvf event-2.3.0.tgz && cd event-2.3.0
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config --with-event-libevent-dir=/usr/local/libevent-2.1.8/
make && make install

extension=event.so