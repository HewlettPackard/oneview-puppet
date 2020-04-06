################################################################################
# (C) Copyright 2020 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
################################################################################
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

# Clean and remove not required packages
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/cache/apt/archives/* /var/cache/apt/lists/* /tmp/* /root/cache/.
