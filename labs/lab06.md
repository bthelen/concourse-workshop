Push app to CF
==============

1.  Lastly, we want to deploy our application to Pivotal Cloudfoundry.
    We’ll add this to the *deploy* task within our pipeline. First,
    define a Cloudfoundry resource below the git-assets resource:

        - name: cloudfoundry
          type: cf
          source:
            api: {{cf-api}}
            skip_cert_check: true
            organization: {{cf-organization}}
            username: {{cf-username}}
            password: {{cf-password}}
            space: {{cf-space}}

2.  $ cp completed-ci/credentials.yml.sample ci/credentials.yml

3.  Edit the newly created credentials.yml file to populate it with your
    specific Cloudfoundry environment information.

4.  Lastly, we need to add the cf deploy step to our build plan. Add the
    following task to the end of your deploy job, right after the
    mvn-package step.

        - put: cloudfoundry
          params:
            manifest: git-assets/manifest.yml
            path: app-output/concourse-demo.jar

5.  Your full pipeline yml should look like this:

        resources:
        - name: git-assets
          type: git
          source:
            branch: master
            uri: https://github.com/azwickey-pivotal/concourse-workshop
        - name: cloudfoundry
          type: cf
          source:
            api: {{cf-api}}
            skip_cert_check: true
            organization: {{cf-organization}}
            username: {{cf-username}}
            password: {{cf-password}}
            space: {{cf-space}}

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
          - put: cloudfoundry
            params:
              manifest: git-assets/manifest.yml
              path: app-output/concourse-demo.jar

6.  Update your concourse pipeline using the fly set-pipeline command.
    This time we’ll use the *-l* flag to provide a variables file:

        $ fly -t gcp set-pipeline -p pipeline-<LASTNAME> -c ci/pipeline.yml -l ci/credentials.yml

7.  If you refresh the Concourse web UI you’ll note the resource output
    of *cloudfoundry* has been added.

    ![](cf.png)

8.  Since we didn’t modify anything in git our build will not be
    triggered. Manually select a task and kick it off. The end result
    should be a push of your application to cloudfoundry.

    ![](cf1.png)

9.  You can verify your application is working by hitting the version
    /endpoint in your applicaion. E.G.:

        $ curl http://concourse-demo-boot.apps.cloud.zwickey.net/version
        0.0.9-SNAPSHOT
