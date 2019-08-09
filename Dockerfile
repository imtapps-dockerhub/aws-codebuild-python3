# Copyright 2017-2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Amazon Software License (the "License"). You may not use this file except in compliance with the License.
# A copy of the License is located at
#
#    http://aws.amazon.com/asl/
#
# or in the "license" file accompanying this file.
# This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or implied.
# See the License for the specific language governing permissions and limitations under the License.
#

# Modified

FROM amazonlinux:2018.03

RUN curl --silent --location https://rpm.nodesource.com/setup_8.x | bash - \
    && yum install python34 python34-devel python34-pip python34-setuptools python34-virtualenv nodejs bzip2 fontconfig openssh-clients libxml2-devel libxslt-devel git gcc -y \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && pip-3.4 install awscli --no-cache-dir \
    && cd /opt \
    && npm install -g npm@latest \
    && cd /usr/local/bin \
    && ln -s /usr/bin/pydoc34 pydoc \
    && ln -s /usr/bin/python34 python \
    && ln -s /usr/bin/python34-config python-config \
    && ln -s /usr/bin/pip-3.4 pip \
    && set -x && \
    # Install docker-compose
    # https://docs.docker.com/compose/install/
    DOCKER_COMPOSE_URL=https://github.com$(curl -L https://github.com/docker/compose/releases/latest | grep -Eo 'href="[^"]+docker-compose-Linux-x86_64' | sed 's/^href="//' | head -1) && \
    curl -Lo /usr/local/bin/docker-compose $DOCKER_COMPOSE_URL && \
    chmod a+rx /usr/local/bin/docker-compose && \
    \
    # Basic check it works
    docker-compose version \
    && rm -rf /tmp/* /var/tmp/*

VOLUME /var/lib/docker

COPY dockerd-entrypoint.sh /usr/local/bin/

ENV PATH="/usr/local/bin:$PATH"

ENV LANG="en_US.utf8"

CMD ["python3"]

ENTRYPOINT ["dockerd-entrypoint.sh"]
