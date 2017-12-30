# MongoDB 3.0.14 for Raspberry Pi 3 (ARMv7l) - Docker 17.11.0-ce+

This docker image uses pre-compiled 32bit ARM binaries from Andy Felong and the latest Raspbian Stretch build from Resin (https://hub.docker.com/r/resin/rpi-raspbian/)

*Where to find this:*

Github: https://github.com/andresvidal/rpi3-mongodb3

Docker Hub: https://hub.docker.com/r/andresvidal/rpi3-mongodb3/

## MongoDB (32bit) Binary Notes

Binaries are built and maintained here: http://andyfelong.com/2017/08/mongodb-3-0-14-for-raspbian-stretch/

From the Andy Felong:

```
The latest version as of August 2017 is “Raspbian Stretch” — based upon the current stable version of Debian 9.  The previous version was known as “Raspbian Jessie”.  One difference between versions is OpenSSL libraries. OpenSSL is a general purpose cryptography library that provides an open source implementation of the Secure Sockets Layer (SSL).  My previous builds of MongoDB relied on the older library.  As a result, my previous binaries for 3.0.14 and 3.0.9 do not run under Raspbian Stretch.  Given this change as well as other changes to MongoDB source and newer compilers, I could no longer compile MongoDB 3.0.14 with SSL.

After a few source tweaks and use of various compiler flags, I have manged to compile MongoDB core apps and tools.  These binaries do NOT support SSL and only run under Raspian Stretch on a Raspberry Pi 3:
```

# Usage

**Prerequisites**

1. [Docker 17.11.0-ce+](https://www.google.com/search?q=installing+the+latest+docker+on+raspberry+pi+3)

## Build

```
docker build -t andresvidal/rpi3-mongodb3 .
```

## Run

###Starting MongoDB with Auth enabled. 

**First Read [How to setup auth in MongoDB 3.0 Properly](https://medium.com/@matteocontrini/how-to-setup-auth-in-mongodb-3-0-properly-86b60aeef7e8)**

```bash
$ docker run -d \
--name rpi3-mongodb3 \
--restart unless-stopped \
-v /data/db:/data/db \
-v /data/configdb:/data/configdb \
-p 27017:27017 \
-p 28017:28017 \
andresvidal/rpi3-mongodb3:latest \
mongod --auth
```

Add the initial Admin User

```
$ docker exec -it rpi3-mongodb3 mongo admin

connecting to: admin
```

Replace `[username]` and `[password]`

```
> db.createUser({ user: "[username]", pwd: "[password]", roles: [ { role: "userAdminAnyDatabase", db: "admin" } ] })
```

Check the user has been created successfully

```
> db.auth("admin", "adminpassword")
```

Restart Container to ensure policies have applied.

```
$ docker restart rpi3-mongodb3
```

Creating a Database and add a User with permissions

```
$ docker exec -it rpi3-mongodb3 mongo admin
> db.auth("admin", "adminpassword")

> use yourdatabase
> db.createUser({ user: "youruser", pwd: "yourpassword", roles: [{ role: "dbOwner", db: "yourdatabase" }] })

> db.auth("youruser", "yourpassword")
> show collections
```

Read more on how to [Grant User Roles](https://docs.mongodb.com/manual/reference/method/db.grantRolesToUser/#db.grantRolesToUser)

*FYI:* The connection string to MongoDB for your application will look like this:

```
mongodb://youruser:yourpassword@localhost/yourdatabase
```

###Starting MongoDB with REST enabled.

```
docker run -d \
--name rpi3-mongodb3 \
--restart unless-stopped \
-v /data/db:/data/db \
-v /data/configdb:/data/configdb \
-p 27017:27017 \
-p 28017:28017 \
andresvidal/rpi3-mongodb3:latest \
mongod --rest
```