/**
 * https://github.com/gkushang/cucumber-html-reporter
 */

var reporter = require('cucumber-html-reporter');

var options = {
  theme: 'bootstrap',
  jsonDir: 'results',
  output: 'cucumber_report/cucumber_report.html',
  reportSuiteAsScenarios: true,
  launchReport: false,
  columnLayout: 1,
  scenarioTimestamp: true,
  screenshotsDirectory: './cucumber_report/screenshots/',
  storeScreenshots: true,
  noInlineScreenshots: true,
  ignoreBadJsonFile: true,
  name: 'My Test Report',
  brandTitle: ' ',
  metadata: {
    "App Version":"0.1",
    "Test Environment": "GitHub CI"
  }
};

reporter.generate(options);
