import jobs.generation.Utilities

def project = GithubProject
def branch = GithubBranchName
def isPR = true
def distroList = ['alpine', 'centos/6', 'centos/7', 'debian', 'fedora', 'opensuse', 'ubuntu/14', 'ubuntu/16', 'ubuntu/17']

distroList.each { distro ->
    def(distroName, distroVersion) = distro.tokenize('/')
    if (distroVersion != null) {
        distroName = distroName.concat("_" + distroVersion)
    }

    def newJobName = Utilities.getFullJobName(project, "${distroName}", isPR)

    def newJob = job(newJobName) {
        steps {
            shell("docker build -t runner --pull -f ./Dockerfile.linux.runner .")
            shell("docker run -v /var/run/docker.sock:/var/run/docker.sock runner pwsh -NoProfile -File ./build.ps1 -DockerfilePath \"src/${distro}*\" -CleanupDocker")
        }
    }

    Utilities.setMachineAffinity(newJob, 'Ubuntu16.04', 'latest-or-auto-docker')
    Utilities.standardJobSetup(newJob, project, isPR, "*/${branch}")
    Utilities.addGithubPRTriggerForBranch(newJob, branch, "${distroName}")
}
