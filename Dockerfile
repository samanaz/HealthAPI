FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ["HealthAPI/HealthAPI.csproj", "HealthAPI/"]
RUN dotnet restore "HealthAPI/HealthAPI.csproj"
COPY . .
WORKDIR "/src/HealthAPI"
RUN dotnet build "HealthAPI.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "HealthAPI.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "HealthAPI.dll"]