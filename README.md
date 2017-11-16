# Apartment List Family Friday

This solution to the [coding challenge](https://gist.github.com/sarahwiemero/0aa5ff2d24196c65880936bbe80f6c52) sets up a [phoenix](http://phoenixframework.org) web server and connects to slack slash commands.

## Setup

You need to have docker installed to run this, and probably [ngrok](https://ngrok.com) if you want to test it in slack.

To get this up and running, follow these commands:

```
$ docker-compose build
```

```
$ docker-compose up
```

This will run a postgres instance and a phoenix server on port 4000.

## Usage

The phoenix server listens for a few post commands:

```
/api/slack-users/create
/api/slack-users/list
/api/slack-users/delete
/api/slack-users/groups
```

You can test by curling your local host:

Add a user.
```
curl -d '{ "text": "email@email.com name here" }' -H "Content-type: application/json" http://localhost:4000/api/slack-users/create
```

Get all users.
```
curl -d '' -H "Content-type: application/json" http://localhost:4000/api/slack-users/list
```

Note that the output is formatted for slack, so it may not look that great in your console window.

## Adding to Slack

Fire up ngrok, or some other tunneling service to have a public facing url for your local server.

Next, add four slack slash commands to your chosen slack application.

```
/ff-add
/ff-list
/ff-remove
/ff-group
```

Connect these to the appropriate endpoints through your ngrok tunnel, and presto.

One example, for the `/ff-add` command, you would set the request url to be `https://yourtunnelurl.com/api/slack-users/create`, with a friendly description and `[email] [name]` as the Usage Hint.

## Running Tests

```
$ docker-compose exec web mix test --color
```
