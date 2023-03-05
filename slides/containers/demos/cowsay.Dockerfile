FROM ubuntu

RUN apt-get update && apt-get install -y cowsay

CMD ["/usr/games/cowsay", "Hello World"]
