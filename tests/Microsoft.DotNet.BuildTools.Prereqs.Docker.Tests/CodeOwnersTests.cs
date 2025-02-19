// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.
// See the LICENSE file in the project root for more information.

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;

namespace Microsoft.DotNet.BuildToolsPrereqs.Docker.Tests;

public class CodeOwnersTests
{
    private readonly List<(string Line, Regex Pattern, IEnumerable<string> Owners)> codeOwnerEntries = new ();

    public CodeOwnersTests()
    {
        ReadCodeOwnersFile();
    }

    [Fact]
    public void OwnersAreTeams()
    {
        var nonTeamOwners = codeOwnerEntries.Where(e => e.Owners.Any(owner => !owner.Contains("/"))).ToArray();

        if (nonTeamOwners.Any())
        {
            Assert.Fail($"The following CODEOWNER entries have a non-team owner:{Environment.NewLine}" +
                string.Join(Environment.NewLine, nonTeamOwners.Select(e => e.Line)));
        }
    }

    [Fact]
    public void OwnersIncludeDockerReviewers()
    {
        const string dotnetDockerReviewersTeam = "@dotnet/dotnet-docker-reviewers";
        var nonDockerReviewers = codeOwnerEntries.Where(e => !e.Owners.Contains(dotnetDockerReviewersTeam)).ToArray();

        if (nonDockerReviewers.Any())
        {
            Assert.Fail($"The following CODEOWNER entries do not have the required {dotnetDockerReviewersTeam} owner:{Environment.NewLine}" +
                string.Join(Environment.NewLine, nonDockerReviewers.Select(e => e.Line)));
        }
    }

    [Fact]
    public void PathsAreUsed()
    {
        var dockerfiles = GetDockerfilePaths();
        var unusedEntries = codeOwnerEntries.Where(e => !dockerfiles.Any(f => e.Pattern.IsMatch(f))).ToArray();

        if (unusedEntries.Any())
        {
            Assert.Fail($"The following CODEOWNER entries are not used:{Environment.NewLine}" +
                string.Join(Environment.NewLine, unusedEntries.Select(e => e.Line + " " + e.Pattern)));
        }
    }

    [Fact]
    public void DockerfilesHaveOwners()
    {
        var dockerfiles = GetDockerfilePaths();
        var filesWithoutOwner = dockerfiles.Where(f => !codeOwnerEntries.Any(e => e.Pattern.IsMatch(f))).ToArray();

        if (filesWithoutOwner.Any())
        {
            Assert.Fail($"The following Dockerfiles do not have an owner:{Environment.NewLine}" +
                string.Join(Environment.NewLine, filesWithoutOwner));
        }
    }

    private static Regex ConvertGitHubFilePatternToRegex(string pattern)
    {
        // Escape periods
        pattern = pattern.Replace(".", @"\.");

        // A single asterisk matches anything that is not a slash (as long as it is not at the beginning of a pattern)
        if (!pattern.StartsWith("*"))
        {
            pattern = Regex.Replace(pattern, @"([^*]|^)\*([^*]|$)", "$1[^/]*$2");
        }

        // Trailing /** and leading **/ should match anything in all directories
        pattern = pattern.Replace("/**", "/.*").Replace("**/", ".*/");

        // If the asterisk is at the beginning of the pattern or the pattern does not start with a slash, then match everything
        if (pattern.StartsWith("*"))
        {
            pattern = $".{pattern}";
        }
        else if (!pattern.StartsWith("/") && !pattern.StartsWith(".*"))
        {
            pattern = $".*{pattern}";
        }

        // If there is a trailing slash, then match everything below the directory
        if (pattern.EndsWith("/"))
        {
            pattern = $"{pattern}.*";
        }

        pattern = $"^{pattern}$";

        return new Regex(pattern);
    }

    private static IEnumerable<string> GetDockerfilePaths() =>
        Directory.GetFiles(Config.SrcDirectory, "Dockerfile", SearchOption.AllDirectories)
            .Select(f => f.Replace("\\", "/")
            .Substring(Config.RepoDirectory.Length));

    private void ReadCodeOwnersFile()
    {
        var codeOwnersFilePath = Path.Combine(Config.RepoDirectory, "CODEOWNERS");
        var whitespaceRegex = new Regex(@"\s+");

        foreach (var line in File.ReadAllLines(codeOwnersFilePath))
        {
            // Skip blank lines, comments, and * paths
            if (string.IsNullOrWhiteSpace(line) || line.StartsWith("#") || line.StartsWith("*"))
            {
                continue;
            }

            var parts = whitespaceRegex.Split(line, 2);
            if (parts.Length < 2)
            {
                continue;
            }

            var pattern = ConvertGitHubFilePatternToRegex(parts[0].Trim());
            var owners = whitespaceRegex.Split(parts[1]);

            codeOwnerEntries.Add((line, pattern, owners));
        }
    }
}
