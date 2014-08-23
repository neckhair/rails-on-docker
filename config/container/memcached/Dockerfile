FROM ubuntu:trusty

RUN apt-get -qq update && apt-get install -y memcached

EXPOSE 11211

ENTRYPOINT ["/usr/bin/memcached"]

CMD ["-u", "root", "-m", "128", "-vv"]
