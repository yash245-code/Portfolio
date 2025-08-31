// this is the main entry point for your C# web app.
// It setups the server and configures how the requests are handled.

var builder = WebApplication.CreateBuilder(args);

// Add service to the container.
builder.Services.AddRazorPages();

var app = builder.Build();

//Configure the HTTP request Pipeline
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();

// This line hepls in the use of HTML CSS and JAVA Script 
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.MapRazorPages();

app.Run();