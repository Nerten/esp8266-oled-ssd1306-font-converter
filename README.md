openshift-diy-nodejs08
========================

Thanks for the great work by [razorinc](https://github.com/razorinc/redis-openshift-example) and [creationix](https://github.com/creationix/nvm/), this repo let you test node.js v0.8 with OpenShift DIY application type. It will first check for pre-compiled linux version, then compile from source if not found.

[node-supervisor](https://github.com/isaacs/node-supervisor) is used to automatically restart the node.js app if somehow crashed.

Usage
-----

Create an DIY app

    rhc app create -a yourapp -t diy-0.1

Add this repository

    cd yourapp
    git remote add nodejs08 -m master git://github.com/eddie168/openshift-diy-nodejs08.git
    git pull -s recursive -X theirs nodejs08 master

Then push the repo to openshift

    git push

First time push will take quite a while to finish if pre-compiled binary is not available.

The `.openshift/action_hooks/start` script will first try to find `app.js` to start with node. If not found, `server.js` will be used.

Check the end of the message for node version and started node script:

    remote: Starting application...
    remote: v0.8.8
    remote: nohup supervisor app.js >/var/lib/stickshift/xxxxxxxxxxxxxxxxxxxxxxxxxxxxx/yourapp/logs//server.log 2>&1 &
    remote: Done

In this case it is node `v0.8.8` with `app.js`.

Now open your openshift app in browser and you should see the standard openshift sample page. Enjoy!!

Upgrade/Downgrade
-----------------

Edit `.openshift/action_hooks/pre_build`

    NODE_VERSION=v0.8.8

to change the `v0.8` minor version, `commit` and then `push` to change the node.js version on OpenShift.

**The script won't delete previously installed `node` binary**, which stored under `${OPENSHIFT_DATA_DIR}/node-$NODE_VERSION`. You will need to SSH in to delete the unwanted versions (to save disk quota for example).

**Note that `v0.6.x` won't work with this method.**


