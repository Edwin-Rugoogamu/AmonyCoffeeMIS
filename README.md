# Instructions

Languages used: C#

Web framework: .NET 7

To run this project, do the following:

Download .NET 7 SDK here - https://dotnet.microsoft.com/en-us/download/dotnet/7.0

Run the installer and in the terminal run: 

```dotnet --version```

Output should show the dotnet version installed



Within VS code terminal, run the following commands:

Build the app:

```dotnet build```

Install certs required for the app to run:

```dotnet dev-certs https --trust```

NB: After running this command, reopen your browser


Run the app: 

```dotnet run```

Access the application on this URL: https://localhost:7208/

<!-- BUILD -->

# How to build and run the application using docker  


   click on a file and name it dockerfile
   configure the dockerfile in the following way

   # Use the official .NET SDK image as a build environment
     FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env 

# Set the working directory
WORKDIR /app

# Copy the .csproj and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the main application source code
COPY . ./

RUN dotnet ef database update

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
 
<!-- build a docker image from the dockerfile by running the following commmand -->
  docker build -t AmonyCoffeeMI .


 <!-- run the image to create a container with the following command -->
  docker run -d -p 8080:80 AmonyCoffeeMI

 #  8080 is where you can access the docker container . you can also decide on using another route eg 5000

  <!-- to configure the databse  -->
  in this case we are using sqlite.
  # pull or build the sqlite docker image to be used as the databse conatiner
  docker pull keinos/sqlite3

  <!-- build a container -->
  docker run -d --name sqlite-container -v /path/to/database:/db keinos/sqlite3

docker exec -it sqlite-container sqlite3 /db/mydatabase.db


   <!-- after having 2 containers one for the application and the other for the database  -->
   # Build a network that can run both containers
      
<!-- Create a Docker network -->
docker network create my-network

 <!-- Run your .NET app container and connect it to the network -->
docker run -d -p 8080:80 --network my-network --name AmonyCoffeeMI AmonyCoffeeMI

<!-- Run another container and connect it to the same network -->
docker run -d --network my-network --name  keinos/sqlite3  keinos/sqlite3



<!-- build a docker-compose.yml file  -->
version: '3'

services:
 AmonyCoffeeMI:
    image: AmonyCoffeeMI
    ports:
      - "8080:80"
    networks:
      - my-network

  keinos/sqlite3:
    image: keinos/sqlite3
    networks:
      - my-network

networks:
  my-network:


# run both containers
   docker-compose up

   


