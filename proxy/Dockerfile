FROM ubuntu
RUN apt-get update
RUN apt-get install -y apache2-mpm-event ruby-json ruby-sinatra thin supervisor

RUN rm -rf /etc/apache2
ADD apache2.conf /etc/apache2/apache2.conf
RUN mkdir -p /etc/apache2/conf

ADD proxy_balancer.conf /etc/apache2/conf/proxy_balancer.conf

RUN mkdir -p /var/log/supervisor

ADD app.rb /app.rb
ADD appservers.conf.erb /appservers.conf.erb
RUN touch /appservers.conf
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 80 4567
CMD ["/usr/bin/supervisord"]
