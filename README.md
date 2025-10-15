# HostApp

This project was generated with [Angular CLI](https://github.com/angular/angular-cli) version 14.2.13.

## Development server

Run `ng serve` for a dev server. Navigate to `http://localhost:4200/`. The application will automatically reload if you change any of the source files.

## Code scaffolding

Run `ng generate component component-name` to generate a new component. You can also use `ng generate directive|pipe|service|class|guard|interface|enum|module`.

## Build

Run `ng build` to build the project. The build artifacts will be stored in the `dist/` directory.

## Angular App Creation: 
npx -p @angular/cli@17 ng new host-app --no-standalone --routing --style=scss

## Ng Serve:
ng serve --host 0.0.0.0 --port 4200

## install (Angular element):
npm install @angular/elements@17 @webcomponents/custom-elements

@angular/elements@17 → the version aligned with Angular 17.

@webcomponents/custom-elements → polyfill for browsers that don’t natively support Custom Elements (safe to add).

## Zone update:
npm uninstall zone.js
npm install zone.js@0.13

## Polyfill config:
build": {
          "builder": "@angular-devkit/build-angular:browser",
          "options": {
            "outputHashing": "none",
            "outputPath": "dist/user-management-mfe",
            "namedChunks": false,
            "vendorChunk": false,
            "index": "src/index.html",
            "main": "src/main.ts",
            "polyfills": [
              "zone.js"
            ],

## Package.json MFE
{
  "name": "test-management-mfe",
  "version": "0.0.0",
  "scripts": {
    "ng": "ng",
    "start": "ng serve",
    "build": "ng build",
    "watch": "ng build --watch --configuration development",
    "test": "ng test"
  },
  "prettier": {
    "overrides": [
      {
        "files": "*.html",
        "options": {
          "parser": "angular"
        }
      }
    ]
  },
  "private": true,
  "dependencies": {
    "@angular/common": "^20.0.0",
    "@angular/compiler": "^20.0.0",
    "@angular/core": "^20.0.0",
    "@angular/elements": "^20.3.4",
    "@angular/forms": "^20.0.0",
    "@angular/platform-browser": "^20.0.0",
    "@angular/router": "^20.0.0",
    "rxjs": "~7.8.0",
    "tslib": "^2.3.0",
    "zone.js": "~0.15.0"
  },
  "devDependencies": {
    "@angular-devkit/build-angular": "^20.3.5",
    "@angular/build": "^20.0.4",
    "@angular/cli": "^20.0.4",
    "@angular/compiler-cli": "^20.0.0",
    "@types/jasmine": "~5.1.0",
    "jasmine-core": "~5.7.0",
    "karma": "~6.4.0",
    "karma-chrome-launcher": "~3.2.0",
    "karma-coverage": "~2.2.0",
    "karma-jasmine": "~5.1.0",
    "karma-jasmine-html-reporter": "~2.1.0",
    "typescript": "~5.8.2"
  }
}


## ng Build:
ng build --configuration production --output-hashing=none

## MFE Bundle concade:
cat runtime.js polyfills.js main.js > ./../../elements/user-management-mfe.js

## Prod Deployment:
Step1: npm run deploy:gh 

Step2: update in index.html