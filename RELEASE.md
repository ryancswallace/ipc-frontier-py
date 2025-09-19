# Release Procedure
To release a new version of the package, follow Semantic Versioning (SemVer) to select the next version number, and then tag and push the release to GitHub. The project's GitHub Actions pipeline takes it from there.

## Step-by-Step Procedure
1. First, select the new version number following [SemVer](https://semver.org/).
2. Use the convenience script `scripts/bumpver.sh` to bump the version in `pyproject.toml`. For example, to update to version `1.2.3`, run `./scripts/bumpver.sh 1.2.3`.
3. Commit the version change, tag the commit, and push to GitHub. The `bumpver.sh` script prints a set of commands to do this. It's almost always easiest to just copy and paste these commands into the terminal to commit, tag, and push.

    Using the example of version `1.2.3`, here are the commands suggested by `bumpver.sh`:
    ```
    $ git add pyproject.toml \
        && git commit -m "chore: bump to version 1.2.3" \
        && git push origin HEAD \
        && git tag -a "v1.2.3" -m "release version 1.2.3" \
        && git push origin "v1.2.3"
    ```