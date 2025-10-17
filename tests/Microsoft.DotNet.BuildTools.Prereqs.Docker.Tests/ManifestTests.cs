// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.
// See the LICENSE file in the project root for more information.

using System.IO;
using System.Linq;
using System.Text.Json;
using Xunit;

namespace Microsoft.DotNet.BuildToolsPrereqs.Docker.Tests;

public class ManifestTests
{
    private const string DefaultArch = "amd64";

    public ITestOutputHelper OutputHelper { get; set; }

    public ManifestTests(ITestOutputHelper outputHelper)
    {
        OutputHelper = outputHelper;
    }

    [Fact]
    public void ValidateFolderStructure()
    {
        var crossArchPrefixes = new HashSet<string> { "amd64", "arm", "loongarch64", "ppc64le", "riscv64", "s390x", "x86" };
        var invalidDockerfilePaths = new List<string>();

        EnumerateManifests((platforms, platform, dockerfilePath, arch) =>
            {
                if (IsCrossDockerfile(dockerfilePath))
                {
                    var lastFolder = Path.GetFileName(dockerfilePath);
                    if (!crossArchPrefixes.Any(prefix => lastFolder.StartsWith(prefix)))
                    {
                        invalidDockerfilePaths.Add(
                            $"Cross Dockerfile path '{dockerfilePath}' does not end with a valid architecture prefixed folder.");
                    }
                }
                else
                {
                    var matchingPlatforms = platforms.Where(p => GetDockerfilePath(p) == dockerfilePath).ToList();
                    if (matchingPlatforms.Count() > 1)
                    {
                        var distinctArchs = matchingPlatforms.Select(p => GetArchitecture(p)).Distinct();
                        if (distinctArchs.Count() > 1 && dockerfilePath.EndsWith(arch))
                        {
                            invalidDockerfilePaths.Add(
                                $"Dockerfile path '{dockerfilePath}' should not end with '{arch}' because it is built for multiple platforms with different architectures.");
                        }
                    }
                    else if (!dockerfilePath.EndsWith(arch))
                    {
                        invalidDockerfilePaths.Add($"Dockerfile path '{dockerfilePath}' should end with an architecture folder '{arch}'.");
                    }
                }
            });

        if (invalidDockerfilePaths.Any())
        {
            Assert.Fail($"Invalid Dockerfile paths:{Environment.NewLine}{string.Join(Environment.NewLine, invalidDockerfilePaths)}");
        }
    }

    [Fact]
    public void ValidateTags()
    {
        var excludedDockerfilePaths = new HashSet<string>
        {
            "src/ubuntu/common/coredeps", // This Dockerfile is built for multiple platforms via BuildArgs
        };

        var invalidTags = new List<string>();

        EnumerateManifests((platforms, platform, dockerfilePath, arch) =>
            {
                if (excludedDockerfilePaths.Contains(dockerfilePath))
                {
                    return;
                }

                // Skip validation if this dockerfile is shared across multiple platforms
                // as there is no easy way to validate the tag structure from the Dockerfile path.
                var matchingPlatforms = platforms.Where(p => GetDockerfilePath(p) == dockerfilePath);
                if (matchingPlatforms.Count() > 1)
                {
                    return;
                }

                string expectedTag = dockerfilePath;
                string dockerfileQualifier = string.Empty;
                if (!dockerfilePath.EndsWith(arch) && !IsCrossDockerfile(dockerfilePath))
                {
                    expectedTag += $"/{arch}";
                    dockerfileQualifier = $" for architecture '{arch}'";
                }

                expectedTag = expectedTag.Substring("src/".Length).Replace("/", "-");
                var tags = platform.GetProperty("tags").EnumerateObject().Select(tag => tag.Name).ToArray();

                if (!tags.Contains(expectedTag))
                {
                    invalidTags.Add(
                        $"Dockerfile '{dockerfilePath}'{dockerfileQualifier} does not have the required '{expectedTag}' tag."
                        + $"{Environment.NewLine}Current tags: {string.Join(", ", tags)}"
                        + $"{Environment.NewLine}Caution: If the {nameof(ValidateFolderStructure)} test fails for this Dockerfile, this may be a false failure.");
                }
            });

        if (invalidTags.Any())
        {
            Assert.Fail($"Invalid tags:{Environment.NewLine}{string.Join(Environment.NewLine, invalidTags)}");
        }
    }

    private void EnumerateManifests(Action<JsonElement[], JsonElement, string, string> action)
    {
        var manifestFiles = Directory.GetFiles(Config.SrcDirectory, "manifest.json", SearchOption.AllDirectories);
        var jsonOptions = new JsonDocumentOptions
        {
            CommentHandling = JsonCommentHandling.Skip,
        };

        foreach (var manifestFile in manifestFiles)
        {
            OutputHelper.WriteLine($"Processing manifest file: {manifestFile}");
            var manifestJson = JsonDocument.Parse(File.ReadAllText(manifestFile), jsonOptions).RootElement;
            var platforms = manifestJson.GetProperty("repos")
                .EnumerateArray()
                .SelectMany(repo => repo.GetProperty("images").EnumerateArray())
                .SelectMany(image => image.GetProperty("platforms").EnumerateArray())
                .ToArray();

            foreach (var platform in platforms)
            {
                string dockerfilePath = GetDockerfilePath(platform);
                string arch = GetArchitecture(platform);

                action(platforms, platform, dockerfilePath, arch);
            }
        }
    }

    private static string GetArchitecture(JsonElement platform)
    {
        string variant = platform.TryGetProperty("variant", out var variantProp) ? variantProp.GetString()! : string.Empty;
        string arch = platform.TryGetProperty("architecture", out var archProp) ? archProp.GetString()! : DefaultArch;

        if (arch == "arm")
        {
            arch += "32";
        }

        return arch + variant;
    }

    private static string GetDockerfilePath(JsonElement platform) => (platform.GetProperty("dockerfile").GetString() ?? string.Empty).TrimEnd('/');

    private static bool IsCrossDockerfile(string dockerfilePath) => dockerfilePath.Contains("/cross/");
}
