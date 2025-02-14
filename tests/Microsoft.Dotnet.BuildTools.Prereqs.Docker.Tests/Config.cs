// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.
// See the LICENSE file in the project root for more information.

using System;

namespace Microsoft.DotNet.BuildToolsPrereqs.Docker.Tests;

internal static class Config
{
    const string ConfigSwitchPrefix = "Microsoft.DotNet.BuildTools.Prereqs.Docker.Tests.";

    public static string SrcDirectory => (string)AppContext.GetData(ConfigSwitchPrefix + nameof(SrcDirectory))! ?? 
        throw new InvalidOperationException("SrcDirectory must be specified");
}
