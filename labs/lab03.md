Introduce Git Resource
======================

1.  Modify the file pipeline.yml that you previously created. Add the
    following text, which refers to a Git repository you created in the
    pre-reqs section, to the top of your file:

        resources:
        - name: git-assets
          type: git
          source:
            branch: master
            uri: https://github.com/azwickey-pivotal/concourse-workshop

2.  Modify the previous "hello" job in the jobs section of the file to
    add a new task to the pipeline that will GET the git repository:

        jobs:
        - name: hello
          plan:
          - get: git-assets   # Lines to add
            trigger: true     # Lines to add
          - task: howdy
            config:
              platform: linux
              image_resource:
                type: docker-image
                source: {repository: ubuntu}
              run:
                path: echo
                args: ["Hello, My first pipeline!"]

3.  Your full pipeline file should look like this:

        resources:
        - name: git-assets
          type: git
          source:
            branch: master
            uri: https://github.com/azwickey-pivotal/concourse-workshop

        jobs:
        - name: hello
          plan:
          - get: git-assets
            trigger: true
          - task: howdy
            config:
              platform: linux
              image_resource:
                type: docker-image
                source: {repository: ubuntu}
              run:
                path: echo
                args: ["Hello, My first pipeline!"]

4.  Update your pipeline in on the concourse server with the
    set-pipeline command. As before, in the command below replace
    &lt;LASTNAME&gt; with your lastname.

        $ fly -t gcp set-pipeline -p pipeline-<LASTNAME> -c pipeline.yml

5.  You’ll note that when you update a pipeline the fly CLI response
    will highlight what has changed in the pipeline.

6.  Return back to the Concourse Web UI. You’ll note your pipeline has
    now changed to include the git-assets resource, which is an input to
    your pipeline:

    ![](resource.png)

7.  Your pipeline will now trigger automatically anytime the git
    repository changes. This is because we marked the *get* task in the
    pipeline to be triggered. By clicking on the hello job you should
    now see the output of both a git clone and execution of the task
    that outputs a simple message to STDOUT:

    ![](lab03-execute.png)
