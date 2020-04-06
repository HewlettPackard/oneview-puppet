FROM ruby:2.4

# Install dependencies
RUN apt-get -qqy update && \
	apt-get -qqy install \
	curl \
	make \
	vim  \
	mlocate && \
	updatedb  


RUN gem install --no-document bundler

RUN mkdir /puppet
WORKDIR /puppet
RUN echo `pwd` > ./pwd
COPY . /puppet

RUN bundle
RUN puppet module install hewlettpackard-oneview
