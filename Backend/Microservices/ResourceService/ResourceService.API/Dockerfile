#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Microservices/ResourceService/ResourceService.API/ResourceService.API.csproj", "Microservices/ResourceService/ResourceService.API/"]
COPY ["Microservices/Common/Common.csproj", "Microservices/Common/"]
RUN dotnet restore "Microservices/ResourceService/ResourceService.API/ResourceService.API.csproj"
COPY . .
WORKDIR "/src/Microservices/ResourceService/ResourceService.API"
RUN dotnet build "ResourceService.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ResourceService.API.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ResourceService.API.dll"]
