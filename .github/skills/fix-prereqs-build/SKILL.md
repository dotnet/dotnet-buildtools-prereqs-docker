---
name: fix-prereqs-build
description: Diagnose and fix failures in the dotnet-buildtools-prereqs-docker Azure DevOps image build, validate the fix with the unofficial test pipeline, and open the appropriate GitHub pull request after the Build stage succeeds. Use when asked to investigate or repair pipeline 1183, a failed prereqs Docker image build, or a network-isolation failure in this repository.
---

# Fix the prereqs Docker image build

Use this skill only in the `dotnet/dotnet-buildtools-prereqs-docker` repository.

## Agency Copilot preflight

This workflow must run from Agency Copilot.

Before doing anything else, verify that a WorkIQ MCP tool is available. The exact tool name may vary, but it must provide access to Microsoft 365/internal engineering documentation.

- If WorkIQ is available, continue.
- If WorkIQ is unavailable, stop and tell the user to rerun the skill from Agency Copilot. Do not substitute a public web search or a cached endpoint list.

Invocation of this skill authorizes creating a branch, committing the focused fix, pushing it to Azure DevOps and GitHub, queueing the test pipeline, and opening the appropriate GitHub pull request after the Build stage succeeds. If the root cause is in Arcade-owned content, it also authorizes opening a focused `dotnet/arcade` pull request. Do not ask for an additional confirmation for those actions. Never force-push.

## Fixed pipeline and repository information

- **Production pipeline:** `dotnet-buildtools-prereqs-docker-official`
  - Definition ID: `1183`
  - URL: `https://dev.azure.com/dnceng/internal/_build?definitionId=1183&_a=summary`
  - YAML: `eng\pipelines\dotnet-buildtools-prereqs-official.yml`
  - Builds `main` and scheduled rebuilds. Normal runs trim unchanged/cached images unless `noCache` is enabled.
- **Test pipeline:** `dotnet-buildtools-prereqs-docker-unofficial`
  - Definition ID: `1529`
  - URL: `https://dev.azure.com/dnceng/internal/_build?definitionId=1529&_a=summary`
  - YAML: `eng\pipelines\dotnet-buildtools-prereqs-unofficial.yml`
  - Has no automatic trigger and is intended for branch validation.
  - Explicitly applies `Permissive,CFSClean,CFSClean2,CFSClean3`.
  - When `noCache` is enabled, `imageBuilder.pathArgs` must select the affected images so the pipeline does not rebuild the entire repository.
- **Azure DevOps repository URL:** `https://dnceng@dev.azure.com/dnceng/internal/_git/dotnet-dotnet-buildtools-prereqs-docker`
- **GitHub repository:** `dotnet/dotnet-buildtools-prereqs-docker`
- **Arcade repository:** `dotnet/arcade`
- **Local image build:** `.\build.ps1 -Paths "<image-path-pattern>"`
- **Azure DevOps REST helpers:** `eng\docker-tools\skill-helpers\`

The centrally applied network policy can be stricter than the policy visible in pipeline YAML. Treat the **Start Network Isolation** task log as authoritative for the effective policies in a run.

## Safety and repository rules

1. Work from the repository root.
2. Run `git status --short` before changing branches or files. Do not discard, overwrite, commit, or push unrelated user changes. If the worktree is not clean and the changes would interfere with this workflow, stop and ask the user how to proceed.
3. Do not make the final product fix in files under `eng\common`; they are synchronized from `dotnet/arcade` and local edits will be overwritten. A direct temporary edit is allowed for downstream validation as described in the Arcade-owned changes workflow below.
4. Keep the fix limited to the failed image's Dockerfile, directly invoked scripts, and related manifest/configuration files.
5. Do not change code merely to trigger a rebuild. Establish an actionable repository cause first.
6. Never add credentials, access tokens, authenticated feed URLs containing secrets, or pipeline log secrets to the repository.

## Arcade-owned changes

Everything under `eng\common` is sourced from [`dotnet/arcade`](https://github.com/dotnet/arcade). When the root cause is in an `eng\common` file:

1. Locate the synchronized file in this repository, then locate its authoritative source and relevant tests in `dotnet/arcade`.
2. For the initial prereqs-specific validation, make the root-cause change directly in the synchronized `eng\common` file on a clearly temporary validation branch. This produces a reviewable source diff and exercises the same script that will eventually flow from Arcade.
3. Prefer that direct temporary edit over rewriting the staged script from a Dockerfile, embedding a textual replacement, or duplicating the Arcade script. Runtime transformations are brittle, obscure the real source change, and make the validated code differ from the eventual Arcade fix.
4. Build locally, push the temporary branch to Azure DevOps, and validate the affected images with pipeline `1529` under Network Isolation.
5. After the downstream behavior is proven, apply or backport the validated change to the authoritative Arcade file, add or update Arcade tests, and open a focused pull request against `dotnet/arcade`. Reference the failing prereqs build and explain which downstream image paths are affected.
6. Keep the direct downstream `eng\common` edit validation-only. Do not submit it as the final product fix or rely on it surviving dependency flow.
7. After the Arcade pull request merges, let the normal Arcade dependency flow bring the change into this repository. Remove any temporary downstream workaround, validate the flowed change with pipeline `1529`, and only then open or update the final prereqs pull request.
8. If the Arcade change cannot be merged or flowed, report the Arcade pull request and dependency flow as the remaining blocker. Do not replace it with a permanent Dockerfile transformation, duplicated script, or direct `eng\common` edit.

## Authenticate and configure the Azure DevOps remote

The repository's Azure DevOps helpers use:

```powershell
az account get-access-token --resource "499b84ac-1321-427f-aa17-267ca6975798"
```

Run `az account show` first. If it fails, stop and tell the user to run `az login`.

Inspect `git remote -v`:

1. If a remote already has the exact Azure DevOps repository URL, use it.
2. Otherwise, if the remote name `azdo` is unused, add it:

   ```powershell
   git remote add azdo https://dnceng@dev.azure.com/dnceng/internal/_git/dotnet-dotnet-buildtools-prereqs-docker
   ```

3. If `azdo` exists with a different URL, do not overwrite it. Ask the user whether to update it or use another remote name.

## Select and inspect the failing build

If the user supplied a build URL or build ID, inspect that build. Otherwise, inspect the latest completed run of definition `1183`.

Validate that a supplied build belongs to definition `1183`. If the latest run succeeded, report that there is no current production build failure and stop unless the user explicitly asks to investigate an older run.

Dot-source the existing helper:

```powershell
. .\eng\docker-tools\skill-helpers\AzureDevOps.ps1
```

Useful REST endpoints are:

- `build/builds?definitions=1183&queryOrder=finishTimeDescending`
- `build/builds/<buildId>`
- `build/builds/<buildId>/timeline`
- `build/builds/<buildId>/logs/<logId>`

The wrapper accepts optional query parameters:

```powershell
$builds = Invoke-AzDORestMethod `
    -Organization dnceng `
    -Project internal `
    -Endpoint "build/builds" `
    -QueryParams @{
        definitions = 1183
        queryOrder = "finishTimeDescending"
        '$top' = 10
    }
```

Use `Show-BuildTimeline.ps1` to identify failed jobs and tasks, then use `Get-BuildLog.ps1` for the relevant log IDs. Prefer focused error sections and log tails over loading every complete log.

Extract and record:

- build ID, source branch, source version, and effective network policies
- failed stage, job, task, image tag, Dockerfile path, and architecture
- the earliest causal error, not only Image Builder's final exception
- any hostname involved in a timeout, DNS failure, refused connection, HTTP failure, or package restore failure

Do not assume every timeout or Docker build error is network isolation. Compare nearby runs, especially runs of the same `sourceVersion`. When using older runs as evidence, inspect their generated matrix or timeline and count only runs where the affected image was actually selected. A successful run that trimmed or skipped the unchanged image says nothing about that image's health. If the same commit alternates between selected-image success and failure, investigate transient infrastructure, base-image, registry, CDN, or architecture issues before editing. Errors such as `exec: "/bin/sh": stat /bin/sh: no such file or directory` across otherwise unrelated Dockerfiles usually point to a bad/transient base-image or registry response rather than a blocked package endpoint.

Do not classify a failure as transient merely because an older run of the same commit succeeded. If two or more recent runs fail with the same causal error, treat the failure as persistent until current evidence proves otherwise. Investigate and reproduce it locally before queueing another pipeline run.

Inspect whether Image Builder retried the Docker build. Count distinct `docker build` invocations and their timestamps rather than repeated BuildKit error summaries, which may duplicate an attempt's output near the end of the log. A job that exhausted several retries over many minutes is stronger evidence of an endpoint outage during that run than a single failed request, but it still does not by itself prove a repository defect.

## Diagnose network-isolation failures

For any timeout or failed connection:

1. Extract the exact hostname from the causal log line.
2. Inspect the run's **Start Network Isolation** and **Stop Network Isolation** tasks. Check **Policy Violations** when present, but treat this output only as supporting evidence. The feature is not reliable enough to prove that no violation occurred: an empty or missing violation report must never rule out network isolation when the causal build log shows a timeout, DNS failure, blocked connection, or other endpoint-access failure.
3. Use WorkIQ to open the current authoritative page:

   `https://eng.ms/docs/cloud-ai-platform/devdiv/one-engineering-system-1es/1es-build/networkisolation/flagged-endpoints`

4. Ask WorkIQ for the complete current endpoint list, including categories, policy waves, wildcard/pattern rules, remediation guidance, and exceptions. Do this for every invocation; do not rely solely on endpoints copied into this skill.
5. Match hostnames exactly and against documented wildcard rules.

The relevant policy families are `CFSClean`, `CFSClean2`, and `CFSClean3`. Common blocked categories include public NuGet, npm, Yarn, PyPI, Cargo, Maven/Gradle, PowerShell Gallery, Docker Hub/GHCR, SourceForge, Linux package mirrors, general mirrors, and tool download sites.

Keep policy classification separate from endpoint availability. A hostname can be absent from the flagged list and explicitly covered by an effective allow rule, yet still time out because the origin service or a CDN edge is unavailable. Conversely, an empty violation report alone does not establish that Network Isolation was uninvolved. Use the flagged list, effective allow/deny rules, connection telemetry, retry history, nearby selected-image runs, and local reproduction together.

When a flagged endpoint is causal:

- Prefer an existing trusted source already used in this repository.
- Prefer Azure Artifacts/CFS feeds for ecosystem packages.
- Prefer `packagefeedproxy.microsoft.io` or the pipeline-provided `NPM_REGISTRY` for npm.
- Preserve the pipeline-provided authenticated `PIP_INDEX_URL`; do not hardcode a credentialed URL.
- Prefer `packages.microsoft.com` where it supplies the required Linux package or repository.
- Search sibling Dockerfiles and git history for an established mirror or internal-feed pattern before introducing a new one.
- Verify that a proposed alternative is not on the current flagged list and is an authoritative or Microsoft-approved source. Do not replace one arbitrary public mirror with another merely because it is currently reachable.
- If no supported alternative exists, stop and report the blocker and documented exception path. Do not silently weaken or remove network-isolation policy.

## Make and validate the fix

Map the failed image tag to its Dockerfile under `src\<distro>\<version>\...`. Read the matching OS manifest and every script copied or invoked by that Dockerfile.

Create a branch from the failed build's source commit. Determine the alias from the signed-in Azure account's user name by taking the part before `@` and sanitizing it for a git branch. If it cannot be determined safely, ask the user for the alias.

Use:

```text
dev/<alias>/fix-build-<buildId>
```

If that remote branch already exists and is unrelated, append a UTC timestamp rather than overwriting it.

Make the smallest root-cause fix. Then:

1. Verify that Docker is fully ready before invoking the repository build:

   ```powershell
   $serverOs = docker version -f "{{ .Server.Os }}"
   if ($LASTEXITCODE -ne 0 -or $serverOs -notin @("linux", "windows")) {
       throw "Docker is not ready."
   }
   ```

   Do not treat a running Docker Desktop process as sufficient; wait for the server API to return a valid OS.

2. Dry-run the affected image selection:

   ```powershell
   .\build.ps1 -Paths "*<relative-image-directory>*" -OptionalImageBuilderArgs "--dry-run"
   ```

   Inspect the output, not only the PowerShell exit code. Some Image Builder failures can be masked by wrapper scripts. Treat `Unhandled exception`, `ERROR: failed to solve`, or missing expected image selections as a failed dry run.

   The pinned Image Builder may fail a local dry run while determining the architecture of a base image because dry-run mode does not execute the required `docker inspect`. If the output shows that specific architecture-detection failure, do not misclassify it as an image-selection failure or a successful dry run. Confirm the path from the generated command and manifest, inspect the base image architecture directly, and continue to the real repository build.

3. Build the affected image locally:

   ```powershell
   .\build.ps1 -Paths "*<relative-image-directory>*"
   ```

   If the Dockerfile requires build arguments normally supplied by the pipeline, derive the non-secret local values from `eng\pipelines\variables\common.yml` and pass them through `-OptionalImageBuilderArgs`. For images using the common Python feeds:

   ```powershell
   .\build.ps1 `
       -Paths "*<relative-image-directory>*" `
       -OptionalImageBuilderArgs "--build-arg PIP_INDEX_URL=https://pypi.org/simple/ --build-arg HELIX_FEED=https://dnceng.pkgs.visualstudio.com/public/_packaging/helix-client-prod/pypi/simple"
   ```

   Never copy an authenticated pipeline URL or token into the command, logs, or repository.

   On some Docker versions, Image Builder may reject an explicitly pulled Docker Hub base because the published reference includes `docker.io/` while the local `RepoDigests` entry omits it. If the failure is specifically this digest-name normalization mismatch, rerun the repository build with `--skip-pulling` after confirming the local tag and digest match the current published digest. Use this only as a local-validation workaround; do not add it to pipeline configuration or use it to bypass a stale base image.

4. Include dependent image paths when the manifest defines a dependency graph.
5. Confirm the output lists every expected locally buildable image under `IMAGES BUILT`.
6. Local Image Builder normally builds only platforms compatible with the current Docker engine architecture. Record any additional architectures that still require pipeline validation.
7. If a manifest or shared configuration changed, run the repository's existing tests with `.\run-tests.ps1`.
8. Inspect `git diff` and confirm only intended files changed.

A successful local Docker build is required before queueing pipeline 1529, but it is not sufficient because local networking does not reproduce Azure DevOps network isolation.

- If Docker is unavailable, fails to start, or the local build cannot be run for an environmental reason, stop and ask the user before queueing the pipeline.
- Do not use Azure DevOps as the first build attempt merely because it can reproduce network isolation.
- Do not push and queue an unchanged commit solely to test a transient-failure hypothesis without first explaining the evidence and obtaining explicit user approval. State clearly that the branch has no source diff.

## Commit, push, and run the test pipeline

Commit only the focused fix with a concise message. Push the branch to the Azure DevOps remote:

```powershell
git push -u <azdo-remote> HEAD
```

Before queueing, show the user a visible launch summary containing:

```text
Branch: <branch>
Source commit: <full SHA>
Source diff: <changed files, or "none — rerun-only validation">
Pipeline: 1529
noCache: true
imageBuilder.pathArgs: <complete string value>
Expected images: <all selected tags/architectures>
```

If `Source diff` is `none`, stop and obtain explicit approval before queueing, even though normal skill invocation authorizes pushing and pipeline execution. Never hide a rerun-only validation behind a newly named but unchanged branch.

Queue definition `1529` from the pushed branch with **Run build with no cache** enabled and an explicit affected-image path filter. Do not rely on clicking the Azure DevOps UI checkbox.

`noCache: true` disables both matrix trimming and build-time caching. Therefore, **never queue this pipeline with `noCache: true` and an empty `imageBuilder.pathArgs`**; that would select every image in the repository.

Build `imageBuilder.pathArgs` from the affected Dockerfile directories:

- Use paths relative to the repository root and omit the trailing `Dockerfile`.
- Prefer the narrowest directory that selects the failed image or dependency graph.
- Add one `--path` argument per independently affected Dockerfile directory. Image Builder supports repeated `--path` arguments and unions the supplied patterns, including paths from different distro families such as Azure Linux and CentOS.
- A shared Dockerfile directory may intentionally select all architectures declared for that platform.
- Path matching is exact unless the value contains `*` or `?`. To select a family below a common parent, include a wildcard, for example `src/azurelinux/3.0/net11.0*`; the plain value `src/azurelinux/3.0/net11.0` does not select descendants.
- Multiple distro families may be validated in one run. Matrix generation separates selected platforms into the appropriate OS/architecture dependency-graph legs.
- After matrix generation, verify that every requested path appears in an intended matrix leg. If a path is absent, first correct its exact path or wildcard pattern. If combining the paths causes a pipeline-specific problem despite the generated matrix being correct, fall back to one targeted run per image or distro family.
- Do not modify `eng\pipelines\variables\common.yml` merely to select images for a test run. Pass the variable when queueing the pipeline.

For example:

```powershell
$imagePaths = @(
    "src/azurelinux/3.0/net11.0/cross/loongarch64"
    "src/azurelinux/3.0/net11.0/cross/riscv64"
)

$imageBuilderPathArgs = ($imagePaths | ForEach-Object {
    "--path '$_'"
}) -join " "

if ([string]::IsNullOrWhiteSpace($imageBuilderPathArgs)) {
    throw "imageBuilder.pathArgs must be non-empty when noCache is true."
}
```

`imageBuilder.pathArgs` is a single string-valued Azure DevOps variable. Represent multiple paths by repeating the `--path` token inside that one string:

```text
--path 'src/azurelinux/3.0/net11.0/cross/loongarch64' --path 'src/centos-stream/10/helix'
```

Do not pass a JSON array, PowerShell array, or comma-separated path list as the variable value.

Set the YAML parameter and runtime variable through the Runs API:

```powershell
$run = Invoke-AzDORestMethod `
    -Organization dnceng `
    -Project internal `
    -Endpoint "pipelines/1529/runs" `
    -Method POST `
    -Body @{
        resources = @{
            repositories = @{
                self = @{
                    refName = "refs/heads/<branch>"
                }
            }
        }
        templateParameters = @{
            noCache = $true
        }
        variables = @{
            "imageBuilder.pathArgs" = @{
                value = $imageBuilderPathArgs
            }
        }
    }
```

`imageBuilder.pathArgs` is consumed by matrix generation, base-image copying, and publishing, so the same selection follows the complete pipeline.

Always verify both settings after queueing:

- The run's template parameters show `noCache` as `true`.
- The run's variables show the complete expected `imageBuilder.pathArgs` string.
- The **Generate platformDependencyGraph Matrix** command contains the expected `--path` arguments and produces only the intended image graphs.

Immediately report the run URL and echo the accepted `noCache` and `imageBuilder.pathArgs` values to the user. Once matrix generation finishes, report the selected image legs. If any value is missing or the generated matrix is broader than intended, cancel the run and correct the queue request. Do not let an unfiltered no-cache build continue.

Monitor the queued run until its **Build** stage completes. The overall pipeline result is not the validation criterion; later Test, Publish, or Post-Build stages may succeed or fail without affecting this workflow.

- Poll `build/builds/<testBuildId>/timeline` at a reasonable interval.
- Find the timeline record whose type is `Stage` and name is `Build`.
- Wait while that stage is pending or in progress; do not report success merely because the pipeline was queued.
- If the Build stage succeeds, validation is complete. Do not wait for later stages and do not treat their failures as a failed fix.
- If an explicitly approved rerun-only validation succeeds with the unchanged source commit, report that no repository fix was required. When local evidence also shows that the current base image is healthy, conclude narrowly that the previously failing external base-image or mirror artifact is no longer being served; do not invent or commit a Dockerfile change.
- If the Build stage fails, inspect its failed jobs, tasks, and causal logs exactly as above.
- Continue fixing, pushing, queueing a new targeted no-cache run, and waiting for its Build stage while the failure is actionable and related to the change.
- Stop only when the Build stage succeeds or when a clear external blocker requires user or service-owner action.

## Open the GitHub pull request

After the targeted **Build** stage succeeds:

1. Determine which repository owns the final fix:
   - For normal prereqs-owned changes, push the validated branch to the GitHub `origin` remote and open a pull request targeting `main` in `dotnet/dotnet-buildtools-prereqs-docker`.
   - For an Arcade-owned change, open or update the pull request in `dotnet/arcade`. Do not open a prereqs pull request containing a permanent workaround for the Arcade-owned file. After the Arcade change flows into this repository, use the generated flow pull request or open a prereqs pull request containing only the flowed change if automation did not create one.
2. Use `gh pr list` to check whether a pull request already exists for the branch. Update the existing pull request rather than creating a duplicate.
3. Include:
   - the production build ID and URL
   - the causal failure and affected image paths
   - the source repository for the fix
   - the test pipeline ID and URL
   - the successful **Build** stage result
   - a note that later stages were intentionally ignored
4. Verify the pull request targets the correct default branch and report its URL. Do not stop after a green Azure DevOps build with only an unreviewed branch.

## Final report

Report:

- production build ID and URL
- failed image(s) and root cause
- network endpoint involved and whether it matched the current flagged list
- files changed
- Azure DevOps branch and commit
- test pipeline build ID and URL, plus the **Build stage** result
- GitHub pull request URL
- Arcade pull request and dependency-flow status when `eng\common` owns the fix
- note that later stage results were intentionally ignored
- any remaining blocker or follow-up required
