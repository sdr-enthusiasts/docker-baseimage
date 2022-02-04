# Github Action Template

## deploy_ghcr.yml template

Add under the `jobs` section.

```yaml
  deploy_<name of your image>:
    name: Deploy <name of your image> to ghcr.io # Modify this line
    needs: [deploy_ghcr_base] # Modify this line.....add in the name of any jobs (aka containers) that your container depends on, comma separated
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:

      # Check out our code
      - name: Checkout
        uses: actions/checkout@v2
        with:
          fetch-depth: 2

      # Log into ghcr (so we can push images)
      - name: Login to ghcr.io
        uses: docker/login-action@v1
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.repository_owner }}
          password: ${{ secrets.GITHUB_TOKEN }}

      # Get metadata from repo
      - name: Extract metadata (tags, labels) for Docker
        id: meta
        uses: docker/metadata-action@v3
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}

      # Set up QEMU for multi-arch builds
      - name: Set up QEMU
        uses: docker/setup-qemu-action@v1

      # Set up buildx for multi platform builds
      - name: Set up Docker Buildx
        id: buildx
        uses: docker/setup-buildx-action@v1

      # Build & Push Dockerfile (only push if this action was NOT triggered by a PR)
      - name: Build & Push ghcr.io/sdr-enthusiasts/docker-baseimage:<your container tag> # Modify this line
        uses: docker/build-push-action@v2
        with:
          context: .
          file: ./<your container's Dockerfile> # Modify this line
          no-cache: true
          platforms: linux/386,linux/amd64,linux/arm/v7,linux/arm/v6,linux/arm64
          push: ${{ github.event_name != 'pull_request' }}
          tags: ghcr.io/sdr-enthusiasts/docker-baseimage:<your container tag> # Modify this line
          labels: ${{ steps.meta.outputs.labels }}
```

## on_pr.yaml template

Copy and paste the exact same yaml job entry you created above, and:

* Change the job name from `Deploy <name of your image> to ghcr.io` to `Test deploy <name of your image> to ghcr.io`
* Add the following under the `Checkout` step

```yaml
      # List of files to check to trigger a rebuild on this job
      - name: Get specific changed files
        id: changed-files-specific
        uses: tj-actions/changed-files@v13.2
        with:
          files: |
            Dockerfile$
            Dockerfile.acars-decoder
            Dockerfile.rtlsdr
```

* Change the list of files in the YAML above to indicate all of the docker files the container is depend on. At a bare minimum all containers will depend on `Dockerfile` *AND* the Dockerfile for the container you are creating. If it depends on an intermediate container (ie `rtlsdr`) add that or any other intermediate containers as further dependencies to check.

* For **EACH STEP AFTER THE `Get specific changed files` STEP** add the following under the `name` of the step

```yaml
if: steps.changed-files-specific.outputs.any_changed == 'true'
```

## Triggering build of upstream image

* Create a GitHub Personal Access Token with `read:org` & `repo` scopes.
* Add the GitHub Personal Access Token to this repo's secrets
* Add the following to `deploy_ghcr.yml`

```yaml
  trigger_build_<github_user/org>-<github_repo_name>: # Modify this line
    name: Trigger deploy of <github_user/org>-<github_repo_name> # Modify this line
    needs: [deploy_<name of your image>] # Modify this line
    runs-on: ubuntu-latest
    env:
          WORKFLOW_AUTH_TOKEN: ${{ secrets.<secret_name> }} # Modify this line with the name of the PAT secret
          WORKFLOW_REPO: <github_user/org>-<github_repo_name> # Modify this line
          WORKFLOW_FILE: <action_file> # Modify this line with the filename of action in the other repo
          WORKFLOW_REASON: "triggered via deploy_ghcr.yml in sdr-enthusiasts/docker-baseimage"
    steps:
      - name: Trigger ${{ env.WORKFLOW_FILE }} in ${{ env.WORKFLOW_REPO }}
        run: |
          echo "$WORKFLOW_AUTH_TOKEN" | gh auth login --with-token
          gh workflow run --ref main --repo "$WORKFLOW_REPO" "$WORKFLOW_FILE" -f reason="$WORKFLOW_REASON"
```

* In the upstream image repo, add the following to your action:

```yaml
on:
  ...
  workflow_dispatch:
    inputs:
      reason:
        required: true
        description: 'Reason for running this workflow'
  ...
```

```yaml
jobs:
  test:
    name: Triggered via Workflow Dispatch?
    # only run this step if workflow dispatch triggered
    # log the reason the workflow dispatch was triggered
    if: |
      github.event_name == 'workflow_dispatch' &&
      github.event.inputs.reason != ''
    runs-on: ubuntu-latest
    steps:
      - name: Log dispatch reason
        env:
          INPUTS_REASON: ${{ github.event.inputs.reason }}
        run: |
          echo "Workflow dispatch reason: $INPUTS_REASON"
  ...
```

The above step will only run if the action is triggered via workflow_dispatch.
