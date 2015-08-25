### Installation

You need installed globally:

```sh
$ npm i -g bower
```

You need installed locally:
```sh
$ bower install
$ npm install
```

### Development

Copy sample config and change api url if it needed:
```sh
$ cp .env.sample .env
$ cp config/base.sample.coffee config/base.coffee
```

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
## Deployment

### prepare before deployment

```sh
git checkout master
git pull
git branch -D production
git checkout -b production
```

### option 1: via codeship

```sh
touch .deploy
git add .deploy
git commit -m "[deploy]"
git push --force origin production
```

### option 2: directly to heroku

```sh
gulp build
git remote add heroku_gymcloud-webapp-production git@heroku.com:gymcloud-webapp-production.git
git add -f build
git commit -m '[deploy]'
git push --force heroku_gymcloud-webapp-production HEAD:master
```
