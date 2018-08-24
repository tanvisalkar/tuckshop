# ELM JS Project for Tuckshop

## Setup

From your top-level directory - the one with `
-package.json` in - call:

```
$ elm package install
```

NPM packages needed:
1.  Http server
```
npm install http-server -g
```
2.  Json server
```
npm install json-server
```
3.  Elm live
```
npm install elm-live -g
```

To start json server 
```
json-server --watch server/db.json -p 5019
```

To run Tuckshop app (ProductApp) run below commands in separate terminals from root directory
```
  1.  start node server
      cd server
      node server.js
  2.  start elm project
      elm-live ProductApp/App.elm --pushstate --output=ProductApp/elm.js
```
