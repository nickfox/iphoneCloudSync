### iPhoneCloudSync

This application allows an iPhone app to sync with a couchDB database in the cloud and also a dropbox repository. The iPhone application is a very simple catalog with product descriptions and images. There are 3 parts to this application: 

1. the couchDB application that is used to update the product on the iPhone
2. and the dropbox repository that is used to store the images used on the iPhone
3. the iphone application

First I'll explain how to create the couchDB application. The couchDB does not need to be installed on the local machine. Instead, we'll create a couchDB using [Cloudant](http://www.cloudant.com). The first thing you need to do is install couchApp on your local machine. We'll assume that you are using a mac for everything. Follow the [tutorial here](http://benoitc.github.com/couchapp/download.html) to install couchApp. Also read this [short tutorial](http://benoitc.github.com/couchapp/getting_started.html) explaining what a couchApp is. Once you have couchApp installed, go to [Cloudant](http://www.cloudant.com) and create a new account. Next download this repo and cd to the iphonecouchsync directory and then run the following command from the command line:

    couchapp push http://username:password@username.cloudant.com/iphonecouchsync

where username and password are from the cloudant account you just created. Once you have done this, you will be given an url that will allow you to view and add product:

    http://username.cloudant.com/iphonecouchsync/_design/iphonecouchsync/index.html

Add three new products using coke.png, oranges.png and bananas.png for images. Ok, we are now done with couchdb for now. Go and create a dropbox account if you have not done so already and then create a folder called syncfolder. Create a new dropbox app at [Dropbox Developers](https://www.dropbox.com/developers/apps) and get the consumer key and secret. Select iPhone for type of app. We are done with dropbox portion for now.

Lastly, we need to set up the iPhone app with the dropbox and couchdb info. In the iPhoneSyncAppDelegate.m file, replace the DROPBOX_CONSUMER_KEY and DROPBOX_CONSUMER_SECRET on lines 21 and 22 with the ones you just got from dropbox. Also replace the DROPBOX_EMAIL and DROPBOX_PASSWORD with those from dropbox. Dropbox does not recommend that you hardcode the email and password into the app. They would prefer that you ask the user to give you the email and password (once) to get your oAuth token. Here is the code to do that [from the DBRoulette Dropbox example in the SDK](https://www.dropbox.com/developers/releases):

    - (void)sessionDidReceiveAuthorizationFailure:(DBSession*)session {
	    DBLoginController* loginController = [[DBLoginController new] autorelease];
	    [loginController presentFromController:navigationController];
    }

In the SyncController.m file, replace the COUCHDB_USERNAME and COUCHDB_PASSWORD on lines 29 and 30. The app is now set up and ready for testing. Run the app and you should see bananas, coke and oranges displayed in the table view. Now to test the sync operation. Go to dropbox and upload the raspberries.png file into the syncfolder. Then go to couchdb and create a new product called Raspberries and make sure to name the image file raspberry.png. Now close the iphone app and reopen it and you should see the raspberry product appear in the tableview. If you run into problems, uncomment the lines 25 - 27 in the SyncController.m class: 

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:@"" forKey:@"dropboxHash"];
    [prefs setObject:@"" forKey:@"lastSequenceFromCouchDB"];

Run the app again. This will clear out any stale values that might be left in the user defaults. Re-comment the lines and run the app yet again to see the syncing operation. The sync operation is initiated in this iphoneSyncAppDelegate callback:

    - (void)applicationDidBecomeActive:(UIApplication *)application 

That's it for this app. I'll be creating a tutorial soon explaining how the app works. In the future, I will try to build another app that stores images directly in the couchDB, that would be a cleaner and a less error prone way of building the app but foe now this does show how to do syncing on two different platforms for different data types.

