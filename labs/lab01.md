World’s simplest Concourse Task
===============================

1.  Using a text editor (of choice), create the file pipeline.yml:

        platform: linux
        image_resource:
          type: docker-image
          source: {repository: ubuntu}
        run:
          path: echo
          args: ["Hello, My first pipeline!"]

2.  To execute the concourse task on your local workstation execute the
    following fly command. Your environment may pull down a docker image
    after which you will see the task initialize and execute.

        $ fly -t gcp execute -c pipeline.yml
        executing build 79
        initializing
        running echo Hello, My first pipeline!
        Hello, My first pipeline!
        succeeded
