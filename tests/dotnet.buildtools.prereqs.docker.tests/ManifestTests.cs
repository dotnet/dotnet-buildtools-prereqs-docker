using System.IO;
using System.Linq;
using System.Text.Json;
using Xunit;
using Xunit.Abstractions;

namespace dotnet.buildtools.prereqs.docker.tests;

public class ManifestTests
{
    private const string DefaultArchitecture = "amd64";

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
                string architecture = platform.TryGetProperty("architecture", out var archProp) ? archProp.GetString()! : DefaultArchitecture;

                if (dockerfilePath.Contains("/cross/"))
                {
                    // Check that all "cross" dockerfiles end with a folder that starts with an architecture
                    var lastFolder = Path.GetFileName(dockerfilePath);
                    if (!crossArchPrefixes.Any(prefix => lastFolder.StartsWith(prefix)))
                    {
                        invalidDockerfilePaths.Add($"Cross Dockerfile path '{dockerfilePath}' does not end with a valid architecture prefixed folder.");
                    }
                }
                else
                {
                    // If there are multiple platform elements that reference the same Dockerfile,
                    // then the path must not end with an architecture folder
                    var matchingPlatforms = platforms.Where(p => p.GetProperty("dockerfile").GetString() == dockerfilePath);
                    if (matchingPlatforms.Count() > 1)
                    {
                        if (dockerfilePath.EndsWith(architecture))
                        {
                            invalidDockerfilePaths.Add(
                                $"Dockerfile path '{dockerfilePath}' should not end with '{architecture}' because it is built for multiple platforms.");
                        }
                    }
                    else if (!dockerfilePath.EndsWith(architecture))
                    {
                        invalidDockerfilePaths.Add($"Dockerfile path '{dockerfilePath}' should end with an architecture folder '{architecture}'.");
                    }
                }
            }
        }

        if (invalidDockerfilePaths.Any())
        {
            Assert.Fail($"Invalid Dockerfile paths:\n{string.Join("\n", invalidDockerfilePaths)}");
        }
    }
}
