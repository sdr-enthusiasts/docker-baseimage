# Next Debian Release Migration

Tracks moving the SDR-E images onto the next Debian release while the current
stable release keeps shipping. Stable is currently **trixie**; the next release
is currently **forky**. Update this file whenever an image changes status. When
the next release becomes stable, reset the tables for the release after it.

## Tag naming

| Image kind                       | Stable tag                           | Next-release tag                        |
| -------------------------------- | ------------------------------------ | --------------------------------------- |
| Base images (`docker-baseimage`) | `:<tag>`                             | `:<codename>-<tag>`, e.g. `forky-base`  |
| Child images, latest             | `:latest`                            | `:next`                                 |
| Child images, other tags         | `:<tag>`                             | `:next-<tag>`, e.g. `next-telegraf`     |
| Child images, per-build          | `:latest-build-N` / `:<tag>-build-N` | `:next-build-N` / `:next-<tag>-build-N` |

- Base images for the next release are built from `forky/` by
  `.github/workflows/deploy_ghcr_forky.yml`.
- Child images use the codename-free `next` tag so the tag users pin to does not
  change from one Debian release to the next.

## Status values

| Status        | Meaning                                                                                  |
| ------------- | ---------------------------------------------------------------------------------------- |
| not started   | Not yet test-built on the next release                                                   |
| builds        | Test-built unchanged on the next release (local, amd64 only)                             |
| fix tested    | Needs a Dockerfile change; change tested locally on the next release, not yet merged     |
| merged        | Deploy accepts the base variant and builds on stable and next; `:next` not yet published |
| blocked       | Cannot build on the next release without upstream work; not moved                        |
| moved         | Deploy accepts the base variant input, builds on stable and next, `:next` is published   |
| not migrating | Deferred or deliberately left on stable only                                             |

## Base images

All published for amd64, arm64 and armv7 by `deploy_ghcr_forky.yml`.

| Image                 | Status    | Changes in `forky/` versus stable                                                              |
| --------------------- | --------- | ---------------------------------------------------------------------------------------------- |
| `base`                | published | `python3-pkg-resources` dropped (removed in setuptools 82); CMake 4 flag for SoapyRTLSDR 0.3.3 |
| `mlatclient`          | published | none                                                                                           |
| `planefence_base`     | published | none                                                                                           |
| `soapy-full`          | published | none                                                                                           |
| `wreadsb`             | published | none                                                                                           |
| `acars-decoder-soapy` | published | `libxml2` runtime package renamed to `libxml2-16`                                              |
| `dump978-full`        | published | Boost 1.83 to 1.92; `libboost-system` dropped (removed in Boost 1.89)                          |

Consumer impact: `pkg_resources` no longer exists on the next release, and Python
moves from 3.13 to 3.14.

## Children of `:base`

Triggered by `trigger_build_base` in `deploy_ghcr.yml`, and, for the merged
repos, with `base_variant=forky` by the same job in `deploy_ghcr_forky.yml`.
Each merged change bumps `sdre.yml` to `6fe78a4` and adds the `base_variant`
input; each was built locally (amd64) on stable `:base` and, through the merged
`apply-base-variant.sh` rewrite, on `forky-base`.

| Repo                       | Status        | Notes                                                                                               |
| -------------------------- | ------------- | --------------------------------------------------------------------------------------------------- |
| docker-acarshub            | merged        | GitHub release job skipped for base variant builds                                                  |
| docker-beast-splitter      | blocked       | Boost 1.87+ removed `asio::io_service` and 1.89 removed `libboost_system`; upstream v11.1 uses both |
| docker-flightradar24       | merged        |                                                                                                     |
| docker-adsbhub             | merged        | Also adds the missing update-flakes workflow and updates `flake.lock`; needs a `PAT` repo secret    |
| docker-planefinder         | merged        |                                                                                                     |
| acars_router               | merged        | Branch made in a separate worktree; the local checkout has uncommitted work                         |
| airspy_adsb                | merged        |                                                                                                     |
| docker-reversewebproxy     | merged        | goaccess apt repo only on bookworm; Debian's goaccess otherwise                                     |
| docker-radar1090           | merged        | GCC 16 `-Wunused-but-set-variable` with `-Werror`; built with `-Wno-error=unused-but-set-variable`  |
| docker-shipfeeder          | merged        | `t64` package names for everything after bookworm; `qemu-arm-static` symlink for qemu 11            |
| docker-aprs-tracker        | merged        | Also fixes triggered deploys building on the stale `:base-test-pr` image                            |
| docker-vesselalert         | merged        |                                                                                                     |
| docker-telegraf-adsb       | merged        |                                                                                                     |
| docker-api2sbs             | merged        |                                                                                                     |
| docker-virtualradarserver  | not migrating | Deferred. Builds on forky, but its deploy does not use `sdre.yml`                                   |
| browser-screenshot-service | merged        |                                                                                                     |

## Other trigger groups

Not started. Listed so nothing is forgotten.

| Base image tag           | Repos                                                                                                                    |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------ |
| `acars-decoder-soapy`    | docker-acarsdec, docker-dumpvdl2, docker-dumphfdl, docker-hfdlobserver, docker-rtlsdrairband                             |
| `soapy-full`             | docker-xng                                                                                                               |
| `planefence_base`        | docker-planefence                                                                                                        |
| `wreadsb` / `mlatclient` | docker-airnavradar, docker-radarvirtuel, docker-tar1090, docker-sdrplay-beast1090, docker-sdrmap, docker-opensky-network |
| `dump978-full`           | docker-dump978, docker-piaware                                                                                           |
| child of tar1090         | docker-adsb-ultrafeeder (dispatched by docker-tar1090, not by this repo)                                                 |

docker-sdrplay-beast1090 has a build stage on `base` and a final stage on
`wreadsb`, so it needs both next-release base images. docker-acars2pos builds on
`base` but is a personal fork and out of scope.

## Infrastructure

- [x] `forky/` Dockerfiles and `build_local.sh forky`
- [x] `deploy_ghcr_forky.yml` builds and publishes the `forky-*` base images
- [x] `common-github-workflows` `sdre.yml`: base variant input (see design below),
      merged in sdr-enthusiasts/common-github-workflows#206 as `6fe78a4`
- [x] Child repos: bump the `sdre.yml` pin and expose the base variant input on `workflow_dispatch` (all 14 migrated `:base` children merged)
- [x] `dispatch-and-capture`: optional input that forwards the base variant only when set
- [x] `deploy_ghcr_forky.yml`: codename defined in one place (the `variant` job); trigger and monitor jobs copied from `deploy_ghcr.yml` with the base variant set, `:base` group only so far
- [ ] User-facing documentation of the `forky-*` and `next` tags

## Design: base variant input in `sdre.yml`

Blank (the default) keeps today's behaviour exactly. When set to a codename such
as `forky`, the reusable workflow:

1. Applies `dockerfile_changes` first, unchanged. Feature toggles such as
   `##telegraf##/` and `FROM` swaps such as `docker-tar1090:latest` to
   `docker-tar1090:telegraf` keep working.
2. Applies the `build_baseimage_url` test redirect second, unchanged.
3. Rewrites image references last, so it composes with whatever steps 1 and 2
   produced. Only `ghcr.io/sdr-enthusiasts/...` references in `FROM`,
   `COPY --from=` and `RUN --mount=...,from=` are touched:
   - `docker-baseimage:<tag>` becomes `docker-baseimage:<codename>-<tag>`, so
     `:base-test-pr` becomes `:forky-base-test-pr`.
   - any other SDR-E image follows the child rule: `:latest` becomes `:next`,
     `:<tag>` becomes `:next-<tag>`.
   - images listed in `base_variant_exclude` are left as written, for images
     that do not depend on the Debian release.
4. Fails if any rewritten reference does not exist in the registry, if a
   reference is pinned by digest, or if there is no SDR-E reference at all, so a
   next build can never silently fall back to a stable image.
5. Publishes `:next` instead of `:latest`, `:next-<tag>` instead of `:<tag>`.

The value is validated as a bare lowercase codename. The rules live in
`.github/actions/apply-base-variant/apply-base-variant.sh` in
common-github-workflows.

Dependencies this surfaced in later trigger groups:

- docker-acarsdec and docker-dumpvdl2 copy a binary from `acars-bridge`, a static
  binary in a `FROM scratch` image. Their next build needs
  `base_variant_exclude: acars-bridge`.
- docker-adsb-ultrafeeder builds `FROM docker-tar1090`, so it cannot build on
  the next release until docker-tar1090 publishes `:next` (and `:next-telegraf`
  for its telegraf build).

## Pre-existing issues found

- `deploy_ghcr.yml`: `acars-decoder-soapy` waits for `wreadsb` but builds `FROM`
  `soapy-full`. Fixed in `deploy_ghcr_forky.yml` only.
- `Dockerfile.dump978-full` (all variants): the `deduplicate.sh` calls point at
  `libboost-*1.74.0` doc directories that no longer exist, so they do nothing.
- The `*-test-pr` base image tags are no longer published by any workflow in this
  repo (last built 2026-06-13), so child `use_test_image` runs build against
  stale images.
- Unanchored test redirects: docker-telegraf-adsb uses `base/base-test-pr`
  (matches any `base`, including `database`); docker-tar1090 uses
  `wreadsb/wreadsb-test-pr`.
- docker-planefence's `build_baseimage_url` replaces a tag with itself, so it
  does nothing.
- docker-beast-splitter, docker-reversewebproxy and docker-shipfeeder choose
  packages with `if codename == trixie ... else <bookworm>`, which sends every
  new release down the bookworm path.

## Decisions

- Base images use the codename prefix (`forky-<tag>`); child images use `next`
  and `next-<tag>`.
- Images that cannot build on the next release are marked blocked and left on
  stable; they are dealt with later.
- Codename checks keep a bookworm branch but test for it explicitly:
  `if codename == bookworm ... else <current packages>`, so new releases take the
  current path.
- docker-virtualradarserver is deferred. docker-acars2pos is out of scope.
- Base variant input name: `base_variant` (blank means stable).

## End of a cycle

When the next release becomes stable and the images are trusted:

1. Move the `forky/` Dockerfiles to the repo root and retire `forky/`; change the
   codename in `deploy_ghcr_forky.yml`'s `variant` job for the following release.
2. Stop publishing `forky-*`. Child `:next` stops updating until the following
   release starts, then points at it again; the tag name never changes.
3. Optionally delete the old `forky-*` versions from ghcr.io (see below).
4. Reset this file for the following release.

Deleting from ghcr.io: a container "version" is one image digest, and deleting it
removes every tag on that digest. GitHub allows deleting a version of a public
package only if that version has 5,000 downloads or fewer; above that it needs
GitHub Support. Deletion works from the package's "Manage versions" page, the
REST API
(`DELETE /orgs/sdr-enthusiasts/packages/container/docker-baseimage/versions/{id}`,
classic token with `delete:packages`), or a workflow whose `GITHUB_TOKEN` has
admin on the package. Deleted versions can be restored for 30 days.
