# README
* [Deployed via render.com](https://dashboard.render.com/web/srv-ckrdjag5vl2c73edla60) (in free tier db will be deleted after 90 days)
* [project playlist](https://invidious.baczek.me/playlist?list=PLm8ctt9NhMNXOBboD4FvLdZU_Cner2uk0)


You don't need to run a local server for your tests to run. Tests in Rails are designed to be independent of the local development server. When you run tests using rails test, Rails sets up a separate test environment and executes your tests in that environment.

However, certain types of tests, such as integration tests or system tests, may interact with your application in a way that requires assets to be precompiled. In such cases, running rails assets:precompile for the test environment can be helpful.

If you are encountering asset-related issues in your tests, here are some steps to troubleshoot:

Precompile Assets:
Run the following command to precompile assets for the test environment:

```
RAILS_ENV=test rails assets:precompile
```
Check Asset Paths:
Ensure that the load paths for assets are correctly configured in the test environment. Check your config/application.rb or an environment-specific configuration file.

Review Asset Pipeline Configuration:
Check the configuration in your config/environments/test.rb file. Make sure config.assets.compile is set to true if needed.

Clear Cached Assets:
If you've made changes to asset files or configurations, try clearing the asset cache:

```
rails assets:clobber
```
Then run the precompile command again.

After making these adjustments, try running your tests again. If the issue persists, you may need to investigate further, checking for specific error messages or stack traces that could provide more insight into the problem.
