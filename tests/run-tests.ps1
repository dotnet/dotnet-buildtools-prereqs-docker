#!/usr/bin/env pwsh
#
# Copyright (c) .NET Foundation and contributors. All rights reserved.
# Licensed under the MIT license. See LICENSE file in the project root for full license information.
#

[cmdletbinding()]
param(
    [string]$VersionFilter,
    [string]$ArchitectureFilter,
    [string]$OSFilter,
    [string]$Registry,
    [string]$RepoPrefix,
    [switch]$DisableHttpVerification,
    [switch]$IsLocalRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# No-op -- No tests to run
