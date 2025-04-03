[![CircleCI](https://circleci.com/gh/vanderbilt-redcap/redcap_cypress/tree/master.svg?style=svg)](https://app.circleci.com/pipelines/circleci/BLgRjd7Ux8A2nSqbTvRf4a/Tmnaphc1X8jXxa2wyDQpqm?branch=master)

# REDCap Cypress Test Suite

*Please ensure you read our [How to Install](#how-to-install) guide if you are just getting started.*

This repository is a template to enable **REDCap Automated Testing** within the [Cypress testing tool](https://www.cypress.io/) against a **REDCap Test Environment**.

Powered by the **REDCap Cypress Test Framework ([RCTF](https://github.com/vanderbilt-redcap/rctf/))**, feature test files, written in Gherkin domain-specific language, may use:

1. **Built-in Gherkin Steps** - documented in the [Gherkin Step Builder](https://vanderbilt-redcap.github.io/redcap_cypress/)
2. **Custom Gherkin Steps** - by creating your own step definitions in the **/support/step_definitions/** folder.

*[RSVC Automated Feature Tests](#rsvc-automated-feature-tests) only use [built-in Gherkin Steps](https://vanderbilt-redcap.github.io/redcap_cypress/), but you may add your own if you [write institution-specific feature tests](#writing-gherkin-feature-tests).*

# Overview
- [How to Install](#how-to-install)
- [!!! WARNING !!!](#-warning-)
- [RSVC Automated Feature Tests](#rsvc-automated-feature-tests)
- [Defining Your Test Environment](#defining-your-test-environment)
- [Database Strategy](#database-strategy)
- [Running Your Tests](#running-your-tests)
- [Writing Gherkin Feature Tests](#writing-gherkin-feature-tests)

# How to Install

[![REDCap Cypress Developer Toolkit](https://raw.githubusercontent.com/vanderbilt-redcap/redcap_cypress_docker/main/tutorial-windows.png)](https://github.com/vanderbilt-redcap/redcap_cypress_docker)


If you are a developer, please start by visiting the [REDCap Cypress Developer Toolkit](https://github.com/vanderbilt-redcap/redcap_cypress_docker), located here:
https://github.com/vanderbilt-redcap/redcap_cypress_docker

The Developer Toolkit is the best way to get Cypress up and running on your developer machine.

**Want to run the automated feature tests in CI / CD pipelines?** 

Take a peek at our [Circle CI YML](https://github.com/vanderbilt-redcap/redcap_cypress/blob/master/.circleci/config.yml) file as an example.

---

# !!!! WARNING !!!! 

<span style="color:red"> **Please do NOT configure `cypress.config.js` or `cypress.env.json` with values from your production environment!** </span> 

<span style="color:red"> **If you configure the `mysql` section of `cypress.env.json` with values from your production database, YOU WILL ERASE YOUR PRODUCTION DATABASE!** </span> 

**Key facts:**

* This framework resets database state to a basic installation of a specific version you specify of REDCap.  Learn more about this in [Database Strategy](#database-strategy)

* We recommend testing your REDCap instance by configuring an environment (close to) identical to production somewhere else.  See [How to Install](#how-to-install) for a Developer Toolkit with a preconfigured Docker container.

---

# RSVC Automated Feature Tests

Validated versions of core Feature Tests for REDCap LTS are posted to a GitHub repository guided by the Regulatory & Software Validation committee: 
https://github.com/vanderbilt-redcap/redcap_rsvc

Check the [Releases Page](https://github.com/vanderbilt-redcap/redcap_rsvc/releases) to see what versions of REDCap are available.

**To Install Feature Tests**

1. Point the **redcap_rsvc** repository in **package.json** at the appropriate tag - ensure tag release tag exists on the [Releases Page](https://github.com/vanderbilt-redcap/redcap_rsvc/releases)! 
```
"redcap_rsvc": "git://github.com/vanderbilt-redcap/redcap_rsvc#v13.1.37-ABC"
```

2. Run the install command:
```
npm run redcap_rsvc:install
```


## Defining Your Test Environment

### Environment Variables

Cypress will understand your environment only if you describe it accurately.

Your description will live inside an environment variable definition file.

**You will need to set the variables appropriately in `cypress.env.json` in order for your test suite to function.**

### cypress.env.json

To get you started, an example file named `cypress.env.json.example` is included within this repository.

Here is an example environment variable setup:

```
{
  "users": {
    "standard": {
      "user": "test_user",
      "pass": "Testing123"
    },
    "admin": {
      "user": "test_admin",
      "pass": "Testing123"
    },
    "Test_Admin": {
      "user": "Test_Admin",
      "pass": "Testing123"
    },
    "Test_User1": {
      "user": "Test_User1",
      "pass": "Testing123"
    },
    "Test_User2": {
      "user": "Test_User2",
      "pass": "Testing123"
    },
    "Test_User3": {
      "user": "Test_User3",
      "pass": "Testing123"
    },
    "Test_User4": {
      "user": "Test_User4",
      "pass": "Testing123"
    }
  },
  "redcap_version": "13.1.37",
  "language": "English",
  "redcap_hooks_path": "/var/www/html/hook_functions.php",
  "redcap_source_path": "../redcap_source",
  "temp_folder": "/var/www/html/temp",
  "mysql": {
    "host": "db",
    "path": "docker exec -i redcap_docker-app-1 mysql",
    "port": "3306",
    "db_name": "redcap",
    "db_user": "root",
    "db_pass": "root"
  },
  "timezone_override": "America/Chicago",
  "bootstrap_settings": {
    "core": true,
    "hooks": false,
    "modules": false,
    "plugins": false,
    "projects" : false
  }
}
```


Below are descriptions of the configuration variables shown above.

---
### redcap_version ###
The version of REDCap that you are testing against.  This is a critical value to set so that Cypress knows the correct URLs to use when testing.  Note that the version of REDCap you specify here MUST be available on your machine in order for tests to work.

---
### mysql ### 
The JSON array that contains several keys, which are critical for your database structure and seeds to be populated correctly before each and every test spec.

---
### mysq['host'] ### 
The hostname or IP address of your MySQL database host.

**DO NOT CONFIGURE YOUR PRODUCTION DATABASE!  The database is reset / deleted before each feature is run.**

For many of us, this will likely be either `localhost`,  `127.0.0.1`, or a reference to a Docker container via `db`.  Keep in mind that there are subtle nuances between `localhost` and `127.0.0.1`.  Thus, you need to choose the option best-suited to your environment.

---
### mysql['path'] ### 
The path to your mysql binary.

For many of us, this will probably be `mysql`, but you could also use a full path like `/usr/local/opt/mysql@5.7/bin/mysql` if necessary.  If you are on a Unix-like environment, you can often determine your full path by entering `which mysql` at the terminal window.  You can also reference a binary within a Docker container like this `docker exec -i redcap_docker-app-1 mysql`

---
### mysql['port'] ### 
The port to your MySQL instance.

This is usually `3306` on standard setups, but for many of us running Docker instances we may wish to use an alternative port so we can differentiate between the standard MySQL instance that is installed on a local operating system and the Docker instance itself.

---
### mysql['db_name'] ### 
The name of your MySQL REDCap database.

This is typically `redcap` but not always.  You'll want to check your `database.php` file on your test instance of your REDCap installation to determine this value.

---
### mysql['db_user'] ### 
The username of your MySQL REDCap database user.

This is typically `root` on local instances of MySQL or local Docker containers.  You'll want to check your `database.php` file on your test instance of your REDCap installation to determine this value.

---
### mysql['db_pass'] ### 
The password of your MySQL REDCap database user.

This is typically `root` on local instances of MySQL or local Docker containers.  You'll want to check your `database.php` file on your test instance of your REDCap installation to determine this value.

---

### Database Strategy
In the aim for deterministic feature tests, the REDCap Cypress Test Framework resets the database to a known state before each feature is run.

Before the test suite is run, the appropriate tables for your specified REDCap version are installed into your MySQL database.  To achieve this, the framework needs to know about where your REDCap source code is located.

You will need the following environment variables configured in your cypress.env.json file:

- `"redcap_source_path": "../path/to/redcap/source/here"`:
  Contains the relative or absolute path to your REDCap source folder root (files from Vanderbilt).  Must contain the version-specific files for the version you wish to tests against.

- `"redcap_version": "13.1.37"`: Contains the string version of REDCap you want to test against.

*The seeds file in this template repository also include a both an **admin user** and a **standard user.***

Which user you use to login to REDCap is dependent upon what kind of feature you are intending to test.

## Running Your Tests

### Opening Cypress

To run the tests in the Cypress debug environment, issue the following command at the root of your test folder:

`npx cypress open`

A Cypress window will open and you can select which specs you'd like to run.

### Headless Mode

After your test suite is mature, it will be faster to run your tests in headless mode.  This is how you would run your tests on a CI server.  To do so, issue the following comand:

`npx cypress run`

---

# Writing Gherkin Feature Tests

We have two suggested methods to learn how to write REDCap-specific feature tests compatible with the REDCap Cypress Test Framework.

1. ### Review Regulatory and Software Validation Committee (RSVC) Feature Tests

[<img src="https://github.com/vanderbilt-redcap/redcap_cypress/blob/master/RSVCFeatureTestExample.png" alt="RSVC Feature Test Example">](https://github.com/vanderbilt-redcap/redcap_rsvc)

RSVC has created hundreds of automated feature tests that test the functional requirements of REDCap.  

Reviewing these feature tests is useful because they serve as a template for testing many aspects of REDCap.

RSVC Feature Tests are availble to review here:
https://github.com/vanderbilt-redcap/redcap_rsvc

2. ### Gherkin Step Builder 

[<img src="https://github.com/vanderbilt-redcap/redcap_cypress/blob/master/GherkinStepBuilder.png" alt="Gherkin Step Builder">](https://vanderbilt-redcap.github.io/redcap_cypress/)

All REDCap feature tests run through this repository are powered by Step Definitions defined in the [RCTF](https://github.com/vanderbilt-redcap/rctf) node package.   

Hundreds of steps are available, and we built a [Gherkin Step Builder](https://vanderbilt-redcap.github.io/redcap_cypress/) tool to help you generate your own syntactically valid Steps in your Feature Tests.

The Gherkin Step Builder is located here:
https://vanderbilt-redcap.github.io/redcap_cypress/
