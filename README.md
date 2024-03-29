# Chartboost iOS Adapter Actions
Repository of GitHub Actions for the Chartboost Mediation iOS Adapter and Chartboost Core iOS Adapter ecosystems.

All actions accept an optional `CHARTBOOST_PLATFORM` environment variable to indicate the platform to which the adapter belongs.

Supported values are: `Mediation` and `Core`.
When no value is provided, `Mediation` is assumed.

When a change is made to any of the actions or scripts, a new version of the actions will need to be released with the [release](https://github.com/ChartBoost/chartboost-ios-adapter-actions/actions/workflows/release.yml) workflow. Bug fixes can be made in a patch version, non-breaking improvements can be made in a minor version, and breaking changes can be made in a major version.

## adapter-smoke-test

Validates changes to an adapter.

### Inputs

| name | type | required | default | discussion |
| ---- | ---- | ---- | ---- | ---- |
| `allow-warnings` | boolean | no | false | Indicates if warnings should be allowed when linting the podspec | 

### Use example

Add to your GitHub workflow:

```
jobs:
  validate-podspec:
    runs-on: macos-latest
    steps:
      - uses: chartboost/chartboost-ios-adapter-actions/adapter-smoke-test@v1
        with:
          allow-warnings: true
```

## create-adapter-release-branch

This action creates a new adapter release branch, validates inputs, applies boilerplate changes, and opens a PR.

### Requirements

- A `GITHUB_TOKEN` environment variable with a GitHub token that has permission to push and create PRs in the adapter repository.

### Use example

Add to your GitHub workflow:

```
env:
  GITHUB_TOKEN: ${{ secrets.GITHUBSERVICETOKEN }}

jobs:
  create-release-branch:
    steps:
      - uses: chartboost/chartboost-ios-adapter-actions/create-adapter-release-branch@v1
        with:
          adapter-version: "4.5.3.0.0"
          partner-version: "~> 5.3.0"
``` 

## release-adapter

This action releases a new adapter version.

### Requirements

- A `GITHUB_TOKEN` environment variable with a GitHub token that has permission to push tags and create GitHub releases in the adapter repository.
- A `COCOAPODS_TRUNK_TOKEN` environment variable with a CocoaPods token that has permission to push new adapter pod versions to trunk.

### Inputs

| name | type | required | default | discussion |
| ---- | ---- | ---- | ---- | ---- |
| `allow-warnings` | boolean | no | false | Indicates if warnings should be allowed when linting the podspec |

### Use example

Add to your GitHub workflow:

```
env:
  GITHUB_TOKEN: ${{ secrets.GITHUBSERVICETOKEN }}
  COCOAPODS_TRUNK_TOKEN: ${{ secrets.COCOAPODS_TRUNK_TOKEN }}

jobs:
  release-adapter:
    steps:
      - uses: chartboost/chartboost-ios-adapter-actions/release-adapter@v1
``` 
