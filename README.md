![ubuntu-nginx-lucee](https://repository-images.githubusercontent.com/306185324/34c9fa00-1460-11eb-80e1-87472c3561ac)
  
  
ubuntu-nginx-lucee
==================

A set of bash scripts for standing up a Lucee server using nginx and Tomcat on Ubuntu.  
Uses the Tomcat from the Ubuntu distribution so you can update Tomcat using `apt-get update tomcat8`

Why would I use this instead of the offical Lucee installers?
-------------------------------------------------------------

* You want an easy and consistent method to install and configure these services
* You want to run nginx as your web server
* You want to update Tomcat via `apt-get`

What does it do?
----------------

1. **Updates Ubuntu** - simply runs `apt-get update` and `apt-get upgrade`
2. **Downloads Lucee** - uses curl to download lucee jars from BitBucket. Places the jars in `/opt/lucee/current/`
3. **Installs & Configures Tomcat 8** - runs `apt-get install tomcat8` updates the `web.xml` `server.xml` and `catalina.properties` to configure Lucee servlets and mod_cfml Valve.  (Tomcat/Lucee run on port 8080 by default).
4. **Installs Specific JVM** - if you downloaded a JRE and specified its version and name in the config (see **Environment Variables**), it will extract it under `/opt/lucee/jvm/$JVM_VERSION` and then create a symbolic link `/opt/lucee/jvm/current` to denote the current jvm version to use. It also edits tomcat config to point to this jvm. The default is to use OpenJDK when JVM_FILE or JVM_VERSION are not specified.
5. **Installs & Configures nginx** - runs `apt-get install nginx` to install nginx. Creates a web root directory. Creates a `lucee.config` file so you can just `include lucee.config` for any site that uses CFML
6. **Set Default Lucee Admin Password** - uses cfconfig to set the Lucee server context password and default web context password. If ADMIN_PASSWORD exists that is used, otherwise a random password is set.

Take a look in the `scripts/` subfolder to see the script for each step.


Limitations / Known Issues
--------------------------

* The servlet definitions and mappings (located in `/etc/tomcat8/web.xml`) are slimmed down, so if you need things like REST web services, see the [Configuration: Lucee web.xml](https://docs.lucee.org/guides/Various/configuration-web-xml.html#webxml)
* The `/lucee/` uri is blocked in `/etc/nginx/lucee.conf`. You must add in your ip address and restart nginx. This can be done during install by setting `WHITELIST_IP`. See **Environment Variables**.
* There is no uninstall option
* This version of the script has been tested on **Ubuntu 18.04.5 LTS**.


How do I run it?
----------------

1. **Downlaod this repository** - `curl -Lo /root/ubuntu-nginx-lucee.tar.gz https://api.github.com/repos/rawdyn/ubuntu-nginx-lucee/tarball/master`
2. **Extract repository** - `tar -xzvf /root/ubuntu-nginx-lucee.tar.gz`
3. **Optional: Download Specific JVM** - Historically, the Oracle JVM is used to run CFML applications. The current default is to use the open source OpenJDK (which the Oracle JVM is based on). The advantage of using OpenJDK is that you can also keep it up to date using `apt-get`. The advantage of the Oracle JVM is that it includes a few Java classes that might be used for image processing (eg the com.sun classes). If you download a JVM from Oracle make sure the JVM you downloaded is located in the folder that contains install.sh, eg `/root/rawdyn-ubuntu-nginx-lucee-abcdefg/`. If you skip this step, OpenJDK is used instead.
4. **Configuration** - the recommended method is to use **Environment Variables** (see below) but you _can_ Edit the `pre-install-check.sh` and change any configuration options if you wish.
5. **Run install.sh** - make sure you are root or sudo and run `./install.sh` you may need to `chmod u+x install.sh` to give execute permissions to the script.

    :white_check_mark: Running **./install** will display a summary of **Environment Variables** set and a confirm prompt to proceed or exit.

Environment Variables
--------------------------

The script can be configured with the following environment variables:

Variable | Description
-|-
`LUCEE_VERSION`<br />default<br />`5.3.6.61` | Sets the version of Lucee that it will attempt to install.
`JVM_MAX_HEAP_SIZE`<br />default<br />`512m` | Sets the amount of memory that java/tomcat can use.
`ADMIN_PASSWORD` | Sets the Lucee server context password and default web context password. If not defined, a random password is generated and set.
`JVM_FILE`<br />example<br />`OpenJDK11_jre_x64_linux_hotspot_11.0.6_10.tar.gz` | Name of a JRE file. If not found, OpenJDK will be installed instead.
`JVM_VERSION`<br />example<br />`11.0.6_10` | The version string corresponding to the JVM_FILE. Used to name install directory.
`WHITELIST_IP`<br />example<br />`199.241.3.18` | If specified, this IP will be whitelisted to allow access to /lucee/
`LUCEE_JAR_SHA256` | If specified, checks the sha256sum of the the downloaded lucee.jar

Example Installation
--------------------
SSH into Ubuntu...  
```Shell
#Switch to root account
sudo -i

#Download this package
curl -Lo /root/ubuntu-nginx-lucee.tar.gz https://api.github.com/repos/rawdyn/ubuntu-nginx-lucee/tarball/master

#Extract the package.
tar -xzvf /root/ubuntu-nginx-lucee.tar.gz

#Relocate into the extracted package (note: randomised string suffix will vary).
cd /root/rawdyn-ubuntu-nginx-lucee-abcdefg

#Grant permissions to run the install file.
chmod u+x install.sh
	
#Set any options desired and call the install script.  
ADMIN_PASSWORD=qwe783L1cH WHITELIST_IP=192.168.3.45 ./install.sh
```  

Check the options are set as you desire and continue, otherwise exit.  
![Install Confirm Prompt](https://github.com/rawdyn/ubuntu-nginx-lucee/blob/media/ubuntu-nginx-lucee-install-confirm-input-V02.PNG)  

The example belows shows warnings for a requested custom JVM that could not be found.  
![Install Alert Confirm Prompt](https://github.com/rawdyn/ubuntu-nginx-lucee/blob/media/ubuntu-nginx-lucee-install-confirm-input-with-alert-V01.PNG)  




Setting up a Virtual Host
-------------------------

By default nginx on Ubuntu looks in the folder `/etc/nginx/sites-enabled/` for configuration nginx files. To setup a site create a file in that folder (another technique you can use is to create the file in `/etc/nginx/sites-available/` and then create a symbolic link in sites-enabled to enable the site), for example `/etc/nginx/sites-enabled/me.example.com.conf` at a minimum it will look like this:

	server {
		listen 80;
		server_name me.example.com;
		root /web/me.example.com/wwwroot/;
		include lucee.conf;
	}

You may also want to break logging for this site out into its own file, like this:

	server {
		listen 80;
		server_name me.example.com;
		root /web/me.example.com/wwwroot/;
		access_log /var/log/nginx/me.example.com.access.log;
		error_log /var/log/nginx/me.example.com.error.log;
		include lucee.conf;
	}

If you don't need Lucee/CFML for a given site, simply omit the `include lucee.conf;` line, like this:

	server {
		listen 80;
		server_name img.example.com;
		root /web/img.example.com/wwwroot/;
	}

Create the symbolic link in sites-enabled to enable the site:

	sudo ln -s /etc/nginx/sites-available/me.example.com.conf /etc/nginx/sites-enabled/

After making changes you need to restart or reload nginx:

	sudo service nginx restart

For more information on configuring nginx see the [nginx Wiki](http://wiki.nginx.org/Configuration)
  

Resources
---------

- [Open JDK JVM archives](https://adoptopenjdk.net/archive.html)
- [Adobe downloads including JVMs](https://www.adobe.com/support/coldfusion/downloads.html)



Thanks go to [Foundeo](https://foundeo.com/) for the [origin of this fork](https://github.com/foundeo/ubuntu-nginx-lucee).  
Thanks go to [Booking Boss](http://www.bookingboss.com/) for funding the initial work by Foundeo.  
