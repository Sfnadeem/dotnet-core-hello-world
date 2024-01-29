# Install .NET SDK
Invoke-WebRequest -Uri https://aka.ms/dotnet-install.ps1 -OutFile dotnet-install.ps1
.\dotnet-install.ps1 -Channel 5.0 -InstallDir "C:\Program Files\dotnet"

# Clone your .NET application repository
git@github.com:Sfnadeem/dotnet-core-hello-world.git

# Build and publish the application
cd dotnet-core-hello-world
dotnet restore
dotnet build

# Optionally, start your application (replace with your actual startup command)
dotnet run

# Ensure the script exits with a success status
exit 0