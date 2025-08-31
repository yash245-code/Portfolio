# This script performs a full, automated migration from a static HTML/CSS/JS
# project to a C# ASP.NET Core Razor Pages application.

Write-Host ""
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "  Automated C# Project Migration Script (PowerShell)" -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This will restructure, create all new files, and migrate your HTML content."
Write-Host ""

# --- Step 1: Restructure the directories ---
Write-Host "[1/5] Restructuring directories with 'git mv'..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path "Pages" -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path "wwwroot" -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path "wwwroot/css" -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path "wwwroot/js" -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path "wwwroot/images" -ErrorAction SilentlyContinue

git mv style.css wwwroot/css/style.css
git mv script.js wwwroot/js/script.js
git mv Data/Images/upperTabImages wwwroot/images/
Remove-Item -Path "Data/Images" -Recurse
Remove-Item -Path "Data" -Recurse
git mv index.html index.html.bak
Write-Host "    ... Restructuring complete."

# --- Step 2: Read and parse the original HTML file ---
Write-Host "[2/5] Reading and parsing 'index.html.bak'..." -ForegroundColor Yellow
$htmlPath = ".\index.html.bak"
if (-not (Test-Path $htmlPath)) {
    Write-Host "ERROR: index.html.bak not found! Make sure you run this script in the project root." -ForegroundColor Red
    exit
}
$htmlContent = Get-Content -Path $htmlPath -Raw

# Extract the <head> content, keeping the original link for now
$headContent = ""
if ($htmlContent -match '(?s)<head>(.*?)</head>') {
    $headContent = $Matches[1]
    # Replace the old CSS path with the new Razor path
    $headContent = $headContent -replace '<link rel="stylesheet" href="Data/style.css">', '<link rel="stylesheet" href="~/css/style.css" />'
}

# Extract the navigation section (<section id="home">)
$navigationSection = ""
if ($htmlContent -match '(?s)(<section id="home">.*?</section>)') {
    $navigationSection = $Matches[1]
}

# Extract the main content (everything in <body> AFTER the navigation section)
$mainContent = ""
if ($htmlContent -match '(?s)<section id="home">.*?</section>(.*?)</body>') {
    $mainContent = $Matches[1].Trim()
}
Write-Host "    ... HTML content parsed successfully."


# --- Step 3: Define the content for the new project files ---
Write-Host "[3/5] Preparing new C# project files..." -ForegroundColor Yellow

# .csproj File
$csprojContent = @"
<Project Sdk="Microsoft.NET.Sdk.Web">

  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
  </PropertyGroup>

</Project>
"@

# Program.cs File
$programCsContent = @"
var builder = WebApplication.CreateBuilder(args);
builder.Services.AddRazorPages();
var app = builder.Build();
if (!app.Environment.IsDevelopment()) { app.UseExceptionHandler("/Error"); app.UseHsts(); }
app.UseHttpsRedirection();
app.UseStaticFiles(); // Enables CSS, JS, and images from wwwroot
app.UseRouting();
app.UseAuthorization();
app.MapRazorPages();
app.Run();
"@

# _Layout.cshtml File
$layoutContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
$headContent
</head>
<body>
    $navigationSection

    <div class="container">
        <main role="main" class="pb-3">
            @RenderBody()
        </main>
    </div>

    <script src="~/js/script.js"></script>
    @await RenderSectionAsync("Scripts", required: false)
</body>
</html>
"@

# Index.cshtml File
$indexCshtmlContent = @"
@page
@model IndexModel
@{
    ViewData["Title"] = "Home page";
}

$mainContent
"@

# Index.cshtml.cs File
$indexModelContent = @"
using Microsoft.AspNetCore.Mvc.RazorPages;

public class IndexModel : PageModel
{
    public void OnGet() { }
}
"@

# _ViewImports.cshtml File
$viewImportsContent = @"
@using Microsoft.AspNetCore.Mvc.TagHelpers
@addTagHelper *, Microsoft.AspNetCore.Mvc.TagHelpers
"@

Write-Host "    ... File content is ready."


# --- Step 4: Write the new files to the disk ---
Write-Host "[4/5] Writing all new project files..." -ForegroundColor Yellow
Set-Content -Path "PortfolioApp.csproj" -Value $csprojContent
Set-Content -Path "Program.cs" -Value $programCsContent
Set-Content -Path "Pages/_Layout.cshtml" -Value $layoutContent
Set-Content -Path "Pages/Index.cshtml" -Value $indexCshtmlContent
Set-Content -Path "Pages/Index.cshtml.cs" -Value $indexModelContent
Set-Content -Path "Pages/_ViewImports.cshtml" -Value $viewImportsContent
Write-Host "    ... All files created."


# --- Step 5: Final instructions ---
Write-Host "[5/5] Finalizing..." -ForegroundColor Yellow
Write-Host ""
Write-Host "=====================================================" -ForegroundColor Green
Write-Host "  Migration Complete!" -ForegroundColor Green
Write-Host "=====================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Your project has been fully converted to an ASP.NET Core application." -ForegroundColor Yellow
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Review the generated files in the 'Pages' folder to ensure the content was migrated correctly."
Write-Host "2. Run 'dotnet run' in the terminal to start your new web app."
Write-Host "3. Once you're happy, remove the backup file with: git rm index.html.bak"
Write-Host "4. Commit your new project to GitHub: git add .  then  git commit -m `"feat: Complete migration to C# ASP.NET Core`""
Write-Host ""
