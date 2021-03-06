@echo off
@git rev-parse --abbrev-ref HEAD > temp.txt
@set /p branch=<temp.txt
echo 'Branch:' %branch%

dotnet ../tools/sonar-scanner-msbuild/SonarScanner.MSBuild.dll begin \
    /k:"GeneticSharp" \
    /v:%branch% \
    /d:sonar.organization="giacomelli-github" \
    /d:sonar.host.url="https://sonarcloud.io" \
    /d:sonar.login=%GeneticSharp_SonarQube_login% \
    /d:sonar.cs.opencover.reportsPaths="**/*.opencover.xml" \
    /d:sonar.exclusions="**/*Test.cs,**/Samples/*.cs,MainWindow.cs,Program.cs,PropertyEditor.cs" 
  
dotnet clean
dotnet build -c release

dotnet test GeneticSharp.Domain.UnitTests -f netcoreapp2.0 /p:CollectCoverage=true /p:CoverletOutputFormat=opencover
dotnet test GeneticSharp.Extensions.UnitTests -f netcoreapp2.0 /p:CollectCoverage=true /p:CoverletOutputFormat=opencover
dotnet test GeneticSharp.Infrastructure.Framework.UnitTests -f netcoreapp2.0 /p:CollectCoverage=true /p:CoverletOutputFormat=opencover

dotnet ../tools/sonar-scanner-msbuild/SonarScanner.MSBuild.dll end \
    /d:sonar.login=%GeneticSharp_SonarQube_login% 