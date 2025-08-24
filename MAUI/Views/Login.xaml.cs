using System.Diagnostics;
using System.Text.Json;
using System.Text;
using System.Net.Http;
using System.Net.Http.Json; // Required for PostAsJsonAsync

namespace MAUI.Views;

public class LoginData{
    public string email { get; set; }
    public string password { get; set; }
};
public class JWTResponse
{
  public string token { get; set; }
}
public partial class LoginPage : ContentPage
{

    public async Task HandleLogin()
    {
        var client = new HttpClient();
        client.BaseAddress = new Uri("http://localhost:5000"); // Set the base URL of your API

        var dataToSend = new LoginData { email = Emailentry.Text, password = PasswordEntry.Text };
        HttpResponseMessage response = await client.PostAsJsonAsync("/login", dataToSend);
        Debug.WriteLine("Attempting to login");
        if (response.IsSuccessStatusCode)
        {
            // Request was successful (e.g., 200 OK, 201 Created)
            // Optionally, read the response content if the API returns data
            var result = await response.Content.ReadFromJsonAsync<JWTResponse>();
            Debug.WriteLine($"API response: {result.token}");
        }
        else
        {
            // Request failed, handle the error
            Debug.WriteLine($"Error: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
        }
    }
    public LoginPage()
	{
		InitializeComponent();
	}

    private void LoginBtn_Clicked(object sender, EventArgs e)
    {
        Debug.WriteLine("Login Btn Clicked");
        HandleLogin();

    }
}