# Chartboost Mediation iOS Actions
Repository of GitHub Actions for the Chartboost Mediation iOS Adapter ecosystem.

## adapter-smoke-test

Validates changes to an adapter.

### Use example

Add to your GitHub workflow:

```
jobs:
  validate-podspec:
    runs-on: macos-latest
    steps:
      - uses: chartboost/chartboost-mediation-ios-actions/adapter-smoke-test@v1
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
      - uses: chartboost/chartboost-mediation-ios-actions/create-adapter-release-branch@v1
        with:
          adapter-version: "4.5.3.0.0"
          partner-version: "~> 5.3.0"
``` 

## release-adapter

This action releases a new adapter version.

### Requirements

- A `GITHUB_TOKEN` environment variable with a GitHub token that has permission to push tags and create GitHub releases in the adapter repository.
- A `COCOAPODS_TRUNK_TOKEN` environment variable with a CocoaPods token that has permission to push new adapter pod versions to trunk.

### Use example

Add to your GitHub workflow:

```
env:
  GITHUB_TOKEN: ${{ secrets.GITHUBSERVICETOKEN }}
  COCOAPODS_TRUNK_TOKEN: ${{ secrets.COCOAPODS_TRUNK_TOKEN }}

jobs:
  release-adapter:
    steps:
      - uses: chartboost/chartboost-mediation-ios-actions/release-adapter@v1
``` 
