FROM ruby:2.5.3
MAINTAINER whj whj13004@gmail.com
RUN apt-get update && apt-get install -y openssl libssl-dev libyaml-dev libreadline-dev libxml2-dev libxslt1-dev nodejs
ENV LANG=C.UTF-8
WORKDIR /wang_projiect
COPY Gemfile /wang_projiect/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN gem install bundler
RUN bundle install
COPY . /wang_projiect
EXPOSE 3000

# Start the main process.
# CMD ["rails", "server", "-b", "0.0.0.0"]
