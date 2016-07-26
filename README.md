### Installation

You need installed globally:

```sh
$ npm i -g bower gulp karma-cli
```

You need installed locally:
```sh
$ npm install
$ bower install
```

### Development

Copy sample config:
```sh
$ cp .env.sample .env
$ cp config/base.sample.coffee config/base.coffee
```

Change `NODE_ENV` to `development` or `staging` in `.env` file.

Run gulp watcher:
```sh
$ gulp
```

Open url in browser:

```sh
http://localhost:8080/webpack-dev-server/index.html
```

### Testing

Development with running tests:

```sh
$ karma start
```

Running testing suite once:

```sh
$ npm run test
```
or

```sh
$ karma start --single-run
```

Running linter:

```sh
$ gulp lint
```

### Deploy

#### Deploy to codeship

To staging:

```sh
git checkout master
git push origin master
```

To production:

Oneliner:

```sh
git checkout master && git branch -D production; git checkout -b production; git commit --allow-empty -m '[deploy]'; git push -f; git checkout master
```

#### Deploy to dokku

Prepare:

```sh
git remote add dokku-gymcloud-webapp-staging dokku@lite-1.server.gymcloud.com:gymcloud-webapp-staging
git remote add dokku-gymcloud-webapp-production dokku@lite-1.server.gymcloud.com:gymcloud-webapp-production
```

To staging:

Oneliner:

```sh
NODE_ENV=staging; git checkout master; git branch -D build; git checkout -b build; npm run build && git add -f dist && git commit -m '[build]' && git push dokku-gymcloud-webapp-staging HEAD:master -f && git checkout master
```

To production:

Oneliner:

```sh
NODE_ENV=production; git checkout master; git branch -D build; git checkout -b build; npm run build && git add -f dist && git commit -m '[build]' && git push dokku-gymcloud-webapp-production HEAD:master -f && git checkout master
```
