using System.IO;
using System.Linq;
using System.Text.Json;
using Xunit;

namespace DotNet.BuildToolsPrereqs.Docker.Tests;

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
        //TODO: The repo root should be a runtime config value
        string srcPath = Path.Combine(Directory.GetCurrentDirectory(), "../../../../../src");
        var manifestFiles = Directory.GetFiles(srcPath, "manifest.json", SearchOption.AllDirectories);

        foreach (var manifestFile in manifestFiles)
        {
            OutputHelper.WriteLine($"Processing manifest file: {manifestFile}");
            var manifestJson = JsonDocument.Parse(File.ReadAllText(manifestFile)).RootElement;
            var platforms = manifestJson.GetProperty("repos")
                .EnumerateArray()
                .SelectMany(repo => repo.GetProperty("images").EnumerateArray())
                .SelectMany(image => image.GetProperty("platforms").EnumerateArray())
                .ToArray();

            foreach (var platform in platforms)
            {
                string dockerfilePath = platform.GetProperty("dockerfile").GetString() ?? string.Empty;
                string arch = GetArchitecture(platform);

                if (dockerfilePath.Contains("/cross/"))
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
                    var matchingPlatforms = platforms.Where(p => p.GetProperty("dockerfile").GetString() == dockerfilePath);
                    if (matchingPlatforms.Count() > 1)
                    {
                        if (dockerfilePath.EndsWith(arch))
                        {
                            invalidDockerfilePaths.Add(
                                $"Dockerfile path '{dockerfilePath}' should not end with '{arch}' because it is built for multiple platforms.");
                        }
                    }
                    else if (!dockerfilePath.EndsWith(arch))
                    {
                        invalidDockerfilePaths.Add($"Dockerfile path '{dockerfilePath}' should end with an architecture folder '{arch}'.");
                    }
                }
            }
        }

        if (invalidDockerfilePaths.Any())
        {
            Assert.Fail($"Invalid Dockerfile paths:\n{string.Join("\n", invalidDockerfilePaths)}");
        }
    }

    private string GetArchitecture(JsonElement platform)
    {
        string variant = platform.TryGetProperty("variant", out var variantProp) ? variantProp.GetString()! : string.Empty;
        string arch = platform.TryGetProperty("architecture", out var archProp) ? archProp.GetString()! : DefaultArch;

        if (arch == "arm")
        {
            arch += "32";
        }

        return arch + variant;
    }
}
