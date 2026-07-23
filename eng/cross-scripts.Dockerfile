# This image packages the Arcade rootfs cross-build scripts from eng/common/cross.
#
# Microsoft.DotNet.ImageBuilder sets the Docker build context to each Dockerfile's own
# directory, so images that build a rootfs cannot COPY the repo-root eng/common/cross
# directly. Building this tiny image from the eng/ context (this Dockerfile lives at
# eng/cross-scripts.Dockerfile) keeps a single source of truth - the Arcade-synced
# eng/common/cross - while letting other images pull the scripts in via COPY --from.
FROM scratch

COPY common/cross/ /eng/common/cross/
