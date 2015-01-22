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

Run gulp watcher:
```sh
$ gulp dev
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
gulp prod
git remote add heroku_gymcloud-webapp-production git@heroku.com:gymcloud-webapp-production.git
cp ./static/index.html ./
git add -f index.html
git add -f static
git commit -m '[deploy]'
git push --force heroku_gymcloud-webapp-production HEAD:master
```
