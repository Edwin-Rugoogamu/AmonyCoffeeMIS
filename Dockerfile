
# Use the official .NET SDK image as a build environment
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env 

# Set the working directory
WORKDIR /app

# Copy the .csproj and restore dependencies
COPY *.csproj ./

# Copy the main application source code
COPY . ./

# Build the application
RUN dotnet publish -c Release -o out

# Use the official runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0 as runtime

# Set the working directory
WORKDIR /app

COPY --from=build-env /app/Data.db .

# Copy the published application
COPY --from=build-env /app/out .

# Specify the entry point for the container
ENTRYPOINT ["dotnet", "AmonyCoffeeMIS.dll"]
