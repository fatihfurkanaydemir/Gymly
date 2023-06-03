#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Microservices/ChatService/ChatService.API/ChatService.API.csproj", "Microservices/ChatService/ChatService.API/"]
COPY ["Microservices/ChatService/ChatService.Application/ChatService.Application.csproj", "Microservices/ChatService/ChatService.Application/"]
COPY ["Microservices/ChatService/ChatService.Domain/ChatService.Domain.csproj", "Microservices/ChatService/ChatService.Domain/"]
COPY ["Microservices/Common/Common.csproj", "Microservices/Common/"]
COPY ["Microservices/ChatService/ChatService.Infrastructure.Persistence/ChatService.Infrastructure.Persistence.csproj", "Microservices/ChatService/ChatService.Infrastructure.Persistence/"]
RUN dotnet restore "Microservices/ChatService/ChatService.API/ChatService.API.csproj"
COPY . .
WORKDIR "/src/Microservices/ChatService/ChatService.API"
RUN dotnet build "ChatService.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ChatService.API.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ChatService.API.dll"]
