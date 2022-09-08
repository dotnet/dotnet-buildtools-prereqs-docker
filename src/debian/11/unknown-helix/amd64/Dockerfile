FROM mcr.microsoft.com/dotnet-buildtools/prereqs:debian-11-helix-amd64

USER root

# Fake the Runtime ID
RUN echo 'NAME="Unknown Linux"\nVERSION="999"\nID="unknown"\nVERSION_ID="999"' > /etc/os-release

USER helixbot
