namespace wgud424_maui.Views;

using System;
using System.Diagnostics;
using System.Net.Http;
using System.Net.Http.Json; // Required for PostAsJsonAsync
using System.Text;
using CommunityToolkit.Maui.Alerts;
using CommunityToolkit.Maui.Core;

public class LoginData
{
    public string email { get; set; }
    public string password { get; set; }
};
public class JWTResponse
{
    public string token { get; set; }
}
public partial class LoginModal : ContentPage
{
    MainPage parent;
    string text = "Login Failure Please try again";
    ToastDuration duration = ToastDuration.Short;
    double fontSize = 14;

    public LoginModal(MainPage parg)
	{
        parent = parg;
		InitializeComponent();
	}
    public async Task HandleLogin()
    {
        try
        {
            var dataToSend = new LoginData { email = Emailentry.Text, password = PasswordEntry.Text };
            HttpClient client = new HttpClient();

            HttpRequestMessage message = new HttpRequestMessage(HttpMethod.Post, "https://king-prawn-app-y5xwb.ondigitalocean.app/login");
            message.Content = JsonContent.Create<LoginData>(dataToSend);

            HttpResponseMessage response = await client.SendAsync(message);
            // response.StatusCode = System.Net.HttpStatusCode.Unauthorized;
            if (response.IsSuccessStatusCode)
            {
                // Request was successful (e.g., 200 OK, 201 Created)
                // Optionally, read the response content if the API returns data
                var result = await response.Content.ReadFromJsonAsync<JWTResponse>();
                Debug.WriteLine($"API response: {result.token}");
                await SecureStorage.Default.SetAsync("JWT", result.token);
                parent.GetData();
                Navigation.PopModalAsync();
            }
            else
            {
                // Request failed, handle the error
                var toast = Toast.Make(text, duration, fontSize);
                toast.Show();
                Debug.WriteLine($"Error: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
            }

        }catch(Exception e)
        {
            Debug.WriteLine(e.Message);
        }

 
    }
    private void LoginBtn_Clicked(object sender, EventArgs e)
    {
        Debug.WriteLine("Login Btn Clicked");
        HandleLogin();

    }
}