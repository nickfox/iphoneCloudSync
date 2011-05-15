### iPhoneCloudSync

This application allows an iPhone app to sync with a couchDB database in the cloud and also a dropbox repository. The iPhone application is a very simple catalog with product descriptions and images. There are 3 parts to this application: 

1. the iphone application
2. the couchDB application that is used to update the product on the iPhone
3. and the dropbox repository that is used to store the images used on the iPhone

First will explain how to create the couchDB application. The couchDB does not need to be installed on the local machine. Instead, we'll create a couchDB using [Cloudant](http://www.cloudant.com). The first thing you need to do is install couchApp on your local machine. We'll assume that you are using a mac for everything. Follow the [tutorial here](http://benoitc.github.com/couchapp/download.html) to install couchApp. Also read this [short tutorial](http://benoitc.github.com/couchapp/getting_started.html) explaining what a couchApp is. Once you have couchApp installed, go to [Cloudant](http://www.cloudant.com) and create a new account. Next download this repo and cd to the iphonecouchsync directory and the run the following command from the command line:

    couchapp push http://username:password@username.cloudant.com/iphonecouchsync

where username and password are from the cloudant account you just created. Once you have done this, you will be given a url that will allow you to view and add product. 
