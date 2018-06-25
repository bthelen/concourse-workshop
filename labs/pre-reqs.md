Install FLY CLI
===============

1.  In a browser navigate to <http://concourse.run.cloud.zwickey.net/>
    and select the icon associated with your platform:

    ![](fly.png)

2.  Add the downloaded binary to your system path

3.  After adding to your system path you should be able to execute the
    fly command from a terminal window:

        $ fly -version                                                                                                                                  1 ↵
        2.6.0

Target and Login to Concourse Env
=================================

1.  Execute the fly target command to connect to the Concourse
    environment. When prompted to a username and password enter the
    credentials provided to you by your instructor.

        $ fly --target gcp login --concourse-url http://concourse.cloud.zwickey.net:8080 --team-name Main

2.  Execute the fly login command, entering the credentials again when
    prompted.

        $ fly -t gcp login                                                                                                                              1 ↵
        username: admin
        password:

        target saved

Create a GIT repository to hold your concourse pipeline and artifacts
=====================================================================

1.  Fork this git repository:
    <https://github.com/azwickey-pivotal/concourse-workshop>

2.  Clone this repository to your local desktop

        $ git clone <YOUR-GIT-URL>

3.  In your terminal window change directories to the root of your
    cloned git repo. We’ll use this location as a base for most our
    commands in the workshop
