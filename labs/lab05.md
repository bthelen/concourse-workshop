SSH into a Concourse task to debug on server
============================================

1.  Builds don’t always run smoothly. At times a developer or operator
    will need to debug a failing build. Concourse provides the ability
    to SSH into a pipeline task in order to allow for troubleshooting
    and debugging. You may do this using the *hijack* CLI command. The
    format is *hijack &lt;PIPELINE-NAME&gt;/&lt;JOB\_NAME&gt;*

2.  SSH into one of your build tasks. Replace &lt;LASTNAME&gt; with the
    name you used when naming your pipeline. If you are presented with
    multiple tasks to log into choose the most recent build.

        $ fly -t gcp hijack -j pipeline-<LASTNAME>/deploy

        1: build #5, step: mvn-package, type: task
        2: build #6, step: mvn-package, type: check
        3: build #6, step: mvn-package, type: task
        choose a container: 3

3.  Once you are connected to the container you can navigate the file
    system and execute commands. Execute a *mvn clean package* on the
    code that is cloned from git:

        root@bd618476-54f3-4b7b-7403-8002b34d07c5:/tmp/build/f5866da1# ls -l
        total 0
        drwxr-xr-x 1 root root  36 Feb 17 14:09 app-output
        drwxr-xr-x 1 root root 166 Feb 17 14:10 git-assets

        root@bd618476-54f3-4b7b-7403-8002b34d07c5:/tmp/build/f5866da1# cd git-assets/

        root@bd618476-54f3-4b7b-7403-8002b34d07c5:/tmp/build/f5866da1/git-assets# ls -l
        total 12
        -rw-r--r-- 1 root root  754 Feb 16 21:02 README.adoc
        drwxr-xr-x 1 root root   34 Feb 16 21:02 ci
        drwxr-xr-x 1 root root   78 Feb 16 21:02 completed-ci
        drwxr-xr-x 1 root root  264 Feb 16 21:02 labs
        -rw-r--r-- 1 root root  112 Feb 16 21:02 manifest.yml
        -rw-r--r-- 1 root root 1434 Feb 16 21:02 pom.xml
        drwxr-xr-x 1 root root   28 Feb 16 21:02 presentation
        drwxr-xr-x 1 root root   16 Feb 16 21:02 src
        drwxr-xr-x 1 root root  350 Feb 17 14:09 target

        root@bd618476-54f3-4b7b-7403-8002b34d07c5:/tmp/build/f5866da1/git-assets# mvn clean package
        [INFO] Scanning for projects...
        [INFO]
        [INFO] ------------------------------------------------------------------------
        [INFO] Building concourse-demo 0.0.9-SNAPSHOT
        [INFO] ------------------------------------------------------------------------
        ....
