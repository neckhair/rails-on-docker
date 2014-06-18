# Rails on Docker

## Prerequisites

Install docker for your system. Google will tell you how that works.

Then install fig:

    curl -L https://github.com/orchardup/fig/releases/download/0.4.1/darwin > /usr/local/bin/fig
    chmod +x /usr/local/bin/fig

## Create and run the container

This example creates a single Rails container with a SQLite Database. The db is setup in
the Dockerfile.

Build the containers:

    fig build

Then run the whole stuff:

    fig up

Now you can connect to http://localhost:8080 and use the super application.
