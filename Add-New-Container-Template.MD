# Github Action Template

## deploy_ghcr.yml template

* Add under the `jobs` section:

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

* Add under the `jobs` section:

```yaml
  deploy_ghcr_<name of your image>:
    name: Test deploy <name of your image> to ghcr.io # Modify this line
    # Define any dependent steps
    needs: [deploy_ghcr_base] # Modify this line.....add in the name of any jobs (aka containers) that your container depends on, comma separated
    # Define dockerfile and image tag
    env:
      DOCKERFILE: Dockerfile.<your dockerfile extension> # Modify this line
      TAG: <name of your image> # Modify this line
    permissions:
      contents: read
      packages: write
    runs-on: ubuntu-latest
    # Define output (used to clean-up PR images pushed to ghcr.io)
    outputs:
      cleanupinfo: ${{ steps.set-output.outputs.cleanupinfo }}
    steps:
      # Check out our code
      - name: Checkout
        uses: actions/checkout@v2
      # List of files to check to trigger a rebuild on this job
      - name: Get specific changed files
        id: changed-files-specific
        uses: tj-actions/changed-files@v14.3
        # Add dependent dockerfiles below the ${{ env.DOCKERFILE }} entry, one per line
        with:
          files: |
            ${{ env.DOCKERFILE }}
            Dockerfile.base
      - name: Get changed status of parent
        id: changed-files-parent
        uses: tj-actions/changed-files@v14.3
        # Add dependent dockerfiles, one per line
        with:
          files: |
            Dockerfile.base
      # Log into ghcr (so we can push images)
      - name: Login to ghcr.io
        if: steps.changed-files-specific.outputs.any_changed == 'true'
        uses: docker/login-action@v1
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.repository_owner }}
          password: ${{ secrets.GITHUB_TOKEN }}
      # Get metadata from repo
      - name: Extract metadata (tags, labels) for Docker
        if: steps.changed-files-specific.outputs.any_changed == 'true'
        id: meta
        uses: docker/metadata-action@v3
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
      # Set up QEMU for multi-arch builds
      - name: Set up QEMU
        if: steps.changed-files-specific.outputs.any_changed == 'true'
        uses: docker/setup-qemu-action@v1
      # Patch dockerfile to pull from PR-generated image
      - name: Patch dockerfile
        if: steps.changed-files-parent.outputs.any_changed == 'true'
        id: patch-dockerfile
        env:
          SED_SEARCH: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          SED_TO_APPEND: -test-pr-${{github.event.pull_request.number}}
        run: |
          set -x
          sed -i "/^FROM ${SED_SEARCH//\//\\/}/ s/$/${SED_TO_APPEND}/" "$DOCKERFILE"
          grep '^FROM ' "$DOCKERFILE"
      # Set up buildx for multi platform builds
      - name: Set up Docker Buildx
        if: steps.changed-files-specific.outputs.any_changed == 'true'
        id: buildx
        uses: docker/setup-buildx-action@v1
      # Build & Push
      - name: Test Build & Push ${{ env.IMAGE_NAME }}:${{ env.TAG }}
        if: steps.changed-files-specific.outputs.any_changed == 'true'
        uses: docker/build-push-action@v2
        with:
          context: .
          file: ${{ env.DOCKERFILE }}
          no-cache: true
          platforms: linux/386,linux/amd64,linux/arm/v7,linux/arm/v6,linux/arm64
          push: true
          # Append "-test-pr-XXX" to image name
          tags: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ env.TAG }}-test-pr-${{github.event.pull_request.number}}
          labels: ${{ steps.meta.outputs.labels }}
      # Set output variable for dynamic matrix in clean-up steps
      - name: Set clean-up info
        if: steps.changed-files-specific.outputs.any_changed == 'true'
        id: set-output
        run: echo "cleanupinfo=$TAG" >> $GITHUB_OUTPUT
```

* Under the `matrix:` job, under the `needs:` section, add the job id from the job in the previous step
* Under the `matrix:` job, under the `env:` section:
    * Add a new env var `DEPLOY_<IMAGE_NAME>`, set to `${{ needs.deploy_<your image name>.outputs.cleanupinfo }}`
* Under the `matrix:` job, under the `steps:` section, under the `run:` section, add an if statement with the same format as the others.

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
