#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Microservices/PostService/PostService.API/PostService.API.csproj", "Microservices/PostService/PostService.API/"]
COPY ["Microservices/PostService/PostService.Application/PostService.Application.csproj", "Microservices/PostService/PostService.Application/"]
COPY ["Microservices/Common/Common.csproj", "Microservices/Common/"]
COPY ["Microservices/PostService/PostService.Domain/PostService.Domain.csproj", "Microservices/PostService/PostService.Domain/"]
COPY ["Microservices/PostService/PostService.Infrastructure.Persistence/PostService.Infrastructure.Persistence.csproj", "Microservices/PostService/PostService.Infrastructure.Persistence/"]
RUN dotnet restore "Microservices/PostService/PostService.API/PostService.API.csproj"
COPY . .
WORKDIR "/src/Microservices/PostService/PostService.API"
COPY ./gymly_cert.pem /etc/ssl/certs/server-certificate.pem
RUN dotnet build "PostService.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "PostService.API.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "PostService.API.dll"]
