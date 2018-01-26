import jobs.generation.Utilities

def project = GithubProject
def branch = GithubBranchName
def isPR = true
def hostOS = "Ubuntu16.04"
def machineLabel = 'latest-or-auto-docker'
def distroList = ['alpine', 'centos', 'debian', 'fedora', 'opensuse', 'ubuntu']

distroList.each { distro ->
    def newJobName = Utilities.getFullJobName(project, "${distro}", isPR)

    def newJob = job(newJobName) {
        steps {
            shell("docker build --rm -t testrunner -f ./Dockerfile.linux.testrunner . ")
            shell("docker run -v /var/run/docker.sock:/var/run/docker.sock testrunner pwsh -NoProfile -File ./build.ps1 -DockerfilePath \"*${distro}*\" -CleanupDocker")
        }
    }

    Utilities.setMachineAffinity(newJob, hostOS, machineLabel)
    Utilities.standardJobSetup(newJob, project, isPR, "*/${branch}")
    Utilities.addGithubPRTriggerForBranch(newJob, branch, "${distro} Dockerfiles")
}
