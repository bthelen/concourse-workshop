Modularize Tasks and Link Multiple Jobs
=======================================

1.  It is very common within an application’s git repository to place
    all concourse artifacts in a *ci* folder. Within that folder
    individual tasks are modularized in their own yml files and refer to
    shell scripts for actual task execution. E.G.

        App Git Repo Root:
        ├── App source code....
        │   ├── Some code artifacts...
        ├── ci
        │   ├── pipeline.yml
        │   ├── credentials.yml
        │   ├── tasks
        │   │   ├── modular-task.yml
        │   │   ├── modular-task.sh

    We will mimic that structure as we build out our pipeline

2.  Create the *ci* and *ci/tasks* directory structure:

        $ mkdir -p ci/tasks

3.  Move the pipeline.yml file into your new *ci* directory

        $ mv pipeline.yml ci/pipeline.yml

4.  We will now create modularized tasks for the steps to build our
    application. First create the yml task file *mvn-test.yml*. Create
    the file in the *ci/tasks* directory:

        ---
        platform: linux

        image_resource:
          type: docker-image
          source:
            repository: openjdk

        inputs:
        - name: git-assets

        run:
          path: git-assets/ci/tasks/test.sh

5.  You’ll note that this task references to script *test.sh* for the
    actual execution logic. Create that file:

        #!/bin/bash

        set -xe

        cd git-assets
        mvn test

6.  Create similar artifacts for the packaging stage of your application
    build:

    *ci/tasks/mvn-package.yml*

        ---
        platform: linux

        image_resource:
          type: docker-image
          source:
            repository: openjdk

        inputs:
        - name: git-assets

        outputs:
        - name: app-output

        run:
          path: git-assets/ci/tasks/package.sh

    *ci/tasks/package.sh*

        #!/bin/bash

        set -xe

        cd git-assets
        mvn package
        cp target/concourse-demo-*.jar ../app-output/concourse-demo.jar

7.  We need to make sure our bash scripts are executable. Execute the
    following command:

        $ chmod +x ci/tasks/*.sh

8.  Modify your main *pipleine.yml*, which now resides in the the ci
    directory, to include the 2 new tasks. These tasks will represent
    completely new jobs in your pipeline. These will test and package
    the java code included in your repository. You will be replacing
    your "howdy" job. Your final pipeline.yml file should look like
    this:

        resources:
        - name: git-assets
          type: git
          source:
            branch: master
            uri: https://github.com/azwickey-pivotal/concourse-workshop

        jobs:
        - name: unit-test
          public: true
          plan:
          - get: git-assets
            trigger: true
          - task: mvn-test
            file: git-assets/ci/tasks/mvn-test.yml
        - name: deploy
          public: true
          plan:
          - get: git-assets
            trigger: true
            passed:
              - unit-test
          - task: mvn-package
            file: git-assets/ci/tasks/mvn-package.yml

9.  Update your concourse pipeline with the set-pipeline command.
    Remember, your pipeline.yml file is now in a different location:

        $ fly -t gcp set-pipeline -p pipeline-<LASTNAME> -c ci/pipeline.yml

10. You’ll note your pipeline now steps (or jobs). 1) Unit test your
    code and 2) Package/Deploy your code. Step \#2 will only kickoff if
    Step \#1 is successful

11. Our last step is to check all our new pipeline code into git. This
    should be everything in the ci folder. Once we commit our build is
    automatically triggered:

        $ git add ci/pipeline.yml ci/tasks

        $ git commit -m "added concourse task assets"
        [master 623fdb6] added concourse task assets
         3 files changed, 138 insertions(+), 2 deletions(-)
         create mode 100644 ci/pipeline.yml

        $ git push
        ......
        Counting objects: 7, done.
        Delta compression using up to 8 threads.
        Compressing objects: 100% (6/6), done.
        Writing objects: 100% (7/7), 2.04 KiB | 0 bytes/s, done.
        Total 7 (delta 1), reused 0 (delta 0)
        remote: Resolving deltas: 100% (1/1), completed with 1 local objects.
        To git@github.com:azwickey-pivotal/concourse-workshop.git
           b952fc5..623fdb6  master -> master

    ![](lab04.png)
