FROM ubuntu
RUN apt-get update
RUN apt-get install -yq git gcc g++ make libsqlite3-dev libssl-dev libreadline-dev curl

# Setup rbenv
ENV RBENV_ROOT /rbenv
RUN mkdir -p $RBENV_ROOT
RUN git clone https://github.com/sstephenson/rbenv.git $RBENV_ROOT
RUN git clone https://github.com/sstephenson/ruby-build.git $RBENV_ROOT/plugins/ruby-build
RUN $RBENV_ROOT/plugins/ruby-build/install.sh
ENV PATH $RBENV_ROOT/bin:$PATH
# Not that it helps much . . .
RUN echo 'eval "$(rbenv init -)"' >> ~/.bashrc
ENV CONFIGURE_OPTS --disable-install-doc

# Build everything
# Adding ruby-version and Gemfile here lets Docker
# cache the ruby and gems unless they change.
ADD ./hello/.ruby-version /
RUN rbenv install
RUN rbenv local

RUN eval "$(rbenv init -)" && gem install bundle --no-document
ADD ./hello/Gemfile /
RUN eval "$(rbenv init -)" && bundle install --without development test
RUN rm /.ruby-version /Gemfile

# Configure the app
ADD ./hello /app
WORKDIR /app
RUN eval "$(rbenv init -)" && bundle install --without development test

RUN mkdir -p /app/tmp
ENV RAILS_ENV production
RUN eval "$(rbenv init -)" && bundle exec rake assets:precompile
RUN adduser --disabled-password --gecos "" app
RUN touch /app/log/production.log
RUN chown -R app /app/log /app/tmp /app/db
USER app
RUN eval "$(rbenv init -)" && bundle exec rake db:setup
VOLUME ["/app/log", "/app/db"]
EXPOSE 8080
CMD ["bash", "-c", "eval \"$(rbenv init -)\" && bundle exec unicorn -p 8080"]
